#!/usr/bin/env perl
=pod

=head1 Synopsis

tdms_populate.pl -[asv]

=head1 Purpose

To populate the Test Data Management System with records from RDB (aka DB2REP).

Will fetch records for companies and individuals each and their corresponding data
in other tables. Number of records and keys that are used are specified in the
file F<tdms_populate.conf>.

All data can be anonymized with the -a switch. 

=head1 Options

=over

=item -a

Anonymize all data before it is stored to the local database. This means that
data such as business numbers and person numbers will be altered to partly
random figures. For businesses the first digit, indicating type of business, is
preserved. For persons the year is preserved. Also names and adresses are
altered to some random combinations.

=item -s

Fetch the specific test data for businesses and persons that have been specified
in F<tdms_populate.conf>.

=item -v

Generate trace output showing processed tables and inserts.

=back

=head1 Files

=over

=item tdms_populate.conf

Contains configuration data such as IP-address to RDB and user/pw, table/field realtions etc.

=item Anonymization

Classes used for creating anonymized fields.

 anon::Address.pm
 anon::AnonymizedFields.pm
 anon::Anonymize.pm
 anon::BusinessAddress.pm
 anon::BusinessName.pm
 anon::BusinessNum.pm
 anon::GivenNames.pm
 anon::LegalEntity.pm
 anon::PersonName.pm
 anon::PersonNum.pm
 anon::PrivateAddress.pm
 anon::SurNames.pm
 
=back

=head1 Examples

C<./tdms_populate.pl -av | tee testdb_populate.log>

Anonymizes and turns on verbose output showing what is being inserted into the local database.

=cut

use DBI;
use Getopt::Std;
use feature 'unicode_strings';

use anon::Anonymize;

# Mapping of table to relevant column
require "tdms.conf" or die "Can't read the configuration file 'tdms.conf'!\n";

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
*STDERR = *LOG unless $verbose;

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


sub populate;
our (%business_contacts, @business_contacts);

# The different type of entities to handle
populate "organizations";
populate "people";

