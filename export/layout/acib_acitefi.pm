package acib_acitefi;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITEFI";

# Indicates field length and if sign should be applied
our %acib_acitefi = (
    efi_org_num         => [ 11, 1 ],
    efi_lop_num         => [ 5 , 1 ],
    efi_ireg_dat        => [ 8 , 1 ],
    efi_iregnamn        => [ 48, 0 ],
    efi_firma_reg_dat   => [ 8 , 1 ],
    efi_namn1           => [ 36, 0 ],
    efi_namn2           => [ 36, 0 ],
    efi_iadr            => [ 32, 0 ],
    efi_coadr           => [ 50, 0 ],
    efi_iadr_dat        => [ 8 , 1 ],
    efi_ipost_num       => [ 5 , 1 ],
    efi_iport           => [ 32, 0 ],
    efi_kommun          => [ 2 , 1 ],
    efi_lan             => [ 2 , 1 ],
    efi_av_kod          => [ 2 , 1 ],
    efi_avreg_dat       => [ 8 , 1 ],
    efi_upd_dat         => [ 8 , 1 ],
    efi_fg_namn_dat     => [ 8 , 1 ],
    efi_fg_namn1        => [ 36, 0 ],
    efi_fg_namn2        => [ 36, 0 ],
    efi_dinr            => [ 7 , 1 ],
    efi_dinrar          => [ 4 , 1 ],
    efi_trans_dat       => [ 8 , 1 ],
    efi_verks1          => [ 70, 0 ],
    efi_verks2          => [ 70, 0 ],
    efi_verks3          => [ 70, 0 ],
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