package acib_acitbif;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITBIF";

# Indicates field length and if sign should be applied
our %acib_acitbif = (
    bif_org_num        => [ 11, 1 ],
    bif_lop_num        => [ 5 , 1 ],
    bif_biflop_num     => [ 5 , 1 ],
    bif_namn_typ       => [ 2 , 0 ],
    bif_iregnamn       => [ 48, 0 ],
    bif_namn1          => [ 36, 0 ],
    bif_namn2          => [ 36, 0 ],
    bif_namn_reg_dat   => [ 8 , 1 ],
    bif_beslstamma     => [ 1 , 0 ],
    bif_beslstadg      => [ 1 , 0 ],
    bif_dinr           => [ 7 , 1 ],
    bif_dinrar         => [ 4 , 1 ],
    bif_upd_kod        => [ 3 , 0 ],
    bif_upd_dat        => [ 8 , 1 ],
    bif_trans_dat      => [ 26, 0 ],
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