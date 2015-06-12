package PersonNum;

use strict;
use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->pnum;
    return bless $self;
}


# Returns a new person number stub based on the received number
sub randomize_person_number {
    my $self = shift;
    my $pnum = shift;
    return $pnum unless $pnum; # If empty return what came in
    #print "Received: $pnum\n";
    unless ($anonymized{$pnum}) { # Already anonymized
        my $lead_dig;
        if (length $pnum == 10 ) {
            ($lead_dig) = $pnum =~ m/^(\d\d)/;
        }
        elsif (length $pnum == 12) {
            my ($century, $short_pnum) = $pnum =~ m/^(\d\d)(.+)/;
            if ($anonymized{$short_pnum}) {
                return $anonymized{$pnum} = $century . $anonymized{$short_pnum}; 
            }
            ($lead_dig) = $pnum =~ m/^(\d\d\d\d)/;
        }
        else {
            die "Problem with person number format: $pnum";
        }
        my $month = sprintf "%02d", int(rand(12)) + 1;
        my $day = sprintf "%02d", int(rand(27)) + 1;
        my $ordinal = sprintf "%03d", int(rand(1000));
        my $anon_number = $lead_dig . $month . $day . $ordinal . $self->_control_digit($lead_dig, $month, $day, $ordinal);
        $anonymized{$pnum} = $anon_number;
    }
    return $anonymized{$pnum};
}




1;