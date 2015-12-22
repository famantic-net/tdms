package acra_rapp;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACRA.RAPP";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acra_rapp = (
    orgnr      => [ 11, 1,  0 ],
    rappkod    => [ 4,  0,  1 ],
    uppldat    => [ 26, 0,  2 ],
    priokod    => [ 2,  0,  3 ],
    grupp      => [ 2,  0,  4 ],
    rappdat1   => [ 10, 0,  5 ],
    rappdat2   => [ 10, 0,  6 ],
    status     => [ 1,  0,  7 ],
    myndkod    => [ 4,  0,  8 ],
    diarnr     => [ 6,  0,  9 ],
    buntnr     => [ 6,  0, 10 ],
    belopp     => [ 11, 1, 11 ],
    utredn     => [ 1,  0, 12 ],
    katkod     => [ 1,  0, 13 ],
    trdat      => [ 26, 0, 14 ],
    handl      => [ 8,  0, 15 ],
    orgnr2     => [ 11, 1, 16 ],
    priolnr    => [ 5,  1, 17 ],
    text       => [ 36, 0, 18 ],
    forv       => [ 5,  0, 19 ],
    shjkod     => [ 1,  0, 20 ],
    ratstat    => [ 1,  1, 21 ],
    ratstatus  => [ 1,  0, 22 ],
    bevkod     => [ 1,  0, 23 ], 
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