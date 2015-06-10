package LegalEntity;

use strict;


sub new() {
    my $class = shift;
    my $self = {};
    return bless $self;
}

sub list_attr {
    my $self = shift;
    return sort keys %{$self};
}

# Calculates control digit according to 'http://personnummer.se/om'
sub _control_digit {
    shift; # Ignore calling class/object
    my @num_stub = map { split '' } @_;
    #print "@num_stub\n";
    my $mult = 2;
    my ($partsum, $sum);
    for my $digit (@num_stub) {
        $mult = ($mult + 1) % 2;
        $partsum = $digit * ($mult + 1);
        #print "$partsum\n";
        if ($partsum > 9) {
            my @partsum = split '', $partsum;
            #print "@partsum\n";
            map {$sum += $_} @partsum
        }
        else {
            $sum += $partsum;
        }
        #print "::$sum\n";
    }
    my $cdig = 10 - ($sum % 10);
    return $cdig < 10 ? $cdig : 0;
}



1;