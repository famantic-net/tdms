#!/usr/bin/env perl

=pod

=head1 Synopsis

rdb_data.pl -[cdlmrtv]

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

=item -r

Roll dates, i.e update certain timestamps.

=item -t

Display fileds that are defined as C<SQL_TIMESTAMP> from all tables.

=item -v

Turn on verbose prints to STDOUT about what's happening.

=back

=head1 Examples

C<rdb_data.pl -lm>

=over 4

Show metadata for the local RDB replica.

=back

C<rdb_data.pl -lc>

=over 4

Display a count of rows for each table in the local RBD replica.

=back

C<rdb_data.pl -d>

=over 4

Truncate all local tables.

=back

=head1 Files

F<rdb2testdb.conf>

=cut

use DBI;
use Getopt::Std;
#use feature 'unicode_strings';
use utf8;

require "rdb2testdb.conf" or die "Can't read the configuration file 'rdb2testdb.conf'!\n";

#getopts("E:cdelx:", \%opts);
#$envpass = $opts{E} if $opts{E};
#$commit = 1 if $opts{c};
getopts("cdelmrstvx", \%opts);
$count = 1 if $opts{c};
$examples = 1 if $opts{x};
$export = 1 if $opts{e};
$localdb = 1 if $opts{l};
$metadata = 1 if $opts{m};
$roll_dates = 1 if $opts{r};
$show = 1 if $opts{s};
$timestamps = 1 if $opts{t};
$truncate = 1 if $opts{d};
$verbose = 1 if $opts{v};

if ($#{[ keys %opts ]} < 0) {
    print "Need some argument!\n";
    print "Usage: $0 -[cdelmrstvx]\n";
    print "Or try 'perldoc $0'\n";
    exit 1;
}


$localdb = 1 if $truncate or $roll_dates or $export;

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

sub trace_print {
    # If not enabled do nothing
     return unless $verbose;
    if ($verbose) {
        print STDOUT @_;
    }
    #else {
    #    print LOG @_;
    #}
}

# http://www.easysoft.com/developer/languages/c/examples/ListDataTypes.html
#// Array of SQL Data Types
#dataTypes dtList[DTSIZE] = {
#    "SQL_UNKNOWN_TYPE",0,
#    "SQL_CHAR",1,
#    "SQL_NUMERIC",2,
#    "SQL_DECIMAL",3,
#    "SQL_INTEGER",4,
#    "SQL_SMALLINT",5,
#    "SQL_FLOAT",6,
#    "SQL_REAL",7,
#    "SQL_DOUBLE",8,
#    "SQL_DATETIME",9,
#    "SQL_DATE",9,
#    "SQL_INTERVAL",10,
#    "SQL_TIME",10,
#    "SQL_TIMESTAMP",11,
#    "SQL_VARCHAR",12,
#    "SQL_TYPE_DATE",91,
#    "SQL_TYPE_TIME",92,
#    "SQL_TYPE_TIMESTAMP",93,
#    "SQL_LONGVARCHAR",-1,
#    "SQL_BINARY",-2,
#    "SQL_VARBINARY",-3,
#    "SQL_LONGVARBINARY",-4,
#    "SQL_BIGINT",-5,
#    "SQL_TINYINT",-6,
#    "SQL_BIT",-7,
#    "SQL_WCHAR",-8,
#    "SQL_WVARCHAR",-9,
#    "SQL_WLONGVARCHAR",-10,
#    "SQL_GUID",-11,
#    "SQL_SS_VARIANT",-150,
#    "SQL_SS_UDT",-151,
#    "SQL_SS_XML",-152,
#    "SQL_SS_TABLE",-153,
#    "SQL_SS_TIME2",-154,
#    "SQL_SS_TIMESTAMPOFFSET",-155
#};
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
   91 => "SQL_TYPE_DATE",
   92 => "SQL_TYPE_TIME",
   93 => "SQL_TYPE_TIMESTAMP",
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



