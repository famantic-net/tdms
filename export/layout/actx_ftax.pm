package actx_ftax;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACTX.FTAX";

# Indicates field length and if sign should be applied
our %actx_ftax = (
    orgnr               => [ 11, 1 ],
    lnr                 => [ 5 , 1 ],
    priotax             => [ 9 , 1 ],
    prioandel           => [ 3 , 1 ],
    priolnr             => [ 5 , 1 ],
    lsm                 => [ 2 , 1 ],
    nr_taxlop           => [ 6 , 1 ],
    nr_del              => [ 4 , 1 ],
    status              => [ 1 , 0 ],
    beteckning          => [ 32, 0 ],
    typkod              => [ 4 , 0 ],
    areal               => [ 11, 1 ],
    lag_datum           => [ 10, 0 ],
    lan                 => [ 2 , 0 ],
    kom                 => [ 2 , 0 ],
    fors                => [ 2 , 0 ],
    tax                 => [ 9 , 1 ],
    bygg                => [ 9 , 1 ],
    mark                => [ 9 , 1 ],
    andel               => [ 3 , 1 ],
    egkat               => [ 2 , 0 ],
    skill               => [ 9 , 1 ],
    int                 => [ 9 , 1 ],
    samb_typ            => [ 1 , 0 ],
    ant_tax_enh         => [ 4 , 1 ],
    ar_sek_tax_from     => [ 4 , 1 ],
    ant_agare           => [ 4 , 1 ],
    kod_dekl_ansv       => [ 2 , 1 ],
    id_taxenhet         => [ 8 , 0 ],
    sammanforings_fel   => [ 2 , 0 ],
    ant_samb_ner        => [ 5 , 1 ],
    taxlop_samb_u       => [ 6 , 1 ],
    nr_del_samb_u       => [ 4 , 1 ],
    upplagd_av          => [ 4 , 0 ],
    andrad_av           => [ 4 , 0 ],
    typ_agande          => [ 2 , 1 ],
    sambtyp2_lnr        => [ 3 , 1 ],
    tr_datum            => [ 26, 0 ],
    ar_bygg             => [ 4 , 1 ],
    ar_tillbygg         => [ 4 , 1 ],
    yta_bost            => [ 5 , 1 ],
    yta_bi              => [ 5 , 1 ],
    yta_bo_tillbygg     => [ 5 , 1 ],
    ar_varde            => [ 4 , 1 ],
    yta_varde           => [ 5 , 1 ],
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