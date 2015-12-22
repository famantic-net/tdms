package acpr_prtpr;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACPR.PRTPR";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acpr_prtpr = (
    pnr                 => [ 10, 1,  0 ],
    pnr12               => [ 12, 1,  1 ],
    hpnr12              => [ 12, 1,  2 ],
    eff_datum           => [ 10, 0,  3 ],
    namn                => [ 36, 0,  4 ],
    namnkod             => [ 2 , 0,  5 ],
    avliden             => [ 8 , 0,  6 ],
    berak_avliden       => [ 10, 0,  7 ],
    skyddad             => [ 1 , 0,  8 ],
    spaadr              => [ 1 , 0,  9 ],
    fbf_mrk             => [ 1 , 0, 10 ],
    rednamn_mrk         => [ 1 , 0, 11 ],
    sp_coadress         => [ 35, 0, 12 ],
    sp_foadress         => [ 35, 0, 13 ],
    sp_gatuadress       => [ 35, 0, 14 ],
    sp_postnr           => [ 5 , 0, 15 ],
    sp_postort          => [ 27, 0, 16 ],
    utl_landkod         => [ 4 , 0, 17 ],
    utl_postkod         => [ 9 , 0, 18 ],
    utl_postort         => [ 27, 0, 19 ],
    utl_land            => [ 35, 0, 20 ],
    mnamn               => [ 40, 0, 21 ],
    enamn               => [ 60, 0, 22 ],
    fnamn               => [ 80, 0, 23 ],
    fbf_coadress        => [ 35, 0, 24 ],
    fbf_foadress        => [ 35, 0, 25 ],
    fbf_gatuadress      => [ 35, 0, 26 ],
    fbf_postnr          => [ 5 , 0, 27 ],
    fbf_postort         => [ 27, 0, 28 ],
    lkf                 => [ 6 , 0, 29 ],
    afbrel_mrk          => [ 1 , 0, 30 ],
    rel_pnr             => [ 12, 1, 31 ],
    civst               => [ 1 , 0, 32 ],
    civst_datum         => [ 10, 0, 33 ],
    sep_datum           => [ 10, 0, 34 ],
    berak_civst         => [ 1 , 0, 35 ],
    medb                => [ 1 , 0, 36 ],
    medb_datum          => [ 10, 0, 37 ],
    inut                => [ 1 , 0, 38 ],
    inut_datum          => [ 10, 0, 39 ],
    status              => [ 1 , 0, 40 ],
    flytt_flag          => [ 1 , 0, 41 ],
    traffkod            => [ 2 , 0, 42 ],
    handl               => [ 8 , 0, 43 ],
    test                => [ 1 , 0, 44 ],
    uppdat_tid          => [ 26, 0, 45 ],
    namn_flag           => [ 1 , 0, 46 ],
    fadr_flag           => [ 1 , 0, 47 ],
    sadr_flag           => [ 1 , 0, 48 ],
    eff_n_a_nytt_datum  => [ 10, 0, 49 ],
    sparrtyp            => [ 2 , 0, 50 ],
    aktf_datum          => [ 10, 0, 51 ],
    bosk_datum          => [ 10, 0, 52 ],
    omyn                => [ 1 , 0, 53 ],
    omyn_datum          => [ 10, 0, 54 ],
    rel_pnr_flag        => [ 1 , 0, 55 ],
    civst_flag          => [ 1 , 0, 56 ],
    inut_flag           => [ 1 , 0, 57 ],
    sparrtyp_flag       => [ 1 , 0, 58 ],
    aktf_flag           => [ 1 , 0, 59 ],
    bosk_flag           => [ 1 , 0, 60 ],
    omyn_flag           => [ 1 , 0, 61 ],
    aktf_kod            => [ 1 , 0, 62 ],
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