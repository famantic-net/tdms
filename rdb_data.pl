#!/usr/bin/env perl

use DBI;
use Getopt::Std;

#getopts("E:cdelx:", \%opts);
#$envpass = $opts{E} if $opts{E};
#$commit = true if $opts{c};
getopts("mp", \%opts);
$populate = true if $opts{p};
$metadata = true if $opts{m};


#$dbh = DBI->connect('dbi:Pg:dbname=DB2REP;
#                        host=localhost;
#                        port=5432',
#                        'nenant',
#                        '',
#                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
#                    );
$dbh = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=10.46.117.29;
                        port=5432',
                        'nenant',
                        'Nen00ant',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
#@tables = $dbh->tables();
#for $table (@tables) {
#    print "$table\n";
#}
#@books = @{ $dbh->selectall_arrayref("SELECT * FROM books",  { Slice => {} }) };
#for $book (@books) {
#    print "$book->{title}\n";
#}

%types = (
    1 => "SQL_CHAR",           
    2 => "SQL_NUMERIC",        
    3 => "SQL_DECIMAL",        
    4 => "SQL_INTEGER",        
    5 => "SQL_SMALLINT",       
    6 => "SQL_FLOAT",          
    7 => "SQL_REAL",           
    8 => "SQL_DOUBLE",         
    9 => "SQL_DATE",           
   10 => "SQL_TIME",           
   11 => "SQL_TIMESTAMP",      
   12 => "SQL_VARCHAR",        
   -1 => "SQL_LONGVARCHAR",    
   -2 => "SQL_BINARY",         
   -3 => "SQL_VARBINARY",      
   -4 => "SQL_LONGVARBINARY",  
   -5 => "SQL_BIGINT",         
   -6 => "SQL_TINYINT",        
   -7 => "SQL_BIT",            
   -8 => "SQL_WCHAR",          
   -9 => "SQL_WVARCHAR",       
  -10 => "SQL_WLONGVARCHAR",   
);

sub error_handler {
    
    if ($@ =~ m/ORA-12154/i )
    {
        #handle this error, so I can clean up and continue
        warn "$DBI::errstr\n";
        return;
    }
    elsif ( $@ =~ m/SOME \s* other \s* ERROR \s+ string/ix )
    {
       #I can't handle this error, but I can translate it
        die "our internal error code #7";
    }
    else 
    {
      die $@; #re-throw the die
    }
}


### Create a new statement handle to fetch table information
my $tabsth = $dbh->table_info();

### Iterate through all the tables...
while ( my ( $qual, $owner, $name, $type ) = $tabsth->fetchrow_array() ) {
    
    next if $owner ne "public";
    my $skip = 0;
    
    ### The table to fetch data for
    my $table = $name;
    
    ### Build the full table name with quoting if required
    $table = qq{"$owner"."$table"} if defined $owner;
    
    if ($metadata) {
        ### The SQL statement to fetch the table metadata
        my $statement = "SELECT * FROM $table limit 1";
        
        print "\n";
        print "Table Information\n";
        print "=================\n\n";
        print "Statement:     $statement\n";
        
        ### Prepare and execute the SQL statement
        my $sth = eval { $dbh->prepare( $statement ) };
        if ($@) {
            error_handler;
            $skip = 1;
        }
            #or warn "Can't prepare SQL statement: $DBI::errstr\n"
            #and $skip = 1;
        eval { $sth->execute() };
        if ($@) {
            error_handler;
            $skip = 1;
        }
            #or warn "Can't execute SQL statement: $DBI::errstr\n"
            #    and $skip = 1;
        unless ($skip) {
            my $fields = $sth->{NUM_OF_FIELDS};
            print "NUM_OF_FIELDS: $fields\n\n";
            
            print "Column Name                                Type            Precision  Scale  Nullable?\n";
            print "------------------------------             ----            ---------  -----  ---------\n\n";
            
            ### Iterate through all the fields and dump the field information
            for ( my $i = 0 ; $i < $fields ; $i++ ) {
            
                my $name = $sth->{NAME}->[$i];
            
                ### Describe the NULLABLE value
                my $nullable = ("No", "Yes", "Unknown")[ $sth->{NULLABLE}->[$i] ];
                ### Tidy the other values, which some drivers don't provide
                my $scale = $sth->{SCALE}->[$i];
                my $prec  = $sth->{PRECISION}->[$i];
                my $type  = $sth->{TYPE}->[$i];
            
                ### Display the field information
                printf "%-30s %20s (%3d)        %4d   %4d   %s\n",
                        $name, $types{$type}, $type, $prec, $scale, $nullable;
            }
            
            ### Explicitly deallocate the statement resources
            ### because we didn't fetch all the data
        }
        $sth->finish();
    }
    elsif ($populate) {
        my @row;
        
        ### The SQL statement to fetch 20 random rows from each table
        my $statement = "SELECT * FROM $table order by random() limit 20;";

        print "\n";
        print "Table Information\n";
        print "=================\n\n";
        print "Statement:     $statement\n";
        
        ### Prepare and execute the SQL statement
        my $sth = eval { $dbh->prepare( $statement ) };
        if ($@) {
            error_handler;
            $skip = 1;
        }
            #or warn "Can't prepare SQL statement: $DBI::errstr\n"
            #and $skip = 1;
        eval { $sth->execute() };
        if ($@) {
            error_handler;
            $skip = 1;
        }
        unless ($skip) {
            my $result_table_ref = $sth->fetchall_arrayref;
            #print @{${$result_table_ref}[0]};
            #print "@{[ $#{${$result_table_ref}[0]} + 1 ]} fields\n";
            print "$sth->{NUM_OF_FIELDS} fields\n";
            #for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            #    print $sth->{NAME}->[$i];
            #}
            #for my $field (@{${$result_table_ref}[0]}) {
            #    print "($field)"
            #}
            #$sth = $dbh->prepare(“insert into table values (?, ?, ?)”);
            my $ins = "insert into $table values (";
            for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
                $ins .= "?, ";
            }
            $ins =~ s/, $//;
            $ins .= ");";
            print "$ins\n";
            for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
                print "(${${$result_table_ref}[0]}[$i])";
            }
            #for my $row (@{$result_table_ref}) {
            #    print @{$row};
            #}
        }
    }
}
### Disconnect from the database
$dbh->disconnect();
