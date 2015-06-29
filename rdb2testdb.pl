#!/usr/bin/env perl
=pod

=head1 Purpose

To populate the Test Data Management System with records from RDB (aka DB2REP).

Will fetch records for companies and individuals each and their corresponding data
in other tables. Number of records and keys that are used are specified in the
file F<rdb2testdb.conf>.

All data can be anonymized with the -a switch. 

=head1 Options

=over

=item -a

Anonymizes all data before it is stored to the local database. This means that business numbers and person
numbers will be altered to partly random figures. For businesses the first digit, indicating
type of business, is preserved. For persons the year is preserved.

=item -s

Fetches the specific test data for businesses and persons that have been specified in F<rdb2testdb.conf>.

=item -v

Generates trace output showing processed tables and inserts.

=back

=head1 Files

=over

=item rdb2testdb.conf

Contains configuration data such as IP-address to RDB and user/pw, table/field realtions etc.

=item Anonymization

Classes used for creating anonymized fields.

 anon::Address.pm
 anon::AnonymizedFields.pm
 anon::Anonymize.pm
 anon::BusinessAddress.pm
 anon::BusinessName.pm
 anon::BusinessNum.pm
 anon::LegalEntity.pm
 anon::PersonName.pm
 anon::PersonNum.pm
 anon::PrivateAddress.pm
 
=back

=head1 Examples

C<./rdb2testdb.pl -av | tee testdb_populate.log>

Anonymizes and turns on verbose output showing what is being inserted into the local database.

=cut

use DBI;
use Getopt::Std;
use feature 'unicode_strings';

use anon::Anonymize;

# Mapping of table to relevant column
require "rdb2testdb.conf" or die "Can't read the configuration file 'rdb2testdb.conf'!\n";

getopts("asv", \%opts);
$anonymize = 1 if $opts{a};
$specific = 1 if $opts{s};
$verbose = 1 if $opts{v};

if ($anonymize and $specific) {
    print "Refusing to anonymize the predefined test objects.\n";
    print "Use either -a or -s.\n";
    exit -1;
}



open LOG, ">>", "testdb_populate.log" or warn "Can't open 'testdb_populate.log' for logging: $!\n";

sub trace_print {
    ## If not enabled do nothing
    # return unless $verbose;
    if ($verbose) {
        print STDOUT @_;
    }
    else {
        print LOG @_;
    }
}

#$dbh_local = DBI->connect('dbi:Pg:dbname=DB2REP;
#                        host=127.0.0.1;
#                        port=5432',
#                        'db2moto',
#                        '',
#                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
#                    );
#
#$dbh_rdb = DBI->connect('dbi:Pg:dbname=DB2REP;
#                        host=10.46.117.29;
#                        port=5432',
#                        'nenant',
#                        'nenant',
#                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
#                    );

