package Stiftelse;
# Collects all swedish bsinesses of type 

use strict;

our @ISA = qw(Property);

our %Stiftelse = (
        statement => q(
            SELECT * FROM acib_acitftg
                WHERE ftg_iklass_kod LIKE '%72'
                ORDER BY random()
                LIMIT #size#
        )
);


sub new() {
    my $self = shift->_classobj();
    return bless $self;
}


sub collect_data {
    my ($self, @args) = @_; 
    return $self->SUPER::collect_data(@args);
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