$dbh_local = DBI->connect("dbi:Pg:dbname='$local_db';
                          host='$local_host';
                          port='$local_dbport'",
                          "$local_dbuid",
                          "$local_dbpwd",
                          {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
unless ($localdb) {
    $dbh_rdb = DBI->connect("dbi:Pg:dbname='$remote_db';
                        host='$remote_host';
                        port='$remote_dbport'",
                        "$remote_dbuid",
                        "$remote_dbpwd",
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
}


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
    
    unless ($timestamps or $roll_dates or $show or $examples or $export) {
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
        $show && do {
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            my $statement = "SELECT count(*) FROM $table";
            my $sth = eval { $dbh->prepare( $statement ) };
            eval { $sth->execute() };
            last SWITCH if $@;
            my $result_table_ref = $sth->fetchall_arrayref;
            my $rows = ${${$result_table_ref}[0]}[0];
            if ($rows > 0) {
                print "\n=== $name ===\n";
                $statement = "SELECT * FROM $table";
                $sth = $dbh->prepare( $statement );
                $sth->execute();
                $result_table_ref = $sth->fetchall_arrayref;
                for my $row (@{$result_table_ref}) {
                    print "@{$row}\n"
                }
            };
            last SWITCH;
        };
        $export && do {
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            my $statement = "SELECT count(*) FROM $table";
            my $sth = eval { $dbh->prepare( $statement ) };
            eval { $sth->execute() };
            last SWITCH if $@;
            my $result_table_ref = $sth->fetchall_arrayref;
            my $rows = ${${$result_table_ref}[0]}[0];
            if ($rows > 0) {
                $statement = "SELECT * FROM $table";
                $sth = $dbh->prepare( $statement );
                $sth->execute();
                $result_table_ref = $sth->fetchall_arrayref;
                unless ( -e $export_dir ) {
                    mkdir $export_dir
                }
                if (open my $fh, ">", "$export_dir/${name}.txt") {
                    for my $row (@{$result_table_ref}) {
                        print $fh "@{$row}\n"
                    }
                    close $fh;
                }
                else {
                   warn "Can't open ${name}.txt: $!\n"; 
                }
            };
            last SWITCH;
        };
        $examples && do {
            my $dbh = $localdb ? $dbh_local : $dbh_rdb;
            my $statement = "SELECT count(*) FROM $table";
            my $sth = eval { $dbh->prepare( $statement ) };
            eval { $sth->execute() };
            last SWITCH if $@;
            my $result_table_ref = $sth->fetchall_arrayref;
            my $rows = ${${$result_table_ref}[0]}[0];
            if ($rows > 0) {
                $statement = "SELECT * FROM $table order by random() limit 1";
                $sth = $dbh->prepare( $statement );
                $sth->execute();
                my $idx = 0;
                $result_table_ref = $sth->fetchall_arrayref;
                print "$name\n";
                map { print "[$idx]<$_>${${$result_table_ref}[0]}[$idx++]\n"; } @{$sth->{NAME}}, "\n";
            };
            last SWITCH;
        };
        $roll_dates && do {
            # trace_print "Now on $name: matched:  @{[ grep /$name/, keys %tables_to_roll ]}\n";
            if (grep /$name/, keys %tables_to_roll) {
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
                    #trace_print "Pkey: ${$pkey}[0]\n";
                    push @pkeys, ${$pkey}[0];
                }
                
                for my $roll_field (@{$tables_to_roll{$name}}) {
                    # my $roll_field = $tables_to_roll{$name}[0];
                    # Fetch the column to roll and all primary keys
                    my $fetch_statement = "SELECT $roll_field, @{[ join ',', @pkeys ]} FROM $table";
                    $sth = $dbh_local->prepare( $fetch_statement ) ;
                    $sth->execute();
                    my $result_table_ref = $sth->fetchall_arrayref;
                    my @rolled_year;
                    # Sort the result set in descending order so that the updates occur from latest
                    # date first in order top avoid errors due to duplication
                    my @sorted_result_table = sort {${$b}[0] <=> ${$a}[0]} @{$result_table_ref};
                    #for my $row (@{$result_table_ref}) {
                    for my $row (@sorted_result_table) {
                        #trace_print @{$row}, "\n";
                        # Increase the year by 1
                        unless (length(${$row}[0]) > 8) {
                            # trace_print ${$row}[0], "->", ${$row}[0] + (length(${$row}[0]) == 4 ? 1 : length(${$row}[0]) == 6 ? 100 : length(${$row}[0]) == 8 ? 10000 : 0), "\n";
                            push @rolled_year, ${$row}[0] + (length(${$row}[0]) == 4 ? 1 : length(${$row}[0]) == 6 ? 100 : length(${$row}[0]) == 8 ? 10000 : 0);
                        }
                        else {
                            my $rolled_year = sub {$_ = shift; s/^(\d+)/$1+1/e; return $_};
                            push @rolled_year, &{$rolled_year}(${$row}[0]);
                        }
                    }
                    my $put_statement = "UPDATE $table SET $roll_field = ? WHERE ";
                    for my $pkey (@pkeys) {
                        $put_statement .= "$pkey = ? AND ";
                    }
                    $put_statement =~ s/ AND $//; # Remove last 'AND'
                    $put_statement .= ";";
                    trace_print "$put_statement\n";
                    $sth = $dbh_local->prepare($put_statement);
                    my $line = 0;
                    my @put_row;
                    #for my $row (@{$result_table_ref}) {
                    for my $row (@sorted_result_table) {
                        trace_print "Rolling to: $rolled_year[$line] '@{$row}'\n";
                        @put_row = "$rolled_year[$line] ";
                        for (my $i=1; $i<=$#{$row}; $i++) {
                            push @put_row, ${$row}[$i];
                        }
                        trace_print "Inserting: @{[ join ' ', @put_row ]}\n";
                        $sth->execute(@put_row);
                        $line++;
                    }
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

