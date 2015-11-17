package DBargs;
# Storing arguments for test object collection

use strict;

our %DBargs = (
    dbh => "",
    entry_table => "none",
    init_size => "0"
);


sub new() {
    my $self = shift->_classobj();
    bless $self;
    # Initialize with received arguments
    $self->dbh(shift);
    $self->entry_table(shift);
    $self->init_size(shift);
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
