package acib_acitarn;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITARN";

# Indicates field length and if sign should be applied
our %acib_acitarn = (
    arn_arbnr_num       => [ 8 , 1 ],
    arn_dunsnr_num      => [ 11, 1 ],
    arn_org_num         => [ 11, 1 ],
    arn_hkfil_kod       => [ 1 , 0 ],
    arn_tidorg_num      => [ 11, 1 ],
    arn_spaerr_kod      => [ 1 , 0 ],
    arn_spaerr_dat      => [ 8 , 1 ],
    arn_namn            => [ 36, 0 ],
    arn_badr            => [ 28, 0 ],
    arn_bpost_num       => [ 5 , 1 ],
    arn_bport           => [ 25, 0 ],
    arn_padr            => [ 28, 0 ],
    arn_ppost_num       => [ 5 , 1 ],
    arn_pport           => [ 25, 0 ],
    arn_rikt_num        => [ 4 , 1 ],
    arn_abon_num        => [ 8 , 1 ],
    arn_faxrikt_num     => [ 4 , 1 ],
    arn_faxabon_num     => [ 8 , 1 ],
    arn_sksanst_kod     => [ 2 , 0 ],
    arn_updbadr_kod     => [ 3 , 0 ],
    arn_updbadr_dat     => [ 8 , 1 ],
    arn_updpadr_kod     => [ 3 , 0 ],
    arn_updpadr_dat     => [ 8 , 1 ],
    arn_updtel_kod      => [ 3 , 0 ],
    arn_updtel_dat      => [ 8 , 1 ],
    arn_updfax_kod      => [ 3 , 0 ],
    arn_updfax_dat      => [ 8 , 1 ],
    arn_updoevr_kod     => [ 3 , 0 ],
    arn_updoevr_dat     => [ 8 , 1 ],
    arn_dat             => [ 8 , 1 ],
    arn_tid             => [ 6 , 1 ],
    arn_ny_sig          => [ 4 , 0 ],
    arn_up_sig          => [ 4 , 0 ],
    arn_scb_typ         => [ 1 , 0 ],
    arn_astat           => [ 1 , 0 ],
    arn_astat_start     => [ 8 , 1 ],
    arn_astat_slut      => [ 8 , 1 ],
    arn_stkl            => [ 2 , 0 ],
    arn_reklam          => [ 1 , 0 ],
    arn_lankomm         => [ 4 , 0 ],
    arn_a_region        => [ 2 , 0 ],
    arn_lka_dat         => [ 8 , 1 ],
    arn_co_adress       => [ 50, 0 ],
    arn_co_adr_kod      => [ 3 , 0 ],
    arn_co_adr_upddat   => [ 8 , 1 ],
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