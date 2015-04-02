#!/usr/bin/env perl
=pod

=head1 Purpose

To populate the Test Data Management System with records from RDB (aka DB2REP).

Will fetch 100 records for companies and individuals each and their corresponding data
in other tables. The keys that are used are specified in the file F<testdata_columns.plx>.

=head1 Options

=over

=item -v

Generates trace output showing processed tables and inserts.

=back

=head1 Files

testdata_columns.plx

=head1 Examples

Nothing yet. :(

=cut

use DBI;
use Getopt::Std;

getopts("v", \%opts);
$verbose = 1 if $opts{v};

# Mapping of table to relevant column
require "testdata_columns.plx";

sub trace_print {
    # If not enabled do nothing
    return unless $verbose;
    print @_;
}

$dbh_local = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=127.0.0.1;
                        port=5432',
                        'db2moto',
                        '',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );

$dbh_rdb = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=10.46.117.29;
                        port=5432',
                        'nenant',
                        'nenant',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );


#@res = map {keys ${$_}[0]} @int_relations;
#if ( grep(/acib_acitarn/, @res) ) {    
#    %res_full = map { if ("acib_acitarn" eq ${[ keys ${$_}[0] ]}[0]) { ${$_}[0]{acib_acitarn} => ${$_}[1] } } @int_relations;
#    delete $res_full{""};
#}
#for my $key (keys %res_full) {
#    print "$key -> ";
#    for my $key2 (keys %{$res_full{$key}}) {
#        print "$key2 => ${$res_full{$key}}{$key2}\n";
#    }
#}
#exit;


sub populate {
    my (@entry_table, %name_hash);
    my $target = shift;
    trace_print "=== Processing $target ===\n";
    SWITCH: {
        ($target eq "org") && do { @entry_table = @company_entry;
                                   %name_hash = %orgnum_name;
                                   last SWITCH;
                                 };
        ($target eq "people") && do { @entry_table = @person_entry;
                                      %name_hash = %pnr_name;
                                      last SWITCH;
                                    };
    }
    trace_print "\n--- Fetching from $entry_table[0] ---\n";
    my $statement = "SELECT * FROM $entry_table[0] order by random() limit 100";
    my $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
    $sth_rdb->execute();
    
    # Prepare the insert statement with the number of columns
    my $ins = "INSERT INTO $entry_table[0] VALUES (";
    for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
        $ins .= "?, ";
    }
    $ins =~ s/, $//;
    $ins .= ");";
    #trace_print "$ins\n";
    
    my $sth_local = eval { $dbh_local->prepare($ins) };
    # Find the column that contains the key
    for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
        #trace_print $sth_rdb->{NAME}->[$i];
        $number_column = $i if $sth_rdb->{NAME}->[$i] eq $entry_table[1]; 
    }
    
    my @collection;
    # Get the result set, store the key elements and insert the result set locally
    my $result_ref = $sth_rdb->fetchall_arrayref;
    for my $row (@{ $result_ref }) {
        #trace_print ${$row}[0];
        push @collection, ${$row}[$number_column];
        trace_print "Inserting: @{$row}\n";
        eval { $sth_local->execute(@{$row}) };
     }
    
    # For every table with an identity number relation fetch the rows that correspond
    # to the keys in the fetched collection
    for my $table (keys %name_hash) {
        trace_print "\n--- Fetching from $table ---\n";
        for my $num (@collection) {
            $statement = "SELECT * FROM $table WHERE $name_hash{$table}='$num'";
            #trace_print "$statement\n";
            $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
            $sth_rdb->execute();
            my $result_table_ref = $sth_rdb->fetchall_arrayref;
            my $ins = "INSERT INTO $table VALUES (";
            for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                $ins .= "?, ";
            }
            $ins =~ s/, $//;
            $ins .= ");";
            #trace_print "$ins\n";
            my $sth_local = eval { $dbh_local->prepare($ins) };
            for my $row (@{$result_table_ref}) {
                trace_print "Inserting: @{$row}\n";
                eval { $sth_local->execute(@{$row}) };
            }
            
            # Fetch the data for the internal relations
            # Format is [{table => key},{table2 => key2}]
            my @relations = map {keys ${$_}[0]} @int_relations;
            my %relations_full;
            if ( grep(/$table/, @relations) ) {
                %relations_full = map { if ($table eq ${[ keys ${$_}[0] ]}[0]) { ${$_}[0]{$table} => ${$_}[1] } } @int_relations;
                delete $relations_full{""}; # In case there are empty elements from skipping relations
            }
            for my $column1 (keys %relations_full) {
                # Find all column1 for each num
                my $column1_num;
                for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                    #trace_print $sth_rdb->{NAME}->[$i];
                    $column1_num = $i if $sth_rdb->{NAME}->[$i] eq $column1;
                }
                my @related_data;
                for my $row (@{$result_table_ref}) {
                    #trace_print "Related: ${$row}[$column1_num]\n";
                    push @related_data, ${$row}[$column1_num];
                }
                for my $rel_item (@related_data) {
                    for my $table2 (keys %{$relations_full{$column1}}) {
                        my $column2 = ${$relations_full{$column1}}{$table2};
                        #trace_print "$table2 => $column2";
                        trace_print "... Fetching from $table2 ...\n";
                        $statement = "SELECT * FROM $table2 WHERE $column2='$rel_item'";
                        #trace_print "$statement\n";
                        $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
                        $sth_rdb->execute();
                        my $result_table_ref = $sth_rdb->fetchall_arrayref;
                        my $ins = "INSERT INTO $table2 VALUES (";
                        for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                            $ins .= "?, ";
                        }
                        $ins =~ s/, $//;
                        $ins .= ");";
                        #trace_print "$ins\n";
                        my $sth_local = eval { $dbh_local->prepare($ins) };
                        for my $row (@{$result_table_ref}) {
                            trace_print "Inserting: @{$row}\n";
                            eval { $sth_local->execute(@{$row}) };
                        }
                    }
                }
            }
        }
    }
}

