package AB;
# Collects all swedish companies of type aktiebolag

use strict;

our %AB = ( statement => qq(
    SELECT * FROM acib_acitftg
        WHERE ftg_iklass_kod LIKE '%49'
        ORDER BY random()
        LIMIT #size#
));


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
    my $sth = eval { $dbh->prepare( $statement ) };
    $sth->execute;
    return $sth->fetchall_arrayref;
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
