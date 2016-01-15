package acib_acitarn;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITARN";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitarn = (
    arn_arbnr_num       => [ 8 , 1,  0 ],
    arn_dunsnr_num      => [ 11, 1,  1 ],
    arn_org_num         => [ 11, 1,  2 ],
    arn_hkfil_kod       => [ 1 , 0,  3 ],
    arn_tidorg_num      => [ 11, 1,  4 ],
    arn_spaerr_kod      => [ 1 , 0,  5 ],
    arn_spaerr_dat      => [ 8 , 1,  6 ],
    arn_namn            => [ 36, 0,  7 ],
    arn_badr            => [ 28, 0,  8 ],
    arn_bpost_num       => [ 5 , 1,  9 ],
    arn_bport           => [ 25, 0, 10 ],
    arn_padr            => [ 28, 0, 11 ],
    arn_ppost_num       => [ 5 , 1, 12 ],
    arn_pport           => [ 25, 0, 13 ],
    arn_rikt_num        => [ 4 , 1, 14 ],
    arn_abon_num        => [ 8 , 1, 15 ],
    arn_faxrikt_num     => [ 4 , 1, 16 ],
    arn_faxabon_num     => [ 8 , 1, 17 ],
    arn_sksanst_kod     => [ 2 , 0, 18 ],
    arn_updbadr_kod     => [ 3 , 0, 19 ],
    arn_updbadr_dat     => [ 8 , 1, 20 ],
    arn_updpadr_kod     => [ 3 , 0, 21 ],
    arn_updpadr_dat     => [ 8 , 1, 22 ],
    arn_updtel_kod      => [ 3 , 0, 23 ],
    arn_updtel_dat      => [ 8 , 1, 24 ],
    arn_updfax_kod      => [ 3 , 0, 25 ],
    arn_updfax_dat      => [ 8 , 1, 26 ],
    arn_updoevr_kod     => [ 3 , 0, 27 ],
    arn_updoevr_dat     => [ 8 , 1, 28 ],
    arn_dat             => [ 8 , 1, 29 ],
    arn_tid             => [ 6 , 1, 30 ],
    arn_ny_sig          => [ 4 , 0, 31 ],
    arn_up_sig          => [ 4 , 0, 32 ],
    arn_scb_typ         => [ 1 , 0, 33 ],
    arn_astat           => [ 1 , 0, 34 ],
    arn_astat_start     => [ 8 , 1, 35 ],
    arn_astat_slut      => [ 8 , 1, 36 ],
    arn_stkl            => [ 2 , 0, 37 ],
    arn_reklam          => [ 1 , 0, 38 ],
    arn_lankomm         => [ 4 , 0, 39 ],
    arn_a_region        => [ 2 , 0, 40 ],
    arn_lka_dat         => [ 8 , 1, 41 ],
    arn_co_adress       => [ 50, 0, 42 ],
    arn_co_adr_kod      => [ 3 , 0, 43 ],
    arn_co_adr_upddat   => [ 8 , 1, 44 ],
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