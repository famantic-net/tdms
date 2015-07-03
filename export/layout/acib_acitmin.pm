package acib_acitmin;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITMIN";

# Indicates field length and if sign should be applied
our %acib_acitmin = (
    min_id_num         => [ 11, 1 ],
    min_loep_num       => [ 9 , 1 ],
    min_nivaa          => [ 2 , 1 ],
    min_modr_num       => [ 11, 1 ],
    min_dottr_num      => [ 11, 1 ],
    min_aegdproc_bel   => [ 5 , 1 ],
    min_upd_kod        => [ 3 , 0 ],
    min_upd_dat        => [ 8 , 1 ],
    min_dat            => [ 8 , 1 ],
    min_tid            => [ 6 , 1 ],
    min_ny_sig         => [ 4 , 0 ],
    min_up_sig         => [ 4 , 0 ],
    min_uppdat         => [ 8 , 1 ],
    min_landkod        => [ 2 , 0 ],
    min_dobnr          => [ 11, 1 ],
    min_namn           => [ 32, 0 ],
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