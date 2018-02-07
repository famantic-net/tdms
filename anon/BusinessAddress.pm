package BusinessAddress;

use strict;

use anon::AnonymizedFields;
use anon::Address;

our @ISA = qw(Address);
our ($dbh, $address_id);


sub new() {
    my $class = shift;
    $dbh = shift;
    $address_id = shift;
    $class->SUPER::init($dbh, $address_id);
    my $self = AnonymizedFields->business_address;
    return bless $self;
}




sub __get_names {
        if ($#name_rows < 0) {
            my $statement = "SELECT $name_field FROM $name_table order by random() limit $limit";
            my $sth = $dbh->prepare( $statement );
            $sth->execute;
            #my $result_ref = $sth->fetchall_arrayref;
            @name_rows = @{$sth->fetchall_arrayref};
        }
        my @base_names;
        for (my $i=0; $i <3; $i++) {
            my $name_idx = int(rand($#name_rows));
            $base_names[$i] = $name_rows[$name_idx]->[0];
        }
        return \@base_names;
}


1;