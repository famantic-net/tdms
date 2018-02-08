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


sub anonymizeBusinessAddress {
    my $self = shift;
    my $real_name = shift;
    #return $real_name if $real_name =~ m/^\s*$/; # If empty return what came in
    #print "Name: $real_name\n";
    my $name_field_len = length($real_name);
    unless ($anonymized{$name_id}{full}) { # If there is no business name, create one
        $anonymized{$name_id}{full} = $self->anonymizeBusinessName($real_name);
    }
    my $name = $anonymized{$name_id}{full};
    $name =~ s/\s+//g; # Remove all spaces
    $name = uc $name;
    my @name = split '', $name;
    #print ": @name\n";
    my $pos = 6;
    my $abbr = $name[$pos];
    while ($pos < ($#name)) {
        $pos += int(rand(3)+1);
        $abbr .= $name[$pos];
    }
    #print "Abbr: $abbr\n";
    $anonymized{$name_id}{abbr} = substr($abbr, 0, $name_field_len);
    return sprintf("%- ${name_field_len}s", $anonymized{$name_id}{abbr});
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