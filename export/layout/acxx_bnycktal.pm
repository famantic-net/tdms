package acxx_bnycktal;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACXX.BNYCKTAL";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acxx_bnycktal = (
    snikod          => [ 5 , 0,  0 ],
    stlkod          => [ 2 , 0,  1 ],
    medikod         => [ 1 , 0,  2 ],
    berek_ant       => [ 7 , 1,  3 ],
    berek           => [ 11, 1,  4 ],
    totsk_ant       => [ 7 , 1,  5 ],
    totsk           => [ 11, 1,  6 ],
    totkap_ant      => [ 7 , 1,  7 ],
    totkap          => [ 11, 1,  8 ],
    aegkap_ant      => [ 7 , 1,  9 ],
    aegkap          => [ 7 , 1, 10 ],
    atotkap_ant     => [ 7 , 1, 11 ],
    atotkap         => [ 7 , 1, 12 ],
    skuldrta_ant    => [ 7 , 1, 13 ],
    skuldrta        => [ 7 , 1, 14 ],
    riskb_ant       => [ 7 , 1, 15 ],
    riskb           => [ 7 , 1, 16 ],
    skuldgr_ant     => [ 7 , 1, 17 ],
    skuldgr         => [ 7 , 1, 18 ],
    rroms_ant       => [ 7 , 1, 19 ],
    rroms           => [ 7 , 1, 20 ],
    vproc_ant       => [ 7 , 1, 21 ],
    vproc           => [ 7 , 1, 22 ],
    nres_ant        => [ 7 , 1, 23 ],
    nres            => [ 7 , 1, 24 ],
    rtagrad_ant     => [ 7 , 1, 25 ],
    rtagrad         => [ 7 , 1, 26 ],
    arbkoms_ant     => [ 7 , 1, 27 ],
    arbkoms         => [ 7 , 1, 28 ],
    rfinko_ant      => [ 7 , 1, 29 ],
    rfinko          => [ 11, 1, 30 ],
    rbokdisp_ant    => [ 7 , 1, 31 ],
    rbokdisp        => [ 11, 1, 32 ],
    kapomsh_ant     => [ 7 , 1, 33 ],
    kapomsh         => [ 7 , 1, 34 ],
    omspanst_ant    => [ 7 , 1, 35 ],
    omspanst        => [ 11, 1, 36 ],
    ctotsk_ant      => [ 7 , 1, 37 ],
    ctotsk          => [ 7 , 1, 38 ],
    cfinko_ant      => [ 7 , 1, 39 ],
    cfinko          => [ 7 , 1, 40 ],
    rrkapoms_ant    => [ 7 , 1, 41 ],
    rrkapoms        => [ 7 , 1, 42 ],
    likvmoms_ant    => [ 7 , 1, 43 ],
    likvmoms        => [ 7 , 1, 44 ],
    kundfoms_ant    => [ 7 , 1, 45 ],
    kundfoms        => [ 7 , 1, 46 ],
    varuloms_ant    => [ 7 , 1, 47 ],
    varuloms        => [ 7 , 1, 48 ],
    kofskoms_ant    => [ 7 , 1, 49 ],
    kofskoms        => [ 7 , 1, 50 ],
    kassa_ant       => [ 7 , 1, 51 ],
    kassa           => [ 7 , 1, 52 ],
    balans_ant      => [ 7 , 1, 53 ],
    balans          => [ 7 , 1, 54 ],
    sol_ant         => [ 7 , 1, 55 ],
    sol             => [ 7 , 1, 56 ],
    konsgrad_ant    => [ 7 , 1, 57 ],
    konsgrad        => [ 7 , 1, 58 ],
    panttisk_ant    => [ 7 , 1, 59 ],
    panttisk        => [ 7 , 1, 60 ],
    foeroms_ant     => [ 7 , 1, 61 ],
    foeroms         => [ 7 , 1, 62 ],
    foertotk_ant    => [ 7 , 1, 63 ],
    foertotk        => [ 7 , 1, 64 ],
    foerek_ant      => [ 7 , 1, 65 ],
    foerek          => [ 7 , 1, 66 ],
    avproc_ant      => [ 7 , 1, 67 ],
    avproc          => [ 7 , 1, 68 ],
    anstant_ant     => [ 7 , 1, 69 ],
    anstant         => [ 11, 1, 70 ],
    oms_ant         => [ 7 , 1, 71 ],
    oms             => [ 11, 1, 72 ],
    rreseav_ant     => [ 7 , 1, 73 ],
    rreseav         => [ 11, 1, 74 ],
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