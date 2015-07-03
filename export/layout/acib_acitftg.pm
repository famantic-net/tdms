package acib_acitftg;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITFTG";

# Indicates field length and if sign should be applied
our %acib_acitftg = (
    ftg_org_num        => [ 11, 1 ],
    ftg_namn1          => [ 36, 0 ],
    ftg_namn2          => [ 36, 0 ],
    ftg_iadr           => [ 28, 0 ],
    ftg_ipost_num      => [ 5 , 1 ],
    ftg_iport          => [ 25, 0 ],
    ftg_land_kod       => [ 2 , 0 ],
    ftg_rikt_num       => [ 4 , 1 ],
    ftg_abon_num       => [ 8 , 1 ],
    ftg_upd_kod        => [ 3 , 0 ],
    ftg_upd_dat        => [ 8 , 1 ],
    ftg_updiadr_kod    => [ 3 , 0 ],
    ftg_updiadr_dat    => [ 8 , 1 ],
    ftg_updtel_kod     => [ 3 , 0 ],
    ftg_updtel_dat     => [ 8 , 1 ],
    ftg_start_dat      => [ 8 , 1 ],
    ftg_popnamn        => [ 36, 0 ],
    ftg_uppl_dat       => [ 8 , 1 ],
    ftg_iregnamn       => [ 48, 0 ],
    ftg_ireg_dat       => [ 8 , 1 ],
    ftg_aktaktkap_bel  => [ 13, 1 ],
    ftg_enh_ant        => [ 4 , 1 ],
    ftg_verklaen_kod   => [ 2 , 0 ],
    ftg_saetkom_kod    => [ 4 , 0 ],
    ftg_nyorg_num      => [ 11, 1 ],
    ftg_spaerr_kod     => [ 1 , 0 ],
    ftg_spaerr_dat     => [ 8 , 1 ],
    ftg_sks_kod        => [ 2 , 0 ],
    ftg_istatus_kod    => [ 1 , 0 ],
    ftg_istatus_dat    => [ 8 , 1 ],
    ftg_jstatus_kod    => [ 1 , 0 ],
    ftg_jstatus_dat    => [ 8 , 1 ],
    ftg_fstatus_kod    => [ 1 , 0 ],
    ftg_fstatus_dat    => [ 8 , 1 ],
    ftg_slut_typ       => [ 1 , 0 ],
    ftg_akt1_kod       => [ 4 , 0 ],
    ftg_akt1_dat       => [ 8 , 1 ],
    ftg_akt2_kod       => [ 4 , 0 ],
    ftg_akt2_dat       => [ 8 , 1 ],
    ftg_iklass_kod     => [ 5 , 0 ],
    ftg_updoevr_kod    => [ 3 , 0 ],
    ftg_updoevr_dat    => [ 8 , 1 ],
    ftg_an_mrk         => [ 1 , 0 ],
    ftg_dat            => [ 8 , 1 ],
    ftg_tid            => [ 6 , 1 ],
    ftg_ny_sig         => [ 4 , 0 ],
    ftg_up_sig         => [ 4 , 0 ],
    ftg_totarb_ant     => [ 4 , 1 ],
    ftg_aktarb_ant     => [ 4 , 1 ],
    ftg_namn1_nrm      => [ 15, 0 ],
    ftg_slut_per       => [ 6 , 1 ],
    ftg_lagbol_mrk     => [ 1 , 0 ],
    ftg_fskatt_kod     => [ 1 , 0 ],
    ftg_fskatt_dat     => [ 8 , 1 ],
    ftg_publik_mrk     => [ 1 , 0 ],
    ftg_status_kod     => [ 1 , 0 ],
    ftg_status_dat     => [ 8 , 1 ],
    ftg_bok_per        => [ 6 , 1 ],
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