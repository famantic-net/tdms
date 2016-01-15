package acba_rating;

use strict;
use feature 'unicode_strings';
use export::Testdata;
use tdms_conf qw($export_prefix);

our @ISA = qw(Testdata);

our $filename = "$export_prefix.ACBA.RATING";

# Indicates field length and if sign should be applied
# Third element is for sorting
our %acba_rating = (
    orgnr    => [ 11, 1,  0 ],
    ratkod   => [ 8 , 0,  1 ],
    rattext  => [ 8 , 0,  2 ],
    rappdat  => [ 10, 0,  3 ],
    rappkod  => [ 8 , 0,  4 ],
    LIMIT    => [ 8 , 0,  5 ],
    limbel   => [ 9 , 1,  6 ],
    limproc  => [ 3 , 1,  7 ],
    alder    => [ 8 , 0,  8 ],
    agare    => [ 8 , 0,  9 ],
    ekonomi  => [ 8 , 0, 10 ],
    bethist  => [ 8 , 0, 11 ],
    akttext  => [ 8 , 0, 12 ],
    aktorgnr => [ 11, 1, 13 ],
    ftgtyp   => [ 2 , 0, 14 ],
    snikod   => [ 7 , 0, 15 ],
    lan      => [ 2 , 0, 16 ],
    kommun   => [ 4 , 0, 17 ],
    slutper  => [ 6 , 1, 18 ],
    ratdat   => [ 26, 0, 19 ],
    trdat    => [ 26, 0, 20 ],   
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