package Address;

use strict;
use Anonymize;

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->address;
    return bless $self;
}

sub list_attr {
    my $self = shift;
    return sort keys %{$self};
}

1;