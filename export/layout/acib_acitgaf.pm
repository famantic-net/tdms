package acib_acitgaf;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITGAF";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitgaf = (
    gaf_org_num     => [ 11, 1,  0 ],
    gaf_namn1       => [ 36, 0,  1 ],
    gaf_namn2       => [ 36, 0,  2 ],
    gaf_iadr        => [ 28, 0,  3 ],
    gaf_ipost_num   => [ 5 , 1,  4 ],
    gaf_iport       => [ 25, 0,  5 ],
    gaf_rikt_num    => [ 4 , 1,  6 ],
    gaf_abon_num    => [ 8 , 1,  7 ],
    gaf_namn_dat    => [ 8 , 1,  8 ],
    gaf_iadr_dat    => [ 8 , 1,  9 ],
    gaf_gamorg_num  => [ 11, 1, 10 ],
    gaf_dat         => [ 8 , 1, 11 ],
    gaf_tid         => [ 6 , 1, 12 ],
    gaf_ny_sig      => [ 4 , 0, 13 ],
    gaf_up_sig      => [ 4 , 0, 14 ],
    gaf_namn1_nrm   => [ 15, 0, 15 ],
    gaf_lagbol_mrk  => [ 1 , 0, 16 ],
    gaf_lagbol_dat  => [ 8 , 1, 17 ],
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