sub populate {
    my $target = shift;
    my @entry_tuple;
    my @spec_list;
    my %name_hash;
    my @added_contacts;
    
    trace_print "\n=== Processing $target ===\n";
    SWITCH: for ($target) {
        /^organizations$/ && do {
            @entry_tuple = @company_entry;
            @tob_tuple = @company_testobject_indicator;
            %name_hash = %orgnum_name;
            @spec_list = @test_businesses;
            last SWITCH;
        };
        /^people$/ && do {
            @entry_tuple = @person_entry;
            @tob_tuple = @person_testobject_indicator;
            %name_hash = %pnr_name;
            @spec_list = @test_persons;
            last SWITCH;
        };
        /^business contact organizations$/ && do {
            # Called recursively
            $target = "organizations";
            @entry_tuple = @company_entry;
            @tob_tuple = @company_testobject_indicator;
            %name_hash = %orgnum_name;
            @spec_list = @business_contacts;
            trace_print "\n... Including $#business_contacts business contacts ...\n";
            last SWITCH;
        };
        /^business contact people$/ && do {
            # Called recursively
            $target = "people";
            @entry_tuple = @person_entry;
            @tob_tuple = @person_testobject_indicator;
            %name_hash = %pnr_name;
            @spec_list = @business_contacts;
            trace_print "\n... Including $#business_contacts business contacts ...\n";
            last SWITCH;
        };
    }
    trace_print "\n--- Fetching from $entry_tuple[0] ---\n";
    my $statement;
    local $sth_rdb;
    my ($result_ref, @result_set);
    
    if ($specific) {
        trace_print ">>> Specific list <<<\n";
        for my $item (@spec_list) {
            $statement = "SELECT * FROM $entry_tuple[0] where $entry_tuple[1]=$item";
            $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
            $sth_rdb->execute();
            $result_ref = $sth_rdb->fetchall_arrayref;
            push @result_set, @{ $result_ref };
        }
    }
    else {
        my $fetched_tobs = 0;
        do {
            $statement = "SELECT * FROM $entry_tuple[0] order by random() limit " . ($init_size - $fetched_tobs);
            $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
            $sth_rdb->execute();
            $result_ref = $sth_rdb->fetchall_arrayref;
            push @result_set, @{ $result_ref };
            my $field_num = sub {
                my $field = shift;
                #print "Field     : $field\n";
                for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
                    return $i if $sth_rdb->{NAME}->[$i] eq $field; 
                }
            };
            # Remove test objects that might have been fetched
            my $i = 0;
            for my $row (@result_set) {
                if (${$row}[&{$field_num}($tob_tuple[1])] == 4) {
                    splice @result_set, $i, 1;
                }
                else {
                    $i++;
                }
            }
            $fetched_tobs = $init_size - ($#result_set + 1);
        } until ($fetched_tobs == 0);
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
        my $number = ${$row}[$number_column];
        push @collection, $number;
        
        # Fetch the business contact persons if processing organizations
        if ($target eq "organizations") {
            $statement = "SELECT pnr FROM acin_intr20 WHERE orgnr=$number";
            my $sth = eval { $dbh_rdb->prepare( $statement ) };
            $sth->execute();
            my $result_ref = $sth->fetchall_arrayref;
            if ($#{$result_ref} > -1) {
                #print "==========\n$number\n----------\n";
                for my $item_ref (@{$result_ref}) {
                    # Data is in first element
                    #print "${$item_ref}[0]\n";
                    my $contact = ${$item_ref}[0];
                    unless (exists $business_contacts{$contact}) {
                        $business_contacts{$contact}++;
                        push @added_contacts, $contact;
                    }
                }
            }
        }
        
        if ($anonymize) { # Transform the row into anonymous data
            trace_print "Anonymizing: @{$row}\n";
            $row = Anonymize->enact($dbh_rdb, $entry_tuple[0], \@tob_tuple, $sth_rdb, $row, \@test_list);
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
                    $row = Anonymize->enact($dbh_rdb, $table, \@tob_tuple, $sth_rdb, $row, \@test_list);
                }
                trace_print "Inserting  : @{$row}\n";
                eval { $sth_local->execute(@{$row}) };
            }
            
            # Fetch the data for the internal relations
            # Format is [{table => key},{table2 => key2}]
            # @relations is a list of the tables that have foreign key relations
            my @relations = map {keys ${$_}[0]} @int_relations;
            #trace_print "Relations: @relations\n";
            # %relations_full is a hash where each foreign key field in the current table
            # maps to the related other table=>field pair.
            my %relations_full;
            if ( grep(/$table/, @relations) ) {
                # The following map construct has some bug where it doesn't consistetly create a correct hash, why it was expanded instead
                #%relations_full = map { if ($table eq ${[ keys ${$_}[0] ]}[0]) { trace_print ${$_}[0]{$table}, "\n"; ${$_}[0]{$table} => ${$_}[1] } } @int_relations;
                for my $relation (@int_relations) {
                    if ($table eq ${[ keys ${$relation}[0] ]}[0]) {
                        #trace_print ${$relation}[0]{$table}, "\n";
                        $relations_full{${$relation}[0]{$table}} = ${$relation}[1];
                    }
                }
                delete $relations_full{""}; # In case there are empty elements from skipping relations
                #trace_print "Related keys: ", keys %relations_full, "\n";
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
                    my $related = ${$row}[$column1_pos];
                    #trace_print "Related: $related\n";
                    $related =~ s/\s+$//; # Remove trailng blanks
                    push @related_data, $related;
                }
                #trace_print "Related data: @related_data\n";
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
                                    $row = Anonymize->enact($dbh_rdb, $table2, \@tob_tuple, $sth_rdb, $row, \@test_list);
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
    # Add the business contacts to the test objects as specific lists
    if ($target eq "organizations" and $#added_contacts > -1) {
        local @business_contacts = @added_contacts;
        local $specific = 1;
        populate "business contact organizations";
        populate "business contact people";
    }
    
}


