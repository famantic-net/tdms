package acpr_prtpr;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACPR.PRTPR";

# Indicates field length and if sign should be applied
our %acpr_prtpr = (
    pnr                 => [ 10, 1 ],
    pnr12               => [ 12, 1 ],
    hpnr12              => [ 12, 1 ],
    eff_datum           => [ 10, 0 ],
    namn                => [ 36, 0 ],
    namnkod             => [ 2 , 0 ],
    avliden             => [ 8 , 0 ],
    berak_avliden       => [ 10, 0 ],
    skyddad             => [ 1 , 0 ],
    spaadr              => [ 1 , 0 ],
    fbf_mrk             => [ 1 , 0 ],
    rednamn_mrk         => [ 1 , 0 ],
    sp_coadress         => [ 35, 0 ],
    sp_foadress         => [ 35, 0 ],
    sp_gatuadress       => [ 35, 0 ],
    sp_postnr           => [ 5 , 0 ],
    sp_postort          => [ 27, 0 ],
    utl_landkod         => [ 4 , 0 ],
    utl_postkod         => [ 9 , 0 ],
    utl_postort         => [ 27, 0 ],
    utl_land            => [ 35, 0 ],
    mnamn               => [ 40, 0 ],
    enamn               => [ 60, 0 ],
    fnamn               => [ 80, 0 ],
    fbf_coadress        => [ 35, 0 ],
    fbf_foadress        => [ 35, 0 ],
    fbf_gatuadress      => [ 35, 0 ],
    fbf_postnr          => [ 5 , 0 ],
    fbf_postort         => [ 27, 0 ],
    lkf                 => [ 6 , 0 ],
    afbrel_mrk          => [ 1 , 0 ],
    rel_pnr             => [ 12, 1 ],
    civst               => [ 1 , 0 ],
    civst_datum         => [ 10, 0 ],
    sep_datum           => [ 10, 0 ],
    berak_civst         => [ 1 , 0 ],
    medb                => [ 1 , 0 ],
    medb_datum          => [ 10, 0 ],
    inut                => [ 1 , 0 ],
    inut_datum          => [ 10, 0 ],
    status              => [ 1 , 0 ],
    flytt_flag          => [ 1 , 0 ],
    traffkod            => [ 2 , 0 ],
    handl               => [ 8 , 0 ],
    test                => [ 1 , 0 ],
    uppdat_tid          => [ 26, 0 ],
    namn_flag           => [ 1 , 0 ],
    fadr_flag           => [ 1 , 0 ],
    sadr_flag           => [ 1 , 0 ],
    eff_n_a_nytt_datum  => [ 10, 0 ],
    sparrtyp            => [ 2 , 0 ],
    aktf_datum          => [ 10, 0 ],
    bosk_datum          => [ 10, 0 ],
    omyn                => [ 1 , 0 ],
    omyn_datum          => [ 10, 0 ],
    rel_pnr_flag        => [ 1 , 0 ],
    civst_flag          => [ 1 , 0 ],
    inut_flag           => [ 1 , 0 ],
    sparrtyp_flag       => [ 1 , 0 ],
    aktf_flag           => [ 1 , 0 ],
    bosk_flag           => [ 1 , 0 ],
    omyn_flag           => [ 1 , 0 ],
    aktf_kod            => [ 1 , 0 ],
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