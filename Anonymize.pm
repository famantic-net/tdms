package Anonymize;

use strict;
use AnonymizedFields;
use OrgNum;
use PersonNum;



sub idNum { # 
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my ($target, $tuple, $sth, $row) = @_;
    # Find the column that contains the key
    my $field_num;
    for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
        $field_num = $i if $sth->{NAME}->[$i] eq ${$tuple}[1]; 
    }
    SWITCH: for ($target) {
        /organizations/ && do {
            my $orgnum = new OrgNum;
            ${$row}[$field_num] = $orgnum->randomize_number(${$row}[$field_num]);
            if (grep /${$tuple}[0]/, $orgnum->list_attr) {
                #print @{$orgnum->fields(${$tuple}[0])}, "\n";
                #print grep {/$sth->{NAME}->[$field_num]/} @{$sth->{NAME}}, "\n";
                #print ${$row}[$field_num], "\n";
            }
            last SWITCH;
        };
        /people/ && do {
            my $pnum = new PersonNum;
            ${$row}[$field_num] = $pnum->randomize_number(${$row}[$field_num]);
            last SWITCH;
        };
    }
    return $row;
}



1;