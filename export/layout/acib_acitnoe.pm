package acib_acitnoe;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITNOE";

# Indicates field length and if sign should be applied
    our %acib_acitnoe = (
    noe_enhnr_num   => [ 8, 1 ],
    noe_sni_kod     => [ 7, 0 ],
    noe_huvsni_mrk  => [ 1, 0 ],
    noe_upd_kod     => [ 3, 0 ],
    noe_upd_dat     => [ 8, 1 ],
    noe_dat         => [ 8, 1 ],
    noe_tid         => [ 6, 1 ],
    noe_ny_sig      => [ 4, 0 ],
    noe_up_sig      => [ 4, 0 ],
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