package EF;
# Collects all swedish businesses of type

use strict;

our @ISA = qw(Property);

our %EF = (
        init_statement => q(
            SELECT * FROM acib_acitftg
                    WHERE ftg_iklass_kod LIKE '%10'
                    ORDER BY random()
                    LIMIT #size#
        ),
        nf_statement => q(
            SELECT * FROM acra_rapp
                    WHERE rappkod='NF' AND (CASE WHEN status~E'^\\d+$' THEN status::integer ELSE 0 END) <= 1
                    ORDER BY random()
                    LIMIT #size#
        )
);


sub new() {
    my $self = shift->_classobj();
    return bless $self;
}


sub collect_data {
    my $self = shift;
    my $dbargs = shift;
    my $dbh = $dbargs->dbh;
    my $init_size = $dbargs->init_size;
    my $statement = $self->init_statement;
    $statement =~ s/#size#/$init_size/;
    my $sth = eval { $dbh->prepare( $statement ) };
    $sth->execute;
    my @businesses = @{ $sth->fetchall_arrayref };
    
    $statement = $self->nf_statement;
    $statement =~ s/#size#/$init_size/;
    $sth = eval { $dbh->prepare( $statement ) };
    my @with_nf;
    do {
        $sth->execute;
        my @sub_set = @{ $sth->fetchall_arrayref };
        my %business;
        for my $row (@sub_set) {
            $business{$$row[$self->_field_num($sth, "orgnr")]}++;
        }
        #print "EF: @{[ keys %business ]}\n";
        push @with_nf, @{ $self->_get_ftg($dbh, \%business) };
        # Objects in acra_rapp are often already deleted from acib_aciftg, so repeat until full set
    } until $#with_nf >= $init_size;
    push @businesses, @with_nf;
    return \@businesses;
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
