package PersonNum;

use strict;
use Anonymize;

sub new() {
    my $class = shift;
    my $self = Anonymize->pnum;
    return bless $self;
}

sub list_attr {
    my $self = shift;
    print join "\n", sort keys %{$self};
}

1;