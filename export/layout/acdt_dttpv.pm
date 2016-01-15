package acdt_dttpv;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACDT.DTTPV";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acdt_dttpv = (
    org_num         => [ 11, 1,  0 ],
    dobnr_num       => [ 11, 1,  1 ],
    arvecka         => [ 6 , 1,  2 ],
    paydex          => [ 4 , 1,  3 ],
    pdxall          => [ 4 , 1,  4 ],
    pdxline         => [ 4 , 1,  5 ],
    nrsupp          => [ 6 , 1,  6 ],
    nrinv           => [ 6 , 1,  7 ],
    total           => [ 12, 1,  8 ],
    date_berakning  => [ 10, 0,  9 ],
    delay           => [ 4 , 1, 10 ],
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