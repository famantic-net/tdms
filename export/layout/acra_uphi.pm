package acra_uphi;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACRA.UPHI";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acra_uphi = (
    orgnr       => [ 11, 1,  0 ],
    prioklass   => [ 2 , 0,  1 ],
    priolnr     => [ 5 , 1,  2 ],
    status      => [ 1 , 0,  3 ],
    kundkod     => [ 8 , 0,  4 ],
    rappdat     => [ 26, 0,  5 ],
    produkt     => [ 8 , 0,  6 ],
    belopp      => [ 11, 1,  7 ],
    omdkod      => [ 1 , 0,  8 ],
    handl       => [ 8 , 0,  9 ],
    termid      => [ 4 , 0, 10 ],
    trdat       => [ 26, 0, 11 ],
    orgnr2      => [ 11, 1, 12 ],
    katkod      => [ 3 , 1, 13 ],
    fragetyp    => [ 2 , 1, 14 ],
    klient      => [ 1 , 0, 15 ],
    termtyp     => [ 1 , 0, 16 ],
    userid      => [ 8 , 0, 17 ],
    aterfors    => [ 6 , 0, 18 ],
    mallkod     => [ 4 , 0, 19 ],
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