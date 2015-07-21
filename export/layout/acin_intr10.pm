package acin_intr10;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIN.INTR10";

# Indicates field length and if sign should be applied
our %acin_intr10 = (
    orgnr       => [ 11, 1 ],
    status      => [ 1 , 0 ],
    ejbeh       => [ 10, 0 ],
    ejfull      => [ 10, 0 ],
    vdsakn      => [ 10, 0 ],
    santl       => [ 3 , 1 ],
    santh       => [ 3 , 1 ],
    lantl       => [ 3 , 1 ],
    lanth       => [ 3 , 1 ],
    jurdatb     => [ 10, 0 ],
    offdatb     => [ 10, 0 ],
    handl       => [ 8 , 0 ],
    santv       => [ 3 , 1 ],
    lantv       => [ 3 , 1 ],
    jurdats     => [ 10, 0 ],
    offdats     => [ 10, 0 ],
    jurdatf     => [ 10, 0 ],
    offdatf     => [ 10, 0 ],
    trdat       => [ 26, 0 ],
    uppldat     => [ 26, 0 ],
    antdel      => [ 3 , 1 ],
    antfdel     => [ 3 , 1 ],
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