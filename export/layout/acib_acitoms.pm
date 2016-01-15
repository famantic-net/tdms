package acib_acitoms;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIB.ACITOMS";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acib_acitoms = (
    oms_org_num         => [ 11, 1, 0 ],
    oms_artal           => [ 4 , 1, 1 ],
    oms_int_kod         => [ 2 , 0, 2 ],
    oms_org12_num       => [ 12, 1, 3 ],
    oms_upd_dat         => [ 26, 0, 4 ],
    oms_create_dat      => [ 26, 0, 5 ],
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