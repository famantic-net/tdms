package Property; # Abstract
# Generic methods for property handling

use strict;

# To find the column that contains the key
sub field_num {
    my $self = shift;
    my $sth = shift;
    my $field = shift;
    #print "Field     : $sth::$field\n";
    for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
        #print "$i: ", $sth->{NAME}->[$i]. "\n";
        return $i if $sth->{NAME}->[$i] eq $field; 
    }
};

# Fetch spcified businesses from acib_acitftg
sub get_ftg {
    my $self = shift;
    my $dbh = shift;
    my $business = shift ;
    my @acitftg_set;
    for my $orgnum ( keys %{$business} ) {
        my $statement = "SELECT * FROM acib_acitftg WHERE ftg_org_num='$orgnum'";
        my $sth = eval { $dbh->prepare( $statement ) };
        $sth->execute;
        push @acitftg_set, @{ $sth->fetchall_arrayref };
    }
    return \@acitftg_set;
}


1;