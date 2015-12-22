package acin_intr10;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIN.INTR10";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acin_intr10 = (
    orgnr       => [ 11, 1,  0 ],
    status      => [ 1 , 0,  1 ],
    ejbeh       => [ 10, 0,  2 ],
    ejfull      => [ 10, 0,  3 ],
    vdsakn      => [ 10, 0,  4 ],
    santl       => [ 3 , 1,  5 ],
    santh       => [ 3 , 1,  6 ],
    lantl       => [ 3 , 1,  7 ],
    lanth       => [ 3 , 1,  8 ],
    jurdatb     => [ 10, 0,  9 ],
    offdatb     => [ 10, 0, 10 ],
    handl       => [ 8 , 0, 11 ],
    santv       => [ 3 , 1, 12 ],
    lantv       => [ 3 , 1, 13 ],
    jurdats     => [ 10, 0, 14 ],
    offdats     => [ 10, 0, 15 ],
    jurdatf     => [ 10, 0, 16 ],
    offdatf     => [ 10, 0, 17 ],
    trdat       => [ 26, 0, 18 ],
    uppldat     => [ 26, 0, 19 ],
    antdel      => [ 3 , 1, 20 ],
    antfdel     => [ 3 , 1, 21 ],
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