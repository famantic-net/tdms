package acba_rathist;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACBA.RATHIST";

# Indicates field length and if sign should be applied
our %acba_rathist = (
    orgnr    => [ 11, 1 ],
    ratkod   => [ 8 , 0 ],
    rattext  => [ 8 , 0 ],
    rappdat  => [ 10, 0 ],
    rappkod  => [ 8 , 0 ],
    LIMIT    => [ 8 , 0 ],
    limbel   => [ 9 , 1 ],
    limproc  => [ 3 , 1 ],
    alder    => [ 8 , 0 ],
    agare    => [ 8 , 0 ],
    ekonomi  => [ 8 , 0 ],
    bethist  => [ 8 , 0 ],
    akttext  => [ 8 , 0 ],
    aktorgnr => [ 11, 1 ],
    ftgtyp   => [ 2 , 0 ],
    snikod   => [ 7 , 0 ],
    lan      => [ 2 , 0 ],
    kommun   => [ 4 , 0 ],
    slutper  => [ 6 , 1 ],
    ratdat   => [ 26, 0 ],
    trdat    => [ 26, 0 ],
    status   => [ 1 , 0 ],
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