package OrgName;

use strict;
use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgname;
    return bless $self;
}

# Returns the tables that contain fields that should be anonymized
# Some tables have more than one number or name, e.g. both 10 digit and 12 digit formats
#sub list_attr {
#    my $self = shift;
#    my $list = shift;
#    if (grep /$list/, keys %{$self}) {
#        return sort keys %{${$self}{$list}};
#    }
#    else {
#        die "Can't find the list $list in $self.\n";
#    }
#}



1;