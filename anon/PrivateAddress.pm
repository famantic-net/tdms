package PrivateAddress;

use strict;

use anon::AnonymizedFields;
use anon::Address;

our @ISA = qw(Address);
our ($dbh, $address_id);


sub new() {
    my $class = shift;
    $dbh = shift;
    $address_id = shift;
    $class->SUPER::init($dbh, $address_id);
    my $self = AnonymizedFields->private_address;
    return bless $self;
}


1;