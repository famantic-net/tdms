package acib_acitft2;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITFT2";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitft2 = (
    ft2_org_num           => [ 11, 1,  0 ],
    ft2_bolmark1          => [ 6 , 0,  1 ],
    ft2_bolmark2          => [ 6 , 0,  2 ],
    ft2_bolmark3          => [ 6 , 0,  3 ],
    ft2_bolmark4          => [ 6 , 0,  4 ],
    ft2_bolmark5          => [ 6 , 0,  5 ],
    ft2_bolmark6          => [ 6 , 0,  6 ],
    ft2_tillstyp1         => [ 5 , 0,  7 ],
    ft2_tillsdat1         => [ 8 , 1,  8 ],
    ft2_tillsaterk1       => [ 8 , 1,  9 ],
    ft2_tillstyp2         => [ 5 , 0, 10 ],
    ft2_tillsdat2         => [ 8 , 1, 11 ],
    ft2_tillsaterk2       => [ 8 , 1, 12 ],
    ft2_tillstyp3         => [ 5 , 0, 13 ],
    ft2_tillsdat3         => [ 8 , 1, 14 ],
    ft2_tillsaterk3       => [ 8 , 1, 15 ],
    ft2_upd_kod           => [ 3 , 0, 16 ],
    ft2_upd_dat           => [ 8 , 1, 17 ],
    ft2_trans_dat         => [ 26, 0, 18 ],
    ft2_presnamn          => [ 60, 0, 19 ],
    ft2_co_adress         => [ 50, 0, 20 ],
    ft2_co_adr_kod        => [ 3 , 0, 21 ],
    ft2_co_adr_upddat     => [ 8 , 1, 22 ],
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