package Anonymize;

use strict;
#use feature 'unicode_strings';
use utf8;

use anon::BusinessNum;
use anon::BusinessName;
use anon::PersonNum;
use anon::PersonName;
use anon::BusinessAddress;
use anon::PrivateAddress;

our $dbh_rdb;

sub enact { # 
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    $dbh_rdb = shift;
    #my ($target, $table, $sth, $row, $test_list) = @_;
    my ($table, $sth, $row, $test_list) = @_;
    #print "Processing : $target\nHave table : $table\n";
    #print "Received   : @{$row}\n";
    # Find the column that contains the key
    my $field_num = sub {
        my $field = shift;
        #print "Field     : $field\n";
        for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            return $i if $sth->{NAME}->[$i] eq $field; 
        }
    };
    my $id; # Used to keep table fields consistent
    #SWITCH: for ($target) {
    #    /organizations/ && do {
            my $orgnum = new BusinessNum($test_list);
            if (grep /$table/, $orgnum->list_attr) {
                for my $field (@{$orgnum->fields($table)}) {
                    $id = ${$row}[&{$field_num}($field)];
                    ${$row}[&{$field_num}($field)] = $orgnum->anonymizeOrgNumber(${$row}[&{$field_num}($field)]);
                }
            }
            my $orgname = new BusinessName($dbh_rdb, $id);
            if (grep /$table/, $orgname->list_attr("full")) {
                for my $field (@{$orgname->fields('full', $table)}) {
                    ${$row}[&{$field_num}($field)] = $orgname->anonymizeBusinessName(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $orgname->list_attr("abbr")) {
                for my $field (@{$orgname->fields('abbr', $table)}) {
                    ${$row}[&{$field_num}($field)] = $orgname->anonymizeBusinessAbbr(${$row}[&{$field_num}($field)]);
                }
            }
            my $address = new BusinessAddress($dbh_rdb, $id);
            if (grep /$table/, $address->list_attr("street")) {
                for my $field (@{$address->fields('street', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeStreet(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $address->list_attr("municipality")) {
                for my $field (@{$address->fields('municipality', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeMunicipality(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $address->list_attr("zip")) {
                for my $field (@{$address->fields('zip', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeZip(${$row}[&{$field_num}($field)]);
                }
            }
        #    last SWITCH;
        #};
        #/people/ && do {
            my $pnum = new PersonNum($test_list);
            if (grep /$table/, $pnum->list_attr) {
                for my $field (@{$pnum->fields($table)}) {
                    $id = ${$row}[&{$field_num}($field)];
                    ${$row}[&{$field_num}($field)] = $pnum->anonymizePersonNumber(${$row}[&{$field_num}($field)]);
                }
            }
            my $pname = new PersonName;
            if (grep /$table/, $pname->list_attr("full")) {
                for my $field (@{$pname->fields('full', $table)}) {
                    ${$row}[&{$field_num}($field)] = $pname->anonymizeName(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $pname->list_attr("given_name")) {
                for my $field (@{$pname->fields('given_name', $table)}) {
                    ${$row}[&{$field_num}($field)] = $pname->anonymizeGivenName(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $pname->list_attr("surname")) {
                for my $field (@{$pname->fields('surname', $table)}) {
                    ${$row}[&{$field_num}($field)] = $pname->anonymizeSurname(${$row}[&{$field_num}($field)]);
                }
            }
            my $address = new PrivateAddress($dbh_rdb, $id);
            if (grep /$table/, $address->list_attr("street")) {
                for my $field (@{$address->fields('street', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeStreet(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $address->list_attr("municipality")) {
                for my $field (@{$address->fields('municipality', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeMunicipality(${$row}[&{$field_num}($field)]);
                }
            }
            if (grep /$table/, $address->list_attr("zip")) {
                for my $field (@{$address->fields('zip', $table)}) {
                    ${$row}[&{$field_num}($field)] = $address->anonymizeZip(${$row}[&{$field_num}($field)]);
                }
            }
        #    last SWITCH;
        #};
    #}
    return $row;
}




1;