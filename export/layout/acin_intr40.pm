package acin_intr40;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIN.INTR40";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acin_intr40 = (
    priokod           => [ 2 , 0,  0 ],
    pnr               => [ 11, 1,  1 ],
    plnr              => [ 3 , 1,  2 ],
    orgnr             => [ 11, 1,  3 ],
    status            => [ 1 , 0,  4 ],
    trdat             => [ 26, 0,  5 ],
    namn              => [ 36, 0,  6 ],
    kod               => [ 1 , 0,  7 ],
    koddat            => [ 10, 0,  8 ],
    handl             => [ 8 , 0,  9 ],
    ant_styr_and      => [ 3 , 1, 10 ],
    idatkod           => [ 1 , 0, 11 ],
    offdatm           => [ 10, 0, 12 ],
    jurdatm           => [ 10, 0, 13 ],
    uppldat           => [ 26, 0, 14 ],
    ftgtyp            => [ 2 , 0, 15 ],
    ityp              => [ 2 , 0, 16 ],
    ratsw             => [ 1 , 0, 17 ],
    istatus           => [ 1 , 0, 18 ],
    avgdatum          => [ 10, 0, 19 ],
    namnas            => [ 48, 0, 20 ],
    uppl_handl        => [ 8 , 0, 21 ],
    andr_handl        => [ 8 , 0, 22 ],
    uppldat2          => [ 26, 0, 23 ],
    trdat2            => [ 26, 0, 24 ],
    santv             => [ 5 , 1, 25 ],
    lantv             => [ 5 , 1, 26 ],
    funkkod           => [ 1 , 0, 27 ],
    aktkod1           => [ 4 , 0, 28 ],
    aktdat1           => [ 10, 0, 29 ],
    aktkod2           => [ 4 , 0, 30 ],
    aktdat2           => [ 10, 0, 31 ],
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