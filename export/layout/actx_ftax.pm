package actx_ftax;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACTX.FTAX";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %actx_ftax = (
    orgnr               => [ 11, 1,  0 ],
    lnr                 => [ 5 , 1,  1 ],
    priotax             => [ 9 , 1,  2 ],
    prioandel           => [ 3 , 1,  3 ],
    priolnr             => [ 5 , 1,  4 ],
    lsm                 => [ 2 , 1,  5 ],
    nr_taxlop           => [ 6 , 1,  6 ],
    nr_del              => [ 4 , 1,  7 ],
    status              => [ 1 , 0,  8 ],
    beteckning          => [ 32, 0,  9 ],
    typkod              => [ 4 , 0, 10 ],
    areal               => [ 11, 1, 11 ],
    lag_datum           => [ 10, 0, 12 ],
    lan                 => [ 2 , 0, 13 ],
    kom                 => [ 2 , 0, 14 ],
    fors                => [ 2 , 0, 15 ],
    tax                 => [ 9 , 1, 16 ],
    bygg                => [ 9 , 1, 17 ],
    mark                => [ 9 , 1, 18 ],
    andel               => [ 3 , 1, 19 ],
    egkat               => [ 2 , 0, 20 ],
    skill               => [ 9 , 1, 21 ],
    int                 => [ 9 , 1, 22 ],
    samb_typ            => [ 1 , 0, 23 ],
    ant_tax_enh         => [ 4 , 1, 24 ],
    ar_sek_tax_from     => [ 4 , 1, 25 ],
    ant_agare           => [ 4 , 1, 26 ],
    kod_dekl_ansv       => [ 2 , 1, 27 ],
    id_taxenhet         => [ 8 , 0, 28 ],
    sammanforings_fel   => [ 2 , 0, 29 ],
    ant_samb_ner        => [ 5 , 1, 30 ],
    taxlop_samb_u       => [ 6 , 1, 31 ],
    nr_del_samb_u       => [ 4 , 1, 32 ],
    upplagd_av          => [ 4 , 0, 33 ],
    andrad_av           => [ 4 , 0, 34 ],
    typ_agande          => [ 2 , 1, 35 ],
    sambtyp2_lnr        => [ 3 , 1, 36 ],
    tr_datum            => [ 26, 0, 37 ],
    ar_bygg             => [ 4 , 1, 38 ],
    ar_tillbygg         => [ 4 , 1, 39 ],
    yta_bost            => [ 5 , 1, 40 ],
    yta_bi              => [ 5 , 1, 41 ],
    yta_bo_tillbygg     => [ 5 , 1, 42 ],
    ar_varde            => [ 4 , 1, 43 ],
    yta_varde           => [ 5 , 1, 44 ],
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