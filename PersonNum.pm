package PersonNum;

use strict;
use LegalEntity;
use AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->pnum;
    return bless $self;
}

sub list_attr {
    my $self = shift;
    return sort keys %{$self};
}

# Returns a new person number stub based on the received number
sub randomize_number {
    my $self = shift;
    my $pnum = shift;
    #print "Received: $pnum\n";
    unless ($anonymized{$pnum}) {
        my $lead_dig;
        if (length $pnum == 10 ) {
            ($lead_dig) = $pnum =~ m/^(\d\d)/;
        }
        elsif (length $pnum == 12) {
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


## Calculates control digit according to 'http://personnummer.se/om'
#sub __control_digit {
#    my @orgnum_stub = map { split '' } @_;
#    #print "@orgnum_stub\n";
#    my $mult = 2;
#    my ($partsum, $sum);
#    for my $digit (@orgnum_stub) {
#        $mult = ($mult + 1) % 2;
#        $partsum = $digit * ($mult + 1);
#        #print "$partsum\n";
#        if ($partsum > 9) {
#            my @partsum = split '', $partsum;
#            #print "@partsum\n";
#            map {$sum += $_} @partsum
#        }
#        else {
#            $sum += $partsum;
#        }
#        #print "::$sum\n";
#    }
#    return 10 - ($sum % 10);
#}
#



1;