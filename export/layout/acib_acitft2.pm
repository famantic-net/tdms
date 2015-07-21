package acib_acitft2;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITFT2";

# Indicates field length and if sign should be applied
our %acib_acitft2 = (
    ft2_org_num           => [ 11, 1 ],
    ft2_bolmark1          => [ 6 , 0 ],
    ft2_bolmark2          => [ 6 , 0 ],
    ft2_bolmark3          => [ 6 , 0 ],
    ft2_bolmark4          => [ 6 , 0 ],
    ft2_bolmark5          => [ 6 , 0 ],
    ft2_bolmark6          => [ 6 , 0 ],
    ft2_tillstyp1         => [ 5 , 0 ],
    ft2_tillsdat1         => [ 8 , 1 ],
    ft2_tillsaterk1       => [ 8 , 1 ],
    ft2_tillstyp2         => [ 5 , 0 ],
    ft2_tillsdat2         => [ 8 , 1 ],
    ft2_tillsaterk2       => [ 8 , 1 ],
    ft2_tillstyp3         => [ 5 , 0 ],
    ft2_tillsdat3         => [ 8 , 1 ],
    ft2_tillsaterk3       => [ 8 , 1 ],
    ft2_upd_kod           => [ 3 , 0 ],
    ft2_upd_dat           => [ 8 , 1 ],
    ft2_trans_dat         => [ 26, 0 ],
    ft2_presnamn          => [ 60, 0 ],
    ft2_co_adress         => [ 50, 0 ],
    ft2_co_adr_kod        => [ 3 , 0 ],
    ft2_co_adr_upddat     => [ 8 , 1 ],
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