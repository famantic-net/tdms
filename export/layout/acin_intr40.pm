package acin_intr40;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIN.INTR40";

# Indicates field length and if sign should be applied
our %acin_intr40 = (
    priokod           => [ 2 , 0 ],
    pnr               => [ 11, 1 ],
    plnr              => [ 3 , 1 ],
    orgnr             => [ 11, 1 ],
    status            => [ 1 , 0 ],
    trdat             => [ 26, 0 ],
    namn              => [ 36, 0 ],
    kod               => [ 1 , 0 ],
    koddat            => [ 10, 0 ],
    handl             => [ 8 , 0 ],
    ant_styr_and      => [ 3 , 1 ],
    idatkod           => [ 1 , 0 ],
    offdatm           => [ 10, 0 ],
    jurdatm           => [ 10, 0 ],
    uppldat           => [ 26, 0 ],
    ftgtyp            => [ 2 , 0 ],
    ityp              => [ 2 , 0 ],
    ratsw             => [ 1 , 0 ],
    istatus           => [ 1 , 0 ],
    avgdatum          => [ 10, 0 ],
    namnas            => [ 48, 0 ],
    uppl_handl        => [ 8 , 0 ],
    andr_handl        => [ 8 , 0 ],
    uppldat2          => [ 26, 0 ],
    trdat2            => [ 26, 0 ],
    santv             => [ 5 , 1 ],
    lantv             => [ 5 , 1 ],
    funkkod           => [ 1 , 0 ],
    aktkod1           => [ 4 , 0 ],
    aktdat1           => [ 10, 0 ],
    aktkod2           => [ 4 , 0 ],
    aktdat2           => [ 10, 0 ],
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