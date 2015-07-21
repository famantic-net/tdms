package acin_intr20;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIN.INTR20";

# Indicates field length and if sign should be applied
our %acin_intr20 = (
    priokod         => [ 2 , 0 ],
    pnr             => [ 11, 1 ],
    plnr            => [ 3 , 1 ],
    orgnr           => [ 11, 1 ],
    status          => [ 1 , 0 ],
    trdat           => [ 26, 0 ],
    namn            => [ 36, 0 ],
    kod             => [ 1 , 0 ],
    koddat          => [ 10, 0 ],
    handl           => [ 8 , 0 ],
    ant_styr_and    => [ 3 , 1 ],
    idatkod         => [ 1 , 0 ],
    offdatm         => [ 10, 0 ],
    jurdatm         => [ 10, 0 ],
    uppldat         => [ 26, 0 ],
    ftgtyp          => [ 2 , 0 ],
    ityp            => [ 2 , 0 ],
    ratsw           => [ 1 , 0 ],
    istatus         => [ 1 , 0 ],
);

sub new() {
    my $self = shift->_classobj();
    return bless $self;
}


sub filename {
    my $self = shift;
    return $filename;
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