package acib_acitkcn;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITKCN";

# Indicates field length and if sign should be applied
our %acib_acitkcn = (
    kcn_id_num        => [ 11, 1 ],
    kcn_loep_num      => [ 9 , 1 ],
    kcn_nivaa         => [ 2 , 1 ],
    kcn_modr_num      => [ 11, 1 ],
    kcn_dottr_num     => [ 11, 1 ],
    kcn_aegdproc_bel  => [ 5 , 1 ],
    kcn_upd_kod       => [ 3 , 0 ],
    kcn_upd_dat       => [ 8 , 1 ],
    kcn_dat           => [ 8 , 1 ],
    kcn_tid           => [ 6 , 1 ],
    kcn_ny_sig        => [ 4 , 0 ],
    kcn_up_sig        => [ 4 , 0 ],
    kcn_updat         => [ 8 , 1 ],
    kcn_landkod       => [ 2 , 0 ],
    kcn_dobnr         => [ 11, 1 ],
    kcn_namn          => [ 32, 0 ],
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