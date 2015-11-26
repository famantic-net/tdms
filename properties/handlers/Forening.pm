package Forening;

use strict;

use properties::Idrotter;

our @ISA = qw(Property);

our %Forening = (
        substatements => {
            brf_statement => q(
                SELECT * FROM acib_acitftg
                        WHERE ftg_iklass_kod LIKE '%53'
                        ORDER BY random()
                        LIMIT #size#
            ),
            ek_statement => q(
                SELECT * FROM acib_acitftg
                        WHERE ftg_iklass_kod LIKE '%51'
                        ORDER BY random()
                        LIMIT #size#
            ),
            idrott_statement => q(
                SELECT * FROM acib_acitftg
                        WHERE (ftg_iklass_kod LIKE '%61' OR ftg_iklass_kod LIKE '%51')
                        AND
                        (ftg_iregnamn LIKE '%#sport#%')
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
    my @result_set;
    my %substatements = %{ $self->substatements };
    for my $sub (keys %substatements) {
        my $statement = $substatements{$sub};
        $statement =~ s/#size#/$init_size/;
        my $sub_condition;
        if ($statement =~ m/\((ftg_iregnamn[^#]+#sport#[^)]+)\)/) {
            $sub_condition = $1;
        }
        if ($sub =~ m/idrott/) {
            my @idrotter = @{Idrotter->new};
            my $condition;
            for my $sport (@idrotter) {
                my $cond = $sub_condition;
                $cond =~ s/#sport#/$sport/;
                $condition .= "$cond OR ";
            }
            $condition =~ s/ OR $//;
            $statement =~ s/$sub_condition/$condition/;
            #print $statement;
        }
        
        $sth = eval { $dbh->prepare( $statement ) };
        $sth->execute;
        push @result_set, @{ $sth->fetchall_arrayref };
    }
    return \@result_set;
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
