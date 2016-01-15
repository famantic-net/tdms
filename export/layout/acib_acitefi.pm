package acib_acitefi;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITEFI";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitefi = (
    efi_org_num         => [ 11, 1,  0 ],
    efi_lop_num         => [ 5 , 1,  1 ],
    efi_ireg_dat        => [ 8 , 1,  2 ],
    efi_iregnamn        => [ 48, 0,  3 ],
    efi_firma_reg_dat   => [ 8 , 1,  4 ],
    efi_namn1           => [ 36, 0,  5 ],
    efi_namn2           => [ 36, 0,  6 ],
    efi_iadr            => [ 32, 0,  7 ],
    efi_coadr           => [ 50, 0,  8 ],
    efi_iadr_dat        => [ 8 , 1,  9 ],
    efi_ipost_num       => [ 5 , 1, 10 ],
    efi_iport           => [ 32, 0, 11 ],
    efi_kommun          => [ 2 , 1, 12 ],
    efi_lan             => [ 2 , 1, 13 ],
    efi_av_kod          => [ 2 , 1, 14 ],
    efi_avreg_dat       => [ 8 , 1, 15 ],
    efi_upd_dat         => [ 8 , 1, 16 ],
    efi_fg_namn_dat     => [ 8 , 1, 17 ],
    efi_fg_namn1        => [ 36, 0, 18 ],
    efi_fg_namn2        => [ 36, 0, 19 ],
    efi_dinr            => [ 7 , 1, 20 ],
    efi_dinrar          => [ 4 , 1, 21 ],
    efi_trans_dat       => [ 8 , 1, 22 ],
    efi_verks1          => [ 70, 0, 23 ],
    efi_verks2          => [ 70, 0, 24 ],
    efi_verks3          => [ 70, 0, 25 ],
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