package Testdata; # Abstract
# Super class for the export layout classes

use strict;
use feature 'unicode_strings';


sub row_string {
    my $self = shift;
    my ($table_row, $sth, $types) = @_;
    my $result_row;
    my $idx = 0;
    for my $field (sort {$self->{$a}->[2] <=> $self->{$b}->[2]} keys %{$self}) {
        my $len = $self->$field->[0];
        my $sign = $self->$field->[1];
        my $type = $sth->{TYPE}->[$idx];
        my $field_value = ${$table_row}[$idx];
        if (grep /$field/, @{$sth->{NAME}}) { # The array of field names in the $sth result set
            #$result_row .= "<$field>[$types->{$type}]";
            if ($types->{$type} eq "SQL_TIMESTAMP") {
                # DB2 uses yyyy-mm-dd-hh.mm.ss.mmmmmm
                $field_value =~ s/\s/-/;
                $field_value =~ s/:/./g;
            }
            unless (grep /$types->{$type}/, qw( SQL_DECIMAL SQL_SMALLINT )) {
                $result_row .= sprintf "%- ${len}s", $field_value;
                #printf "%- ${len}s", $field_value;
            }
            else {
                my $orig_field_value = $field_value;
                $field_value =~ s/\.//; # Remove any decimal point
                $field_value =~ s/^\s*[-+]//; # Remove any leading sign
                $result_row .= sprintf "%0${len}d", $field_value;
                #printf "%0${len}d", $field_value;
                if ($sign) {
                    $result_row .= sprintf "%s", $orig_field_value < 0 ? "-" : "+";
                    #print $field_value < 0 ? "-" : "+";
                }
                
            }
            $idx++;
        }
        else {
            unless ($self->$field->[1]) { # Not numeric
                $result_row .= sprintf "%- ${len}s", "";
                #printf "%- ${len}s", $field_value;
            }
            else {
                $result_row .= sprintf "%0${len}d", 0;
                $result_row .= sprintf "%s", "+";
            }
        }
        
    }
    return $result_row;
}


sub row_len {
    my $self = shift;
    my $len;
    for my $key (keys %{$self}) {
        $len += $self->{$key}->[0] + $self->{$key}->[1];
    }
    return $len;
}



1;