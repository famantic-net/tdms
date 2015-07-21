package actx_tax01;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACTX.TAX01";

# Indicates field length and if sign should be applied
our %actx_tax01 = (
    pnr                      => [ 11, 1 ],
    inkar                    => [ 4 , 0 ],
    taxstat                  => [ 1 , 0 ],
    pnr_sekel                => [ 2 , 1 ],
    ejtaxkod                 => [ 1 , 0 ],
    taxkod                   => [ 1 , 0 ],
    gemform                  => [ 1 , 0 ],
    hkont                    => [ 2 , 0 ],
    hmynd                    => [ 2 , 0 ],
    ink_akt_nrv              => [ 11, 1 ],
    ink_pass_nrv             => [ 11, 1 ],
    ink_tjanst               => [ 11, 1 ],
    ovrskott_kap             => [ 11, 1 ],
    undskott_kap             => [ 11, 1 ],
    forl_avdr                => [ 11, 1 ],
    allm_avdr                => [ 11, 1 ],
    forv_ink                 => [ 11, 1 ],
    kbesk_forv_ink           => [ 11, 1 ],
    sbesk_forv_ink           => [ 11, 1 ],
    forl_avdr_forv           => [ 11, 1 ],
    kforv_ink                => [ 11, 1 ],
    sforv_ink                => [ 11, 1 ],
    allm_sjo_avdr            => [ 11, 1 ],
    besk_sjo_ink             => [ 11, 1 ],
    skattpl_formog           => [ 11, 1 ],
    besk_formog              => [ 11, 1 ],
    sink_kap                 => [ 11, 1 ],
    kink_forv_ink            => [ 11, 1 ],
    sink_forv_ink            => [ 11, 1 ],
    skatt_uppskov            => [ 11, 1 ],
    formog_skatt             => [ 11, 1 ],
    fast_skatt               => [ 11, 1 ],
    mrv_skatt_bet            => [ 11, 1 ],
    mrv_skatt_ater           => [ 11, 1 ],
    sum_suppl                => [ 11, 1 ],
    slutl_skatt              => [ 11, 1 ],
    inbet_askatt             => [ 11, 1 ],
    inbet_bskatt             => [ 11, 1 ],
    sjoman_skatt             => [ 11, 1 ],
    sink_skatt_kapink        => [ 11, 1 ],
    skatt_redukt             => [ 11, 1 ],
    handl1                   => [ 4 , 0 ],
    handl2                   => [ 4 , 1 ],
    uppl_datum               => [ 8 , 1 ],
    andr_datum               => [ 8 , 1 ],
    ftg_kod                  => [ 1 , 0 ],
    sk_expdeb                => [ 11, 1 ],
    sk_expkred_avr           => [ 11, 1 ],
    sum_egen_inb             => [ 11, 1 ],
    typ_nolltax              => [ 1 , 1 ],
    typ_kaptax               => [ 1 , 1 ],
    pnr12                    => [ 12, 1 ],
    bel_sjonarskred          => [ 10, 1 ],
    bel_sktill               => [ 10, 1 ],
    avg_forsen               => [ 10, 1 ],
    bel_forvskred            => [ 10, 1 ],
    avg_pens_allm            => [ 10, 1 ],
    avg_kyrkbegr_ber         => [ 10, 1 ],
    bel_pensskred            => [ 10, 1 ],
    bel_bredskred            => [ 10, 1 ],
    form_sambesk             => [ 1 , 1 ],
    bel_akasskred            => [ 10, 1 ],
    bel_fackskred            => [ 10, 1 ],
    bel_formskred            => [ 10, 1 ],
    bel_formskred11          => [ 11, 1 ],
    bel_sarskred             => [ 3 , 1 ],
    bel_miljoskred           => [ 10, 1 ],
    bel_rotskred             => [ 10, 1 ],
    bel_skogsskred           => [ 10, 1 ],
    usk_nrv_akt_tot          => [ 11, 1 ],
    usk_nrv_pass_tot         => [ 11, 1 ],
    sk_exp_neg               => [ 10, 1 ],
    bel_arbinkskred          => [ 10, 1 ],
    bel_hushskred            => [ 10, 1 ],
    avg_fast                 => [ 11, 1 ],
    bel_favgskred            => [ 11, 1 ],
    sk_exp_ater              => [ 11, 1 ],
    bel_gavoskred            => [ 11, 1 ],
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