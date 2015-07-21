package acxx_bnycktal;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACXX.BNYCKTAL";

# Indicates field length and if sign should be applied
our %acxx_bnycktal = (
    snikod          => [ 5 , 0 ],
    stlkod          => [ 2 , 0 ],
    medikod         => [ 1 , 0 ],
    berek_ant       => [ 7 , 1 ],
    berek           => [ 11, 1 ],
    totsk_ant       => [ 7 , 1 ],
    totsk           => [ 11, 1 ],
    totkap_ant      => [ 7 , 1 ],
    totkap          => [ 11, 1 ],
    aegkap_ant      => [ 7 , 1 ],
    aegkap          => [ 7 , 1 ],
    atotkap_ant     => [ 7 , 1 ],
    atotkap         => [ 7 , 1 ],
    skuldrta_ant    => [ 7 , 1 ],
    skuldrta        => [ 7 , 1 ],
    riskb_ant       => [ 7 , 1 ],
    riskb           => [ 7 , 1 ],
    skuldgr_ant     => [ 7 , 1 ],
    skuldgr         => [ 7 , 1 ],
    rroms_ant       => [ 7 , 1 ],
    rroms           => [ 7 , 1 ],
    vproc_ant       => [ 7 , 1 ],
    vproc           => [ 7 , 1 ],
    nres_ant        => [ 7 , 1 ],
    nres            => [ 7 , 1 ],
    rtagrad_ant     => [ 7 , 1 ],
    rtagrad         => [ 7 , 1 ],
    arbkoms_ant     => [ 7 , 1 ],
    arbkoms         => [ 7 , 1 ],
    rfinko_ant      => [ 7 , 1 ],
    rfinko          => [ 11, 1 ],
    rbokdisp_ant    => [ 7 , 1 ],
    rbokdisp        => [ 11, 1 ],
    kapomsh_ant     => [ 7 , 1 ],
    kapomsh         => [ 7 , 1 ],
    omspanst_ant    => [ 7 , 1 ],
    omspanst        => [ 11, 1 ],
    ctotsk_ant      => [ 7 , 1 ],
    ctotsk          => [ 7 , 1 ],
    cfinko_ant      => [ 7 , 1 ],
    cfinko          => [ 7 , 1 ],
    rrkapoms_ant    => [ 7 , 1 ],
    rrkapoms        => [ 7 , 1 ],
    likvmoms_ant    => [ 7 , 1 ],
    likvmoms        => [ 7 , 1 ],
    kundfoms_ant    => [ 7 , 1 ],
    kundfoms        => [ 7 , 1 ],
    varuloms_ant    => [ 7 , 1 ],
    varuloms        => [ 7 , 1 ],
    kofskoms_ant    => [ 7 , 1 ],
    kofskoms        => [ 7 , 1 ],
    kassa_ant       => [ 7 , 1 ],
    kassa           => [ 7 , 1 ],
    balans_ant      => [ 7 , 1 ],
    balans          => [ 7 , 1 ],
    sol_ant         => [ 7 , 1 ],
    sol             => [ 7 , 1 ],
    konsgrad_ant    => [ 7 , 1 ],
    konsgrad        => [ 7 , 1 ],
    panttisk_ant    => [ 7 , 1 ],
    panttisk        => [ 7 , 1 ],
    foeroms_ant     => [ 7 , 1 ],
    foeroms         => [ 7 , 1 ],
    foertotk_ant    => [ 7 , 1 ],
    foertotk        => [ 7 , 1 ],
    foerek_ant      => [ 7 , 1 ],
    foerek          => [ 7 , 1 ],
    avproc_ant      => [ 7 , 1 ],
    avproc          => [ 7 , 1 ],
    anstant_ant     => [ 7 , 1 ],
    anstant         => [ 11, 1 ],
    oms_ant         => [ 7 , 1 ],
    oms             => [ 11, 1 ],
    rreseav_ant     => [ 7 , 1 ],
    rreseav         => [ 11, 1 ],
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