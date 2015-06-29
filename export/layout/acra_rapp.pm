package acra_rapp;

use strict;
#use feature 'unicode_strings';
use Unicode::GCString;
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACRA.RAPP";

# Indicates field length and if sign should be applied
our %acra_rapp = (
    orgnr      => [ 11, 1 ],
    rappkod    => [ 4,  0 ],
    uppldat    => [ 26, 0 ],
    priokod    => [ 2,  0 ],
    grupp      => [ 2,  0 ],
    rappdat1   => [ 10, 0 ],
    rappdat2   => [ 10, 0 ],
    status     => [ 1,  0 ],
    myndkod    => [ 4,  0 ],
    diarnr     => [ 6,  0 ],
    buntnr     => [ 6,  0 ],
    belopp     => [ 11, 1 ],
    utredn     => [ 1,  0 ],
    katkod     => [ 1,  0 ],
    trdat      => [ 26, 0 ],
    handl      => [ 8,  0 ],
    orgnr2     => [ 11, 1 ],
    priolnr    => [ 5,  1 ],
    text       => [ 36, 0 ],
    forv       => [ 5,  0 ],
    shjkod     => [ 1,  0 ],
    ratstat    => [ 1,  1 ],
    ratstatus  => [ 1,  0 ],
    bevkod     => [ 1,  0 ], 
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