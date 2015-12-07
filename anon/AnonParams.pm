package AnonParams;
# Storing arguments for test object collection

use strict;

our %AnonParams = (
    target => undef,
    dbh => undef,
    entry_table => undef,
    tob_tuple => [],
    sth => undef,
    JFR => undef,
);


sub new() { # $dbh_rdb, $entry_tuple[0], \@tob_tuple, $sth_rdb, $row, $business_type{$number}
    my $self = shift->_classobj();
    bless $self;
    # Initialize with received arguments
    $self->target(shift);
    $self->dbh(shift);
    $self->entry_table(shift);
    $self->tob_tuple(shift);
    $self->sth(shift);
    $self->JFR(shift);
    return $self;
}



# http://search.cpan.org/~gsar/perl-5.6.1/pod/perltootc.pod
# tri-natured: function, class method, or object method
sub _classobj {
    my $obclass = shift || __PACKAGE__;
    my $class   = ref($obclass) || $obclass;
    no strict "refs";   # to convert sym ref to real one
    return \%$class;
}

for my $datum (keys %{ _classobj() } ) {
    # turn off strict refs so that we can
    # register a method in the symbol table
    no strict "refs";
    *$datum = sub {
        use strict "refs";
        my $self = shift->_classobj();
        $self->{$datum} = shift if @_;
        return $self->{$datum};
    }
}




1;
