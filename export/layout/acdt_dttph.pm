package acdt_dttph;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACDT.DTTPH";

# Indicates field length and if sign should be applied
our %acdt_dttph = (
    org_num            => [ 11, 1 ],
    dobnr_num          => [ 11, 1 ],
    arman              => [ 6 , 1 ],
    paydex             => [ 4 , 1 ],
    pdxall             => [ 4 , 1 ],
    pdxline            => [ 4 , 1 ],
    nrsupp             => [ 6 , 1 ],
    nrinv              => [ 6 , 1 ],
    total              => [ 12, 1 ],
    date_berakning     => [ 10, 0 ],
    delay              => [ 4 , 1 ],
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