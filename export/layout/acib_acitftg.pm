package acib_acitftg;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITFTG";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitftg = (
    ftg_org_num        => [ 11, 1,  0 ],
    ftg_namn1          => [ 36, 0,  1 ],
    ftg_namn2          => [ 36, 0,  2 ],
    ftg_iadr           => [ 28, 0,  3 ],
    ftg_ipost_num      => [ 5 , 1,  4 ],
    ftg_iport          => [ 25, 0,  5 ],
    ftg_land_kod       => [ 2 , 0,  6 ],
    ftg_rikt_num       => [ 4 , 1,  7 ],
    ftg_abon_num       => [ 8 , 1,  8 ],
    ftg_upd_kod        => [ 3 , 0,  9 ],
    ftg_upd_dat        => [ 8 , 1, 10 ],
    ftg_updiadr_kod    => [ 3 , 0, 11 ],
    ftg_updiadr_dat    => [ 8 , 1, 12 ],
    ftg_updtel_kod     => [ 3 , 0, 13 ],
    ftg_updtel_dat     => [ 8 , 1, 14 ],
    ftg_start_dat      => [ 8 , 1, 15 ],
    ftg_popnamn        => [ 36, 0, 16 ],
    ftg_uppl_dat       => [ 8 , 1, 17 ],
    ftg_iregnamn       => [ 48, 0, 18 ],
    ftg_ireg_dat       => [ 8 , 1, 19 ],
    ftg_aktaktkap_bel  => [ 13, 1, 20 ],
    ftg_enh_ant        => [ 4 , 1, 21 ],
    ftg_verklaen_kod   => [ 2 , 0, 22 ],
    ftg_saetkom_kod    => [ 4 , 0, 23 ],
    ftg_nyorg_num      => [ 11, 1, 24 ],
    ftg_spaerr_kod     => [ 1 , 0, 25 ],
    ftg_spaerr_dat     => [ 8 , 1, 26 ],
    ftg_sks_kod        => [ 2 , 0, 27 ],
    ftg_istatus_kod    => [ 1 , 0, 28 ],
    ftg_istatus_dat    => [ 8 , 1, 29 ],
    ftg_jstatus_kod    => [ 1 , 0, 30 ],
    ftg_jstatus_dat    => [ 8 , 1, 31 ],
    ftg_fstatus_kod    => [ 1 , 0, 32 ],
    ftg_fstatus_dat    => [ 8 , 1, 33 ],
    ftg_slut_typ       => [ 1 , 0, 34 ],
    ftg_akt1_kod       => [ 4 , 0, 35 ],
    ftg_akt1_dat       => [ 8 , 1, 36 ],
    ftg_akt2_kod       => [ 4 , 0, 37 ],
    ftg_akt2_dat       => [ 8 , 1, 38 ],
    ftg_iklass_kod     => [ 5 , 0, 39 ],
    ftg_updoevr_kod    => [ 3 , 0, 40 ],
    ftg_updoevr_dat    => [ 8 , 1, 41 ],
    ftg_an_mrk         => [ 1 , 0, 42 ],
    ftg_dat            => [ 8 , 1, 43 ],
    ftg_tid            => [ 6 , 1, 44 ],
    ftg_ny_sig         => [ 4 , 0, 45 ],
    ftg_up_sig         => [ 4 , 0, 46 ],
    ftg_totarb_ant     => [ 4 , 1, 47 ],
    ftg_aktarb_ant     => [ 4 , 1, 48 ],
    ftg_namn1_nrm      => [ 15, 0, 49 ],
    ftg_slut_per       => [ 6 , 1, 50 ],
    ftg_lagbol_mrk     => [ 1 , 0, 51 ],
    ftg_fskatt_kod     => [ 1 , 0, 52 ],
    ftg_fskatt_dat     => [ 8 , 1, 53 ],
    ftg_publik_mrk     => [ 1 , 0, 54 ],
    ftg_status_kod     => [ 1 , 0, 55 ],
    ftg_status_dat     => [ 8 , 1, 56 ],
    ftg_bok_per        => [ 6 , 1, 57 ],
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