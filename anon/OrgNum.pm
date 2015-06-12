package OrgNum;

use strict;
use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgnum;
    return bless $self;
}


# Returns a new organization number stub based on the received number
sub randomize_org_number { # $orgnum
    my $self = shift;
    my $orgnum = shift;
    #print "Received: $orgnum\n";
    unless ($anonymized{$orgnum}) {
        my $lead_dig;
        if (length $orgnum == 10 ) {
            ($lead_dig) = $orgnum =~ m/^(\d)/;
        }
        elsif (length $orgnum == 12) {
            ($lead_dig) = $orgnum =~ m/^(\d\d\d)/;
        }
        else {
            die "Problem with organization number format: $orgnum";
        }
        my $ordinal = sprintf "%08d", int(rand(10000000));
        my $anon_number = $lead_dig . $ordinal . $self->_control_digit($lead_dig, $ordinal);
        $anonymized{$orgnum} = $anon_number;
    }
    return $anonymized{$orgnum};
}



1;