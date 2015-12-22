package acgd_empfun01;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACGD.EMPFUN01";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acgd_empfun01 = (
    dunsnr          => [ 11, 1,  0 ],
    cfarnr          => [ 8 , 1,  1 ],
    orgnr           => [ 11, 1,  2 ],
    function_code   => [ 4 , 0,  3 ],
    employee_id     => [ 10, 0,  4 ],
    b_title         => [ 25, 0,  5 ],
    firstname       => [ 40, 0,  6 ],
    lastname        => [ 40, 0,  7 ],
    gender          => [ 1 , 0,  8 ],
    company_size    => [ 4 , 0,  9 ],
    cs_unique_id    => [ 12, 0, 10 ],
    delete_ind      => [ 1 , 0, 11 ],
    update_timest   => [ 26, 0, 12 ],
    insert_timest   => [ 26, 0, 13 ],
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