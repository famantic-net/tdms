package acra_ratssa;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACRA.RATSSA";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acra_ratssa = (
    orgnr12            => [ 12, 1,  0 ],
    orgnr              => [ 11, 1,  1 ],
    saldo_a            => [ 11, 1,  2 ],
    antal_a            => [ 9 , 1,  3 ],
    saldo_e            => [ 11, 1,  4 ],
    antal_e            => [ 9 , 1,  5 ],
    rattn_datum        => [ 10, 0,  6 ],
    antal_kurslosa     => [ 4 , 1,  7 ],
    fil_datum          => [ 10, 0,  8 ],
    arvecka            => [ 9 , 1,  9 ],
    uppldat            => [ 26, 0, 10 ],
    handl_8            => [ 8 , 0, 11 ],
    handl_datum        => [ 26, 0, 12 ],
    sparr              => [ 1 , 0, 13 ],
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