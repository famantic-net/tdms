package KB;
# Collects all swedish companies of type aktiebolag

use strict;

# Note> KB only differs from HB in field 'priokod'
our %KB = (
        substatements => {
            kb_statement => qq(
                SELECT * FROM acin_intr20
                        WHERE (priokod='60' OR priokod='68' OR priokod='70') AND ftgtyp='HB'
                        ORDER BY random()
                        LIMIT #size#
            ),
            kbab_statement => qq(
                SELECT * FROM acin_intr20
                        WHERE (priokod='60' OR priokod='68' OR priokod='70') AND ftgtyp='HB' AND ityp='AB'
                        ORDER BY random()
                        LIMIT #size#
            ),
            kbpp_statement => qq(
                SELECT * FROM acin_intr20
                        WHERE (priokod='60' OR priokod='68' OR priokod='70') AND ftgtyp='HB' AND ityp='PP'
                        ORDER BY random()
                        LIMIT #size#
            ),
        }
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
    my $sth;
    my @sub_set;
    my %substatements = %{ $self->substatements };
    for my $sub (keys %substatements) {
        my $statement = $substatements{$sub};
        $statement =~ s/#size#/$init_size/;
        $sth = eval { $dbh->prepare( $statement ) };
        $sth->execute;
        push @sub_set, @{ $sth->fetchall_arrayref };
    }
    my %business;
    # To find the column that contains the key
    my $field_num = sub {
        my $field = shift;
        #print "Field     : $field\n";
        for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
            return $i if $sth->{NAME}->[$i] eq $field; 
        }
    };
    for my $row (@sub_set) {
        $business{$$row[&{$field_num}("orgnr")]}++;
    }
    my @acitftg_set;
    for my $orgnum ( keys %business ) {
        my $statement = "SELECT * FROM acib_acitftg WHERE ftg_org_num='$orgnum'";
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
