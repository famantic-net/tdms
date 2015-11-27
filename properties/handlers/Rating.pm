package Rating;
# Collects all swedish businesses of type 

use strict;

our @ISA = qw(Property);

our %Rating = (
            statement => q(
                SELECT * FROM acba_rating
                    WHERE rattext='#rattext#'
                    ORDER BY random()
                    LIMIT #size#
            )
);

our @rattext = qw(A AA AAA B C NYTT EJ);

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
    my @rating_set;
    my $sth;
    for my $rattext (@rattext) {
        $statement =~ s/#rattext#/$rattext/;
        $sth = eval { $dbh->prepare( $statement ) };
        $sth->execute;
        push @rating_set, @{ $sth->fetchall_arrayref };
        $statement =~ s/'$rattext'/'#rattext#'/;
    }
    my %business;
    for my $row (@rating_set) {
        $business{$$row[$self->_field_num($sth, "orgnr")]}++;
    }
    return $self->_get_ftg($dbh, \%business);
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
