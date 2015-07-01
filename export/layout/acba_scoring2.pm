package acba_scoring2;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACBA.SCORING2";

# Indicates field length and if sign should be applied
our %acba_scoring2 = (
    orgnr                 => [ 11, 1 ],
    score_sol             => [ 3 , 1 ],
    score_dob             => [ 3 , 1 ],
    raw_score_sol         => [ 4 , 1 ],
    raw_score_dob         => [ 4 , 1 ],
    scodat                => [ 26, 0 ],
    salder                => [ 1 , 0 ],
    sagare                => [ 1 , 0 ],
    sekonomi              => [ 1 , 0 ],
    sbethist              => [ 1 , 0 ],
    limbel                => [ 9 , 1 ],
    limproc               => [ 3 , 1 ],
    riskproc_sol          => [ 5 , 1 ],
    riskproc_dob          => [ 5 , 1 ],
    salder_p              => [ 5 , 1 ],
    sagare_p              => [ 5 , 1 ],
    sekonomi_p            => [ 5 , 1 ],
    sbethist_p            => [ 5 , 1 ],
    ftgtyp                => [ 2 , 0 ],
    bransch               => [ 2 , 0 ],
    modell                => [ 1 , 0 ],
    override_kod          => [ 2 , 0 ],
    exkl                  => [ 1 , 0 ],
    omfr_per_f            => [ 3 , 1 ],
    omfr_per_f_p          => [ 5 , 1 ],
    omfr_per_p            => [ 3 , 1 ],
    omfr_per_p_p          => [ 5 , 1 ],
    omfr_per_i            => [ 3 , 1 ],
    omfr_per_i_p          => [ 5 , 1 ],
    alder_f               => [ 3 , 1 ],
    alder_f_p             => [ 5 , 1 ],
    fskatt_kod            => [ 1 , 0 ],
    fskatt_kod_p          => [ 5 , 1 ],
    skatt                 => [ 11, 1 ],
    skatt_p               => [ 5 , 1 ],
    oversk_kapital        => [ 11, 1 ],
    oversk_kapital_p      => [ 5 , 1 ],
    fast_tax              => [ 13, 1 ],
    fast_tax_p            => [ 5 , 1 ],
    fast_ant              => [ 5 , 1 ],
    fast_ant_p            => [ 5 , 1 ],
    adr_andr              => [ 3 , 1 ],
    adr_andr_p            => [ 5 , 1 ],
    tot_ink               => [ 11, 1 ],
    tot_ink_p             => [ 5 , 1 ],
    allm_avdrag           => [ 11, 1 ],
    allm_avdrag_p         => [ 5 , 1 ],
    foer_skatt            => [ 15, 1 ],
    foer_skatt_p          => [ 5 , 1 ],
    intr_kk               => [ 3 , 1 ],
    intr_kk_p             => [ 5 , 1 ],
    skild_tid             => [ 3 , 1 ],
    skild_tid_p           => [ 5 , 1 ],
    anm_ant               => [ 5 , 1 ],
    anm_ant_p             => [ 5 , 1 ],
    anm_tid               => [ 3 , 1 ],
    anm_tid_p             => [ 5 , 1 ],
    antal_a               => [ 5 , 1 ],
    antal_e               => [ 5 , 1 ],
    antal_a_e_p           => [ 5 , 1 ],
    saldo_a               => [ 11, 1 ],
    saldo_a_p             => [ 5 , 1 ],
    ftgint_tid            => [ 3 , 1 ],
    ftgint_tid_p          => [ 5 , 1 ],
    involv_kk             => [ 3 , 1 ],
    involv_kk_p           => [ 5 , 1 ],
    sni                   => [ 1 , 0 ],
    sni_p                 => [ 5 , 1 ],
    bet_forel_ant         => [ 5 , 1 ],
    bet_forel_ant_p       => [ 5 , 1 ],
    bet_forel_bel         => [ 11, 1 ],
    bet_forel_bel_p       => [ 5 , 1 ],
    betindex              => [ 5 , 1 ],
    betindex_p            => [ 5 , 1 ],
    foer_betindex         => [ 5 , 1 ],
    foer_betindex_p       => [ 5 , 1 ],
    bok_dat               => [ 6 , 1 ],
    bok_alder             => [ 3 , 1 ],
    bok_alder_p           => [ 5 , 1 ],
    rev_anm               => [ 1 , 1 ],
    rev_anm_p             => [ 5 , 1 ],
    fin_tillg             => [ 15, 1 ],
    fin_tillg_p           => [ 5 , 1 ],
    cashflow              => [ 11, 1 ],
    cashflow_p            => [ 5 , 1 ],
    negres_likv           => [ 1 , 1 ],
    negres_likv_p         => [ 5 , 1 ],
    egkap_akap            => [ 1 , 1 ],
    egkap_akap_p          => [ 5 , 1 ],
    oms                   => [ 11, 1 ],
    oms_p                 => [ 5 , 1 ],
    foer_oms              => [ 15, 1 ],
    foer_oms_p            => [ 5 , 1 ],
    sol                   => [ 15, 1 ],
    sol_p                 => [ 5 , 1 ],
    foer_sol              => [ 15, 1 ],
    foer_sol_p            => [ 5 , 1 ],
    balanslikv            => [ 15, 1 ],
    balanslikv_p          => [ 5 , 1 ],
    snitt_skuldrta        => [ 15, 1 ],
    snitt_skuldrta_p      => [ 5 , 1 ],
    kassa_rkost           => [ 15, 1 ],
    kassa_rkost_p         => [ 5 , 1 ],
    foer_anst             => [ 15, 1 ],
    foer_anst_p           => [ 5 , 1 ],
    styr_ant              => [ 3 , 1 ],
    styr_ant_p            => [ 5 , 1 ],
    snitt_styrandr_tid    => [ 3 , 1 ],
    snitt_styrandr_tid_p  => [ 5 , 1 ],
    snitt_ink_e_sk_styr   => [ 13, 1 ],
    snitt_ink_e_sk_styr_p => [ 5 , 1 ],
    snitt_ink_f_sk_styr   => [ 13, 1 ],
    snitt_ink_f_sk_styr_p => [ 5 , 1 ],
    antal_a_styr          => [ 5 , 1 ],
    antal_a_styr_p        => [ 5 , 1 ],
    saldo_a_styr          => [ 11, 1 ],
    saldo_a_styr_p        => [ 5 , 1 ],
    anm_styr_tid          => [ 3 , 1 ],
    anm_styr_tid_p        => [ 5 , 1 ],
    anm_styr_ant          => [ 5 , 1 ],
    anm_styr_ant_p        => [ 5 , 1 ],
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