#!/usr/bin/env perl
=pod

=head1 Purpose

Helper functions for Test Data Management System work.

=head1 Options

=over

=item -c

Counts the number of row in each table

=item -d

Truncates, ie deletes all rows, in all tables. Implies C<-l>.

=item -l

Perform the action locally, ie on the machine where the script runs.

=item -m

Display metadata for all tables.

=item -p

Populate local tables. This will fetch 100 random rows for each table from RDB.

Note, the tables will not be coherent, ie no consideration is made that the keys
correspond between tables.

=item -r

Roll dates, i.e update certain timestamps.

=item -t

Display fileds that are defined as C<SQL_TIMESTAMP> from all tables.

=back

=head1 Examples

C<rdb_data.pl -lm>

=over 4

Show metadata for the local RDB replica.

=back

C<rdb_data.pl -p>

=over 4

(Pseudo) populate the local RDB replica.

Use F<rdb2testdb.pl> for proper coherent population.

=back

C<rdb_data.pl -lc>

=over 4

Display a count of rows for each table in the local RBD replica.

=back

C<rdb_data.pl -d>

=over 4

Truncate all local tables.

=back

=cut

use DBI;
use Getopt::Std;

#getopts("E:cdelx:", \%opts);
#$envpass = $opts{E} if $opts{E};
#$commit = 1 if $opts{c};
getopts("cdlmprt", \%opts);
$localdb = 1 if $opts{l};
$metadata = 1 if $opts{m};
$count = 1 if $opts{c};
$populate = 1 if $opts{p};
$roll_dates = 1 if $opts{r};
$timestamps = 1 if $opts{t};
$truncate = 1 if $opts{d};

$localdb = 1 if $truncate or $roll_dates;


