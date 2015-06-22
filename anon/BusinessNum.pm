package BusinessNum;

use strict;
use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our @test_list;


sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgnum;
    my $test_list= shift;
    @test_list = @{$test_list};
    return bless $self;
}


# Returns a new organization number stub based on the received number
sub anonymizeOrgNumber { # $orgnum
    my $self = shift;
    my $orgnum = shift;
    unless ($anonymized{$orgnum}) {
        my $lead_dig;
        if (length $orgnum == 10 ) {
            ($lead_dig) = $orgnum =~ m/^(\d)/;
        }
        elsif (length $orgnum == 12) {
            ($lead_dig) = $orgnum =~ m/^(\d\d\d)/;
        }
        else {
            #die "Problem with organization number format: $orgnum";
            return $orgnum; # Return what came in since it's not a normal Swedish business number
        }
        my $anon_number;
        # Avoid creating an organization number that clashes with the predefined testobjects
        do {
            my $ordinal = sprintf "%08d", int(rand(10000000));
            $anon_number = $lead_dig . $ordinal . $self->_control_digit($lead_dig, $ordinal);
        } while (grep /$anon_number/, @test_list);
        
        $anonymized{$orgnum} = $anon_number;
    }
    return $anonymized{$orgnum};
}



1;