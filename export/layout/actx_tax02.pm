package actx_tax02;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACTX.TAX02";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %actx_tax02 = (
    pnr                  => [ 11, 1,  0 ],
    inkar                => [ 4 , 0,  1 ],
    taxstat              => [ 1 , 0,  2 ],
    pnr_sekel            => [ 2 , 1,  3 ],
    ejtaxkod             => [ 1 , 0,  4 ],
    taxkod               => [ 1 , 0,  5 ],
    gemform              => [ 1 , 0,  6 ],
    hkont                => [ 2 , 0,  7 ],
    hmynd                => [ 2 , 0,  8 ],
    ink_akt_nrv          => [ 11, 1,  9 ],
    ink_pass_nrv         => [ 11, 1, 10 ],
    ink_tjanst           => [ 11, 1, 11 ],
    ovrskott_kap         => [ 11, 1, 12 ],
    undskott_kap         => [ 11, 1, 13 ],
    forl_avdr            => [ 11, 1, 14 ],
    allm_avdr            => [ 11, 1, 15 ],
    forv_ink             => [ 11, 1, 16 ],
    kbesk_forv_ink       => [ 11, 1, 17 ],
    sbesk_forv_ink       => [ 11, 1, 18 ],
    forl_avdr_forv       => [ 11, 1, 19 ],
    kforv_ink            => [ 11, 1, 20 ],
    sforv_ink            => [ 11, 1, 21 ],
    allm_sjo_avdr        => [ 11, 1, 22 ],
    besk_sjo_ink         => [ 11, 1, 23 ],
    skattpl_formog       => [ 11, 1, 24 ],
    besk_formog          => [ 11, 1, 25 ],
    sink_kap             => [ 11, 1, 26 ],
    kink_forv_ink        => [ 11, 1, 27 ],
    sink_forv_ink        => [ 11, 1, 28 ],
    skatt_uppskov        => [ 11, 1, 29 ],
    formog_skatt         => [ 11, 1, 30 ],
    fast_skatt           => [ 11, 1, 31 ],
    mrv_skatt_bet        => [ 11, 1, 32 ],
    mrv_skatt_ater       => [ 11, 1, 33 ],
    sum_suppl            => [ 11, 1, 34 ],
    slutl_skatt          => [ 11, 1, 35 ],
    inbet_askatt         => [ 11, 1, 36 ],
    inbet_bskatt         => [ 11, 1, 37 ],
    sjoman_skatt         => [ 11, 1, 38 ],
    sink_skatt_kapink    => [ 11, 1, 39 ],
    skatt_redukt         => [ 11, 1, 40 ],
    handl1               => [ 4 , 0, 41 ],
    handl2               => [ 4 , 0, 42 ],
    uppl_datum           => [ 8 , 1, 43 ],
    andr_datum           => [ 8 , 1, 44 ],
    ftg_kod              => [ 1 , 0, 45 ],
    sk_expdeb            => [ 11, 1, 46 ],
    sk_expkred_avr       => [ 11, 1, 47 ],
    sum_egen_inb         => [ 11, 1, 48 ],
    typ_nolltax          => [ 1 , 1, 49 ],
    typ_kaptax           => [ 1 , 1, 50 ],
    pnr12                => [ 12, 1, 51 ],
    bel_sjonarskred      => [ 10, 1, 52 ],
    bel_sktill           => [ 10, 1, 53 ],
    avg_forsen           => [ 10, 1, 54 ],
    bel_forvskred        => [ 10, 1, 55 ],
    avg_pens_allm        => [ 10, 1, 56 ],
    avg_kyrkbegr_ber     => [ 10, 1, 57 ],
    bel_pensskred        => [ 10, 1, 58 ],
    bel_bredskred        => [ 10, 1, 59 ],
    form_sambesk         => [ 1 , 1, 60 ],
    bel_akasskred        => [ 10, 1, 61 ],
    bel_fackskred        => [ 10, 1, 62 ],
    bel_formskred        => [ 10, 1, 63 ],
    bel_formskred11      => [ 11, 1, 64 ],
    bel_sarskred         => [ 3 , 1, 65 ],
    bel_miljoskred       => [ 10, 1, 66 ],
    bel_rotskred         => [ 10, 1, 67 ],
    bel_skogsskred       => [ 10, 1, 68 ],
    usk_nrv_akt_tot      => [ 11, 1, 69 ],
    usk_nrv_pass_tot     => [ 11, 1, 70 ],
    sk_exp_neg           => [ 10, 1, 71 ],
    bel_arbinkskred      => [ 10, 1, 72 ],
    bel_hushskred        => [ 10, 1, 73 ],
    avg_fast             => [ 11, 1, 74 ],
    bel_favgskred        => [ 11, 1, 75 ],
    sk_exp_ater          => [ 11, 1, 76 ],
    bel_gavoskred        => [ 11, 1, 77 ],
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