package acba_scoring2;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACBA.SCORING2";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acba_scoring2 = (
    orgnr                 => [ 11, 1,   0 ],
    score_sol             => [ 3 , 1,   1 ],
    score_dob             => [ 3 , 1,   2 ],
    raw_score_sol         => [ 4 , 1,   3 ],
    raw_score_dob         => [ 4 , 1,   4 ],
    scodat                => [ 26, 0,   5 ],
    salder                => [ 1 , 0,   6 ],
    sagare                => [ 1 , 0,   7 ],
    sekonomi              => [ 1 , 0,   8 ],
    sbethist              => [ 1 , 0,   9 ],
    limbel                => [ 9 , 1,  10 ],
    limproc               => [ 3 , 1,  11 ],
    riskproc_sol          => [ 5 , 1,  12 ],
    riskproc_dob          => [ 5 , 1,  13 ],
    salder_p              => [ 5 , 1,  14 ],
    sagare_p              => [ 5 , 1,  15 ],
    sekonomi_p            => [ 5 , 1,  16 ],
    sbethist_p            => [ 5 , 1,  17 ],
    ftgtyp                => [ 2 , 0,  18 ],
    bransch               => [ 2 , 0,  19 ],
    modell                => [ 1 , 0,  20 ],
    override_kod          => [ 2 , 0,  21 ],
    exkl                  => [ 1 , 0,  22 ],
    omfr_per_f            => [ 3 , 1,  23 ],
    omfr_per_f_p          => [ 5 , 1,  24 ],
    omfr_per_p            => [ 3 , 1,  25 ],
    omfr_per_p_p          => [ 5 , 1,  26 ],
    omfr_per_i            => [ 3 , 1,  27 ],
    omfr_per_i_p          => [ 5 , 1,  28 ],
    alder_f               => [ 3 , 1,  29 ],
    alder_f_p             => [ 5 , 1,  30 ],
    fskatt_kod            => [ 1 , 0,  31 ],
    fskatt_kod_p          => [ 5 , 1,  32 ],
    skatt                 => [ 11, 1,  33 ],
    skatt_p               => [ 5 , 1,  34 ],
    oversk_kapital        => [ 11, 1,  35 ],
    oversk_kapital_p      => [ 5 , 1,  36 ],
    fast_tax              => [ 13, 1,  37 ],
    fast_tax_p            => [ 5 , 1,  38 ],
    fast_ant              => [ 5 , 1,  39 ],
    fast_ant_p            => [ 5 , 1,  40 ],
    adr_andr              => [ 3 , 1,  41 ],
    adr_andr_p            => [ 5 , 1,  42 ],
    tot_ink               => [ 11, 1,  43 ],
    tot_ink_p             => [ 5 , 1,  44 ],
    allm_avdrag           => [ 11, 1,  45 ],
    allm_avdrag_p         => [ 5 , 1,  46 ],
    foer_skatt            => [ 15, 1,  47 ],
    foer_skatt_p          => [ 5 , 1,  48 ],
    intr_kk               => [ 3 , 1,  49 ],
    intr_kk_p             => [ 5 , 1,  50 ],
    skild_tid             => [ 3 , 1,  51 ],
    skild_tid_p           => [ 5 , 1,  52 ],
    anm_ant               => [ 5 , 1,  53 ],
    anm_ant_p             => [ 5 , 1,  54 ],
    anm_tid               => [ 3 , 1,  55 ],
    anm_tid_p             => [ 5 , 1,  56 ],
    antal_a               => [ 5 , 1,  57 ],
    antal_e               => [ 5 , 1,  58 ],
    antal_a_e_p           => [ 5 , 1,  59 ],
    saldo_a               => [ 11, 1,  60 ],
    saldo_a_p             => [ 5 , 1,  61 ],
    ftgint_tid            => [ 3 , 1,  62 ],
    ftgint_tid_p          => [ 5 , 1,  63 ],
    involv_kk             => [ 3 , 1,  64 ],
    involv_kk_p           => [ 5 , 1,  65 ],
    sni                   => [ 1 , 0,  66 ],
    sni_p                 => [ 5 , 1,  67 ],
    bet_forel_ant         => [ 5 , 1,  68 ],
    bet_forel_ant_p       => [ 5 , 1,  69 ],
    bet_forel_bel         => [ 11, 1,  70 ],
    bet_forel_bel_p       => [ 5 , 1,  71 ],
    betindex              => [ 5 , 1,  72 ],
    betindex_p            => [ 5 , 1,  73 ],
    foer_betindex         => [ 5 , 1,  74 ],
    foer_betindex_p       => [ 5 , 1,  75 ],
    bok_dat               => [ 6 , 1,  76 ],
    bok_alder             => [ 3 , 1,  77 ],
    bok_alder_p           => [ 5 , 1,  78 ],
    rev_anm               => [ 1 , 1,  79 ],
    rev_anm_p             => [ 5 , 1,  80 ],
    fin_tillg             => [ 15, 1,  81 ],
    fin_tillg_p           => [ 5 , 1,  82 ],
    cashflow              => [ 11, 1,  83 ],
    cashflow_p            => [ 5 , 1,  84 ],
    negres_likv           => [ 1 , 1,  85 ],
    negres_likv_p         => [ 5 , 1,  86 ],
    egkap_akap            => [ 1 , 1,  87 ],
    egkap_akap_p          => [ 5 , 1,  88 ],
    oms                   => [ 11, 1,  89 ],
    oms_p                 => [ 5 , 1,  90 ],
    foer_oms              => [ 15, 1,  91 ],
    foer_oms_p            => [ 5 , 1,  92 ],
    sol                   => [ 15, 1,  93 ],
    sol_p                 => [ 5 , 1,  94 ],
    foer_sol              => [ 15, 1,  95 ],
    foer_sol_p            => [ 5 , 1,  96 ],
    balanslikv            => [ 15, 1,  97 ],
    balanslikv_p          => [ 5 , 1,  98 ],
    snitt_skuldrta        => [ 15, 1,  99 ],
    snitt_skuldrta_p      => [ 5 , 1, 100 ],
    kassa_rkost           => [ 15, 1, 101 ],
    kassa_rkost_p         => [ 5 , 1, 102 ],
    foer_anst             => [ 15, 1, 103 ],
    foer_anst_p           => [ 5 , 1, 104 ],
    styr_ant              => [ 3 , 1, 105 ],
    styr_ant_p            => [ 5 , 1, 106 ],
    snitt_styrandr_tid    => [ 3 , 1, 107 ],
    snitt_styrandr_tid_p  => [ 5 , 1, 108 ],
    snitt_ink_e_sk_styr   => [ 13, 1, 109 ],
    snitt_ink_e_sk_styr_p => [ 5 , 1, 110 ],
    snitt_ink_f_sk_styr   => [ 13, 1, 111 ],
    snitt_ink_f_sk_styr_p => [ 5 , 1, 112 ],
    antal_a_styr          => [ 5 , 1, 113 ],
    antal_a_styr_p        => [ 5 , 1, 114 ],
    saldo_a_styr          => [ 11, 1, 115 ],
    saldo_a_styr_p        => [ 5 , 1, 116 ],
    anm_styr_tid          => [ 3 , 1, 117 ],
    anm_styr_tid_p        => [ 5 , 1, 118 ],
    anm_styr_ant          => [ 5 , 1, 119 ],
    anm_styr_ant_p        => [ 5 , 1, 120 ],
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