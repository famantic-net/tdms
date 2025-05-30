package Anonymize;

use strict;
use feature 'unicode_strings';
use Time::HiRes qw(time);

use anon::BusinessNum;
use anon::ArbNum;
use anon::DunsNum;
use anon::PersonNum;
use anon::BusinessName;
use anon::PersonName;
use anon::BusinessAddress;
use anon::PrivateAddress;

our $dbh_rdb;

sub enact { # 
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $row = shift;
    my $anonparams = shift;
    $dbh_rdb = $anonparams->dbh;
    my $table = $anonparams->entry_table;
    my @tob_tuple = @{$anonparams->tob_tuple};
    my $sth = $anonparams->sth;

    # Find the column that contains the key
    my $field_num = sub {
        my $field = shift;
        #print "Field     : $field\n";
        for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            return $i if $sth->{NAME}->[$i] eq $field; 
        }
    };
    
    my $id; # Used to keep table fields consistent
    
    # Set status field to test object
    if ($table =~ m/$tob_tuple[0]/) {
        ${$row}[&{$field_num}($tob_tuple[1])] = 4; # Testobject
    }
    
    { # Businesses
        my $orgnum = new BusinessNum;
        if (grep /$table/, $orgnum->list_attr) {
            for my $field (@{$orgnum->fields($table)}) {
                $id = ${$row}[&{$field_num}($field)];
                ${$row}[&{$field_num}($field)] = $orgnum->anonymizeOrgNumber(${$row}[&{$field_num}($field)], $anonparams);
            }
        }

        my $arbnum = new ArbNum;
        if (grep /$table/, $arbnum->list_attr) {
            for my $field (@{$arbnum->fields($table)}) {
                $id = ${$row}[&{$field_num}($field)];
                ${$row}[&{$field_num}($field)] = $arbnum->anonymizeWorkplaceNumber(${$row}[&{$field_num}($field)]);
            }
        }

        my $dunsnum = new DunsNum;
        if (grep /$table/, $dunsnum->list_attr) {
            for my $field (@{$dunsnum->fields($table)}) {
                ${$row}[&{$field_num}($field)] = $dunsnum->anonymizeDunsNumber(${$row}[&{$field_num}($field)]);
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
    }
    
    { # Individuals
        my $pnum = new PersonNum;
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
    }
    
    return $row;
}




1;