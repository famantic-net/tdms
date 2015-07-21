package acra_uphi;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACRA.UPHI";

# Indicates field length and if sign should be applied
our %acra_uphi = (
    orgnr       => [ 11, 1 ],
    prioklass   => [ 2 , 0 ],
    priolnr     => [ 5 , 1 ],
    status      => [ 1 , 0 ],
    kundkod     => [ 8 , 0 ],
    rappdat     => [ 26, 0 ],
    produkt     => [ 8 , 0 ],
    belopp      => [ 11, 1 ],
    omdkod      => [ 1 , 0 ],
    handl       => [ 8 , 0 ],
    termid      => [ 4 , 0 ],
    trdat       => [ 26, 0 ],
    orgnr2      => [ 11, 1 ],
    katkod      => [ 3 , 1 ],
    fragetyp    => [ 2 , 1 ],
    klient      => [ 1 , 0 ],
    termtyp     => [ 1 , 0 ],
    userid      => [ 8 , 0 ],
    aterfors    => [ 6 , 0 ],
    mallkod     => [ 4 , 0 ],
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