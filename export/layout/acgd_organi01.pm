package acgd_organi01;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACGD.ORGANI01";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acgd_organi01 = (
    dunsnr             => [ 11, 1,  0 ],
    cfarnr             => [ 8 , 1,  1 ],
    orgnr              => [ 11, 1,  2 ],
    import_indicator   => [ 1 , 0,  3 ],
    export_indicator   => [ 1 , 0,  4 ],
    web_address        => [ 50, 0,  5 ],
    company_e_mail     => [ 80, 0,  6 ],
    company_size       => [ 4 , 0,  7 ],
    company_telenr     => [ 16, 0,  8 ],
    update_timest      => [ 26, 0,  9 ],
    insert_timest      => [ 26, 0, 10 ],
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