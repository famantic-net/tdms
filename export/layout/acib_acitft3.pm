package acib_acitft3;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITFT3";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitft3 = (
    ft3_org_num        => [ 11, 1, 0 ],
    ft3_fstatus_kod    => [ 1 , 0, 1 ],
    ft3_from_dat       => [ 8 , 1, 2 ],
    ft3_start_dat      => [ 8 , 1, 3 ],
    ft3_slut_dat       => [ 8 , 1, 4 ],
    ft3_trans_dat      => [ 26, 0, 5 ],
    ft3_sektor_kod     => [ 3 , 0, 6 ],
    ft3_sektor_dat     => [ 8 , 1, 7 ],
    ft3_sekt2014_kod   => [ 6 , 0, 8 ],
    ft3_sekt2014_dat   => [ 8 , 1, 9 ],
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