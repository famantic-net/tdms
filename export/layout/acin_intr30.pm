package acin_intr30;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACIN.INTR30";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acin_intr30 = (
    orgnr   => [ 11, 1, 0 ],
    lnr     => [ 3 , 1, 1 ],
    status  => [ 1 , 0, 2 ],
    trdat   => [ 26, 0, 3 ],
    text    => [ 70, 0, 4 ],
    handl   => [ 8 , 0, 5 ],
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