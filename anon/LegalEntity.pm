package LegalEntity;

use strict;


sub new() {
    my $class = shift;
    my $self = {};
    return bless $self;
}

# Returns the tables that contain fields that should be anonymized
# Some tables have more than one number or name, e.g. both 10 digit and 12 digit formats
#sub list_attr {
#    my $self = shift;
#    return sort keys %{$self};
#}
# If @_ contains an argument it is taken as specifying the list in the
# AnonymizedFields hash for the specific type.
sub list_attr {
    my $self = shift;
    unless ($#_ < 0) {
        my $list = shift;
        if (grep /$list/, keys %{$self}) {
            return sort keys %{${$self}{$list}};
        }
        else {
            die "Can't find the list $list in $self.\n";
        }
    }
    else {
        return sort keys %{$self};
    }
}


# Returns the field names that should be anonymized in the specific table
sub fields { # $table
    my $self = shift;
    my $table = shift;
    unless ($#_ < 0) {  # Extra argument specifying list
        my $list = $table;
        $table = shift;
        if (grep /$list/, keys %{$self}) {
            return ${$self}{$list}{$table};
        }
        else {
            die "Can't find the list $list in $self.\n";
        }
    }
    else {
        #print "===$self ${$self}{$table}\n";
        return ${$self}{$table};
    }
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