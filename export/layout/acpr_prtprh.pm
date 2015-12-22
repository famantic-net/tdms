package acpr_prtprh;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACPR.PRTPRH";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acpr_prtprh = (
    pnr                 => [ 10, 1,  0 ],
    pnr12               => [ 12, 1,  1 ],
    uppdat_tid          => [ 26, 0,  2 ],
    eff_datum           => [ 10, 0,  3 ],
    hpnr12              => [ 12, 1,  4 ],
    namn                => [ 36, 0,  5 ],
    namnkod             => [ 2 , 0,  6 ],
    avliden             => [ 8 , 0,  7 ],
    berak_avliden       => [ 10, 0,  8 ],
    skyddad             => [ 1 , 0,  9 ],
    spaadr              => [ 1 , 0, 10 ],
    fbf_mrk             => [ 1 , 0, 11 ],
    rednamn_mrk         => [ 1 , 0, 12 ],
    sp_coadress         => [ 35, 0, 13 ],
    sp_foadress         => [ 35, 0, 14 ],
    sp_gatuadress       => [ 35, 0, 15 ],
    sp_postnr           => [ 5 , 0, 16 ],
    sp_postort          => [ 27, 0, 17 ],
    utl_landkod         => [ 4 , 0, 18 ],
    utl_postkod         => [ 9 , 0, 19 ],
    utl_postort         => [ 27, 0, 20 ],
    utl_land            => [ 35, 0, 21 ],
    mnamn               => [ 40, 0, 22 ],
    enamn               => [ 60, 0, 23 ],
    fnamn               => [ 80, 0, 24 ],
    fbf_coadress        => [ 35, 0, 25 ],
    fbf_foadress        => [ 35, 0, 26 ],
    fbf_gatuadress      => [ 35, 0, 27 ],
    fbf_postnr          => [ 5 , 0, 28 ],
    fbf_postort         => [ 27, 0, 29 ],
    lkf                 => [ 6 , 0, 30 ],
    afbrel_mrk          => [ 1 , 0, 31 ],
    rel_pnr             => [ 12, 1, 32 ],
    civst               => [ 1 , 0, 33 ],
    civst_datum         => [ 10, 0, 34 ],
    sep_datum           => [ 10, 0, 35 ],
    berak_civst         => [ 1 , 0, 36 ],
    medb                => [ 1 , 0, 37 ],
    medb_datum          => [ 10, 0, 38 ],
    inut                => [ 1 , 0, 39 ],
    inut_datum          => [ 10, 0, 40 ],
    status              => [ 1 , 0, 41 ],
    flytt_flag          => [ 1 , 0, 42 ],
    traffkod            => [ 2 , 0, 43 ],
    handl               => [ 8 , 0, 44 ],
    test                => [ 1 , 0, 45 ],
    namn_flag           => [ 1 , 0, 46 ],
    fadr_flag           => [ 1 , 0, 47 ],
    sadr_flag           => [ 1 , 0, 48 ],
    eff_n_a_nytt_datum  => [ 10, 0, 49 ],
    tom_datum           => [ 10, 0, 50 ],
    sparrtyp            => [ 2 , 0, 51 ],
    aktf_datum          => [ 10, 0, 52 ],
    bosk_datum          => [ 10, 0, 53 ],
    omyn                => [ 1 , 0, 54 ],
    omyn_datum          => [ 10, 0, 55 ],
    rel_pnr_flag        => [ 1 , 0, 56 ],
    civst_flag          => [ 1 , 0, 57 ],
    inut_flag           => [ 1 , 0, 58 ],
    sparrtyp_flag       => [ 1 , 0, 59 ],
    aktf_flag           => [ 1 , 0, 60 ],
    bosk_flag           => [ 1 , 0, 61 ],
    omyn_flag           => [ 1 , 0, 62 ],
    aktf_kod            => [ 1 , 0, 63 ],
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