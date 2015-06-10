package OrgNum;

use strict;
use LegalEntity;
use AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgnum;
    return bless $self;
}

# Returns the tables that contain an organization number that should be anonymized
# Some tables have more than one number, e.g. both 10 digit and 12 digit formats
sub list_attr {
    my $self = shift;
    return sort keys %{$self};
}

# Returns the field names that should be anonymized in the specific table
sub fields { # $table
    my $self = shift;
    my $table = shift;
    return ${$self}{$table};
}

# Returns a new organization number stub based on the received number
sub randomize_number { # $orgnum
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


sub randomize_address {
    my $self = shift;
    
}

sub randomize_name {
    my $self = shift;
    
}


1;