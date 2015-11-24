package Rating;
# Collects all swedish companies of type aktiebolag

use strict;

our %Rating = ( statement => qq(
    SELECT * FROM acba_rating
        WHERE rattext='#rattext#'
        ORDER BY random()
        LIMIT #size#
));

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
    # To find the column that contains the key
    my $field_num = sub {
        my $field = shift;
        #print "Field     : $field\n";
        for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            return $i if $sth->{NAME}->[$i] eq $field; 
        }
    };
    my %rated_business;
    for my $row (@rating_set) {
        $rated_business{$$row[&{$field_num}("orgnr")]}++;
    }
    my @acitftg_set;
    for my $orgnum ( keys %rated_business ) {
        $statement = "SELECT * FROM acib_acitftg WHERE ftg_org_num='$orgnum'";
        $sth = eval { $dbh->prepare( $statement ) };
        $sth->execute;
        push @acitftg_set, @{ $sth->fetchall_arrayref };
    }
    return \@acitftg_set;
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