populate "org";
populate "people";


#print "\nFetching from $company_entry[0]\n";
#our $statement = "SELECT * FROM $company_entry[0] order by random() limit 100";
#our $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
#$sth_rdb->execute();
#
# Prepare the insert statement with the number of columns
#our $ins = "INSERT INTO $company_entry[0] VALUES (";
#for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
#    $ins .= "?, ";
#}
#$ins =~ s/, $//;
#$ins .= ");";
##print "$ins\n";
#
#our $sth_local = eval { $dbh_local->prepare($ins) };
#my $fields = $sth_rdb->{NUM_OF_FIELDS};
# Find the column that contains the key
#for ( my $i = 0 ; $i < $fields ; $i++ ) {
#    #print $sth_rdb->{NAME}->[$i];
#    $company_num_col = $i if $sth_rdb->{NAME}->[$i] eq $company_entry[1]; 
#}
#
#our @companies;
# Get the result set, store the key elements and insert the result set locally
#our $result_ref = $sth_rdb->fetchall_arrayref;
#for my $row (@{ $result_ref }) {
#    #print ${$row}[0];
#    push @companies, ${$row}[$company_num_col];
#    #print "Inserting @{$row}\n";
#    eval { $sth_local->execute(@{$row}) };
# }
#
## For every table with a company number relation fetch the rows that correspond
## to the fetched companies
#for my $table (keys %orgnum_name) {
#    print "\nFetching from $table\n";
#    for my $num (@companies) {
#        $statement = "SELECT * FROM $table WHERE $orgnum_name{$table}='$num'";
#        #print "$statement\n";
#        $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
#        $sth_rdb->execute();
#        my $result_table_ref = $sth_rdb->fetchall_arrayref;
#        $ins = "INSERT INTO $table VALUES (";
#        for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
#            $ins .= "?, ";
#        }
#        $ins =~ s/, $//;
#        $ins .= ");";
#        #print "$ins\n";
#        my $sth_local = eval { $dbh_local->prepare($ins) };
#        for my $row (@{$result_table_ref}) {
#            print "Inserting: @{$row}\n";
#            eval { $sth_local->execute(@{$row}) };
#        }
#        
#    }
#}