sub error_handler {
    
    if ($@ =~ m/already exists/i or $@ =~ m/permission denied/i)
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


$dbh_local = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=127.0.0.1;
                        port=5432',
                        'db2moto',
                        '',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
unless ($localdb) {
    $dbh_rdb = DBI->connect('dbi:Pg:dbname=DB2REP;
                            host=10.46.117.29;
                            port=5432',
                            'nenant',
                            'nenant',
                            {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                        );
}
#@tables = $dbh_rdb->tables();
#for $table (@tables) {
#    print "$table\n";
#}
#@books = @{ $dbh_local->selectall_arrayref("SELECT * FROM books",  { Slice => {} }) };
#for $book (@books) {
#    print "$book->{title}\n";
#}


unless ($localdb) {
    ### Create a new statement handle to fetch table information
    $tabsth = $dbh_rdb->table_info();
}
else {
    $tabsth = $dbh_local->table_info();
}

### Iterate through all the tables...
while ( my ( $qual, $owner, $name, $type ) = $tabsth->fetchrow_array() ) {
    
    next if $owner ne "public";
    my $skip = 0;
    
    ### The table to fetch data for
    my $table = $name;
    
    ### Build the full table name with quoting if required
    $table = qq{$owner."$table"} if defined $owner;
    
    unless ($timestamps or $roll_dates) {
        print "\n";
        print "Table Information\n";
        print "=================\n";
        print "$table\n";
    }

    SWITCH: {
        $metadata && do {
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            
            # Primary keys
            # https://wiki.postgresql.org/wiki/Retrieve_primary_key_columns
            my $statement = qq(SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type
                FROM   pg_index i
                JOIN   pg_attribute a ON a.attrelid = i.indrelid
                                     AND a.attnum = ANY(i.indkey)
                WHERE  i.indrelid = '$table'::regclass
                AND    i.indisprimary;);
            $sth = $dbh->prepare( $statement );
            $sth->execute();
            my $pkey_arr_ref = $sth->fetchall_arrayref;
            unless ($#{$pkey_arr_ref} < 0) {
                for my $pkey (@{$pkey_arr_ref}) {
                    # The key name is in the first element
                    print "Pkey: @{$pkey}\n";
                }
            }
            else {
                print "=== No primary keys defined ===\n";
            }
            ### The SQL statement to fetch the table metadata
            $statement = "SELECT * FROM $table limit 1";
            print "Statement:     $statement\n";
            
            ### Prepare and execute the SQL statement
            $sth = $dbh->prepare( $statement );
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
            }
            ### Explicitly deallocate the statement resources
            ### because we didn't fetch all the data
            $sth->finish();
            last SWITCH;
        };
        $roll_dates && do {
            if ($table =~ m/actx_ftax/) {
                # Primary keys
                # https://wiki.postgresql.org/wiki/Retrieve_primary_key_columns
                my $pkey_statement = qq(SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type
                    FROM   pg_index i
                    JOIN   pg_attribute a ON a.attrelid = i.indrelid
                                         AND a.attnum = ANY(i.indkey)
                    WHERE  i.indrelid = '$table'::regclass
                    AND    i.indisprimary;);
                my $sth = $dbh_local->prepare( $pkey_statement );
                $sth->execute();
                my $pkey_arr_ref = $sth->fetchall_arrayref;
                my @pkeys;
                for my $pkey (@{$pkey_arr_ref}) {
                    # The key name is in the first element
                    #print "Pkey: ${$pkey}[0]\n";
                    push @pkeys, ${$pkey}[0];
                }
                
                my $roll_field = "ar_sek_tax_from";
                # my $statement = "SELECT ar_sek_tax_from, orgnr, lnr, priotax, prioandel, priolnr FROM $table";
                my $fetch_statement = "SELECT $roll_field, @{[ join ',', @pkeys ]} FROM $table";
                $sth = $dbh_local->prepare( $fetch_statement ) ;
                $sth->execute();
                my $result_table_ref = $sth->fetchall_arrayref;
                for my $row (@{$result_table_ref}) {
                    #print @{$row}, "\n";
                    push @rolled_year, ${$row}[0] + 1;
                }
                
                my $put_statement = "UPDATE $table SET $roll_field = ? WHERE ";
                for my $pkey (@pkeys) {
                    # print "Index is: $index\n";
                    $put_statement .= "$pkey = ? AND ";
                }
                $put_statement =~ s/ AND $//;
                $put_statement .= ";";
                print "$put_statement\n";
                $sth = $dbh_local->prepare($put_statement);
                my $line = 0;
                my $put_row;
                for my $row (@{$result_table_ref}) {
                    #print "$rolled_year[$line] @{$row}\n";
                    $put_row = "$rolled_year[$line] ";
                    for (my $i=1; $i<=$#{$row}; $i++) {
                        $put_row .= " ${$row}[$i]";
                    }
                    print "Inserting $put_row\n";
                    $sth->execute(split /\s+/, $put_row);
                    $line++;
                }
                $sth->finish();
            }
            last SWITCH;
        };
        $count && do {
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            my $statement = "SELECT count(*) FROM $table";
            my $sth = eval { $dbh->prepare( $statement ) };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            eval { $sth->execute() };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            unless ($skip) {
                my $result_table_ref = $sth->fetchall_arrayref;
                print "Number of rows: @{${$result_table_ref}[0]}\n";
            }
            last SWITCH;
        };
        $timestamps && do {
            my $found;
            my @timestamps;
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            my $statement = "SELECT * FROM $table limit 1";
            my $sth = eval { $dbh->prepare( $statement ) };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            eval { $sth->execute() };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            unless ($skip) {
                my $fields = $sth->{NUM_OF_FIELDS};
                for ( my $i = 0 ; $i < $fields ; $i++ ) {
                    if ($types{$sth->{TYPE}->[$i]} eq "SQL_TIMESTAMP") {
                        $found = 1;
                        push @timestamps, $sth->{NAME}->[$i];
                    }
                }
                print "$table\n@timestamps\n\n" if $found;
            }
            $sth->finish();
            last SWITCH;
        };
        $populate && do {
            my @row;
            
            ### The SQL statement to fetch random rows from each table
            my $statement = "SELECT * FROM $table order by random() limit 100;";
            print "Statement:     $statement\n";
            
            ### Prepare and execute the SQL statement
            my $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
            if ($@) {
                error_handler;
                $skip = 1;
            }
                #or warn "Can't prepare SQL statement: $DBI::errstr\n"
                #and $skip = 1;
            eval { $sth_rdb->execute() };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            unless ($skip) {
                my $result_table_ref = $sth_rdb->fetchall_arrayref;
                #print @{${$result_table_ref}[0]};
                #print "@{[ $#{${$result_table_ref}[0]} + 1 ]} fields\n";
                print "$sth_rdb->{NUM_OF_FIELDS} fields\n";
                #for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                #    print $sth_rdb->{NAME}->[$i];
                #}
                #for my $field (@{${$result_table_ref}[0]}) {
                #    print "($field)"
                #}
                #$sth_local = $dbh_local->prepare(“insert into table values (?, ?, ?)”);
                my $ins = "insert into $table values (";
                for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                    $ins .= "?, ";
                }
                $ins =~ s/, $//;
                $ins .= ");";
                print "$ins\n";
                my $sth_local = eval { $dbh_local->prepare($ins) };
                if ($@) {
                    error_handler;
                    $skip = 1;
                }
                #for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                #    print "(${${$result_table_ref}[0]}[$i])";
                #}
                for my $row (@{$result_table_ref}) {
                    print "Inserting @{$row}\n";
                    eval { $sth_local->execute(@{$row}) };
                    if ($@) {
                        error_handler;
                        $skip = 1;
                    }
                }
            }
            last SWITCH;
        };
        $truncate && do {
            ### The SQL statement to remove all rows from each table in test database
            my $statement = "TRUNCATE TABLE $table;";
            print "Statement:     $statement\n";
            ### Prepare and execute the SQL statement
            my $sth_local = eval { $dbh_local->prepare( $statement ) };
            if ($@) {
                error_handler;
                $skip = 1;
            }
                #or warn "Can't prepare SQL statement: $DBI::errstr\n"
                #and $skip = 1;
            eval { $sth_local->execute() };
            if ($@) {
                error_handler;
                $skip = 1;
            }
            last SWITCH;
        }
    }
}
### Disconnect from the database
$dbh_rdb->disconnect() unless $localdb;
$dbh_local->disconnect();