our $dbh_local = DBI->connect("dbi:Pg:dbname='$local_db';
                          host='$local_host';
                          port='$local_dbport'",
                          "$local_dbuid",
                          "$local_dbpwd",
                          {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
$dbh_local->{pg_enable_utf8} = 1;

our $dbh_rdb = DBI->connect("dbi:Pg:dbname='$remote_db';
                        host='$remote_host';
                        port='$remote_dbport'",
                        "$remote_dbuid",
                        "$remote_dbpwd",
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );
$dbh_rdb->{pg_enable_utf8} = 1;


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
    my @entry_tuple;
    my @test_list;
    my %name_hash;
    my $target = shift;
    trace_print "=== Processing $target ===\n";
    SWITCH: for ($target) {
        /organizations/ && do {
            @entry_tuple = @company_entry;
            %name_hash = %orgnum_name;
            last SWITCH;
       };
        /people/ && do {
            @entry_tuple = @person_entry;
            %name_hash = %pnr_name;
            last SWITCH;
       };
    }
    trace_print "\n--- Fetching from $entry_tuple[0] ---\n";
    my $statement;
    local $sth_rdb;
    my $result_ref;
    @test_list = $target eq "org" ? @test_businesses : @test_persons;
    if ($specific) {
        for my $test_item (@test_list) {
            $statement = "SELECT * FROM $entry_tuple[0] where $entry_tuple[1]=$test_item";
            $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
            $sth_rdb->execute();
            $result_ref = $sth_rdb->fetchall_arrayref;
            push @result_set, @{ $result_ref };
        }
    }
    else {
        $statement = "SELECT * FROM $entry_tuple[0] order by random() limit $init_size";
        $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
        $sth_rdb->execute();
        $result_ref = $sth_rdb->fetchall_arrayref;
        @result_set = @{ $result_ref };
    }
    
    # Prepare the insert statement with the number of columns
    my $ins = "INSERT INTO $entry_tuple[0] VALUES (";
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
        $number_column = $i if $sth_rdb->{NAME}->[$i] eq $entry_tuple[1]; 
    }
    
    my @collection;
    # Get the result set, store the key elements and insert the result set locally
    for my $row (@result_set) {
        #trace_print ${$row}[0];
        push @collection, ${$row}[$number_column];
        if ($anonymize) { # Transform the row into anonymous data
            trace_print "Anonymizing: @{$row}\n";
            $row = Anonymize->enact($dbh_rdb, $entry_tuple[0], $sth_rdb, $row, \@test_list);
        }
        trace_print "Inserting  : @{$row}\n";
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
                if ($anonymize) { # Transform the row into anonymous data
                    trace_print "Anonymizing: @{$row}\n";
                    $row = Anonymize->enact($dbh_rdb, $table, $sth_rdb, $row, \@test_list);
                }
                trace_print "Inserting  : @{$row}\n";
                eval { $sth_local->execute(@{$row}) };
            }
            
            # Fetch the data for the internal relations
            # Format is [{table => key},{table2 => key2}]
            # @relations is a list of the tables that have foreign key relations
            my @relations = map {keys ${$_}[0]} @int_relations;
            # %relations_full is a hash where each foreign key field in the current table
            # maps to the related other table=>field pair.
            my %relations_full;
            if ( grep(/$table/, @relations) ) {
                %relations_full = map { if ($table eq ${[ keys ${$_}[0] ]}[0]) { ${$_}[0]{$table} => ${$_}[1] } } @int_relations;
                delete $relations_full{""}; # In case there are empty elements from skipping relations
            }
            for my $column1 (keys %relations_full) {
                my $column1_pos;
                for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                    #trace_print $sth_rdb->{NAME}->[$i];
                    $column1_pos = $i if $sth_rdb->{NAME}->[$i] eq $column1;
                }
                # Collect all foreign key fields
                my @related_data;
                for my $row (@{$result_table_ref}) {
                    #trace_print "Related: ${$row}[$column1_num]\n";
                    push @related_data, ${$row}[$column1_pos];
                }
                # Fetch the data from the related tables
                for my $rel_item (@related_data) {
                    for my $table2 (keys %{$relations_full{$column1}}) {
                        my $column2 = ${$relations_full{$column1}}{$table2};
                        #trace_print "$table2 => $column2";
                        $statement = "SELECT * FROM $table2 WHERE $column2='$rel_item'";
                        #trace_print "$statement\n";
                        $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
                        $sth_rdb->execute();
                        my $result_table_ref = $sth_rdb->fetchall_arrayref;
                        my $result_size = scalar @{$result_table_ref};
                        if ($result_size) {
                            trace_print "... Fetched from $table2 ($rel_item, $result_size rows) ...\n";
                            my $ins = "INSERT INTO $table2 VALUES (";
                            for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                                $ins .= "?, ";
                            }
                            $ins =~ s/, $//;
                            $ins .= ");";
                            #trace_print "$ins\n";
                            my $sth_local = eval { $dbh_local->prepare($ins) };
                            for my $row (@{$result_table_ref}) {
                                if ($anonymize) { # Transform the row into anonymous data
                                    trace_print "Anonymizing: @{$row}\n";
                                    $row = Anonymize->enact($dbh_rdb, $table2, $sth_rdb, $row, \@test_list);
                                }
                                trace_print "Inserting  : @{$row}\n";
                                eval { $sth_local->execute(@{$row}) };
                                if ($@) {
                                    warn "Can't insert @{$row}\n$DBI::errstr\n";
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

# The different type of entities to handle
our @targets = qw(organizations people);
for my $target (@targets) {
    populate $target;
}

