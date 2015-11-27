package Anstallda;
# Collects all swedish businesses of type 

use strict;

our @ISA = qw(Property);

our %Anstallda = (
            statement => q(
                SELECT * FROM acib_acitftg
                        WHERE (ftg_sks_kod='#sks#')
                        ORDER BY random()
                        LIMIT #size#
            )
);

our @intervals = qw(zero onedigit many);
# SKS codes, number of emlpoyees
our @zero = qw(00);
our @onedigit = qw(01 02); # 1 - 9
our @many = ("03".."08", 18, 28, 38, 48, 58, 58, 78); # 10 - >10000

sub new() {
    my $self = shift->_classobj();
    return bless $self;
}



sub collect_data {
    my $self = shift;
    my $dbargs = shift;
    my $statement = $self->statement;
    my $dbh = $dbargs->dbh;
    my $init_size = $dbargs->init_size;
    $statement =~ s/#size#/$init_size/;
    my @interval_set;
    my $sth;
    my $sub_condition;
    if ($statement =~ m/\((ftg_sks_kod[^#]+#sks#[^)]+)\)/) {
        $sub_condition = $1;
    }
    for my $interval (@intervals) {
        my $condition;
        no strict 'refs';
        for my $sks (@{$interval}) {
            my $cond = $sub_condition;
            $cond =~ s/#sks#/$sks/;
            $condition .= "$cond OR ";
        }
        use strict 'refs';
        $condition =~ s/ OR $//;
        my $full_statement = $statement;
        $full_statement =~ s/$sub_condition/$condition/;
        #print $full_statement;
        $sth = eval { $dbh->prepare( $full_statement ) };
        $sth->execute;
        push @interval_set, @{ $sth->fetchall_arrayref };
    }
    return \@interval_set;
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
