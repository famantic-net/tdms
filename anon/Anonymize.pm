package Anonymize;

use strict;
use anon::OrgNum;
use anon::OrgName;
use anon::PersonNum;
use anon::PersonName;


sub idNum { # 
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my ($target, $table, $sth, $row, $test_list) = @_;
    # Find the column that contains the key
    my $field_num = sub {
        my $field = shift;
        for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            return $i if $sth->{NAME}->[$i] eq $field; 
        }
    };
    SWITCH: for ($target) {
        /organizations/ && do {
            my $orgnum = new OrgNum;
            if (grep /$table/, $orgnum->list_attr) {
                for my $field (@{$orgnum->fields($table)}) {
                    ${$row}[&{$field_num}($field)] = $orgnum->randomize_org_number(${$row}[&{$field_num}($field)], $test_list);
                }
                #print @{$orgnum->fields(${$tuple}[0])}, "\n";
                #print grep {/$sth->{NAME}->[$field_num]/} @{$sth->{NAME}}, "\n";
                #print ${$row}[$field_num], "\n";
            }
            my $orgname = new OrgName;
            if (grep /$table/, $orgname->list_attr("full")) {
                #for my $field (@{$orgname->fields($table)}) {
                #    ${$row}[&{$field_num}($field)] = $orgname->randomize_number(${$row}[&{$field_num}($field)]);
                #}
            }
            if (grep /$table/, $orgname->list_attr("abbr")) {
                #for my $field (@{$orgname->fields($table)}) {
                #    ${$row}[&{$field_num}($field)] = $orgname->randomize_number(${$row}[&{$field_num}($field)]);
                #}
            }
            last SWITCH;
        };
        /people/ && do {
            my $pnum = new PersonNum;
            if (grep /$table/, $pnum->list_attr) {
                for my $field (@{$pnum->fields($table)}) {
                    ${$row}[&{$field_num}($field)] = $pnum->randomize_person_number(${$row}[&{$field_num}($field)], $test_list);
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
            last SWITCH;
        };
    }
    return $row;
}




1;