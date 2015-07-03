package acib_acitntf;

use strict;
use feature 'unicode_strings';
use export::Testdata;

our @ISA = qw(Testdata);

our $filename = "E719.TESTDATA.ACIB.ACITNTF";

# Indicates field length and if sign should be applied
our %acib_acitntf = (
    ntf_org_num             => [ 11, 1 ],
    ntf_foretr_ant          => [ 5 , 1 ],
    ntf_betanm_ant          => [ 5 , 1 ],
    ntf_betanm_snitt        => [ 7 , 1 ],
    ntf_kkengagemang_ant    => [ 5 , 1 ],
    ntf_kkengagemang_snitt  => [ 7 , 1 ],
    ntf_upd_dat             => [ 26, 0 ],
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