package Address; # Abstract
# This class is only used through its subclasses BusinessAddress and PrivateAddress

use strict;
use feature 'unicode_strings';

use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our $address_table = "acib_acitpnr";
our @address_rows;
our $limit = 100000;
our $street_pos = 2;
our $num_range_low_pos = 4;
our $num_range_high_pos = 5;
our $zip_pos = 0;
our $municipality_pos = 6;
our ($dbh, $address_id);


sub init() {
    my $class = shift;
    $dbh = shift;
    $address_id = shift;
}


sub anonymizeStreet {
    my $self = shift;
    my $real_street = shift;
    my $street_field_len = length($real_street);
    unless ($anonymized{$address_id}) {
        $anonymized{$address_id} = $self->__get_address;
    }
    #else {
    #    print "::Already have address for $address_id: @{$anonymized{$address_id}}\n";
    #}
    return substr(sprintf("%- ${street_field_len}s", $anonymized{$address_id}[0]), 0, $street_field_len); # In case the new name is too long
}

sub anonymizeMunicipality {
    my $self = shift;
    my $real_municipality = shift;
    my $municipality_field_len = length($real_municipality);
    unless ($anonymized{$address_id}) {
        $anonymized{$address_id} = $self->__get_address;
    }
    return sprintf "%- ${municipality_field_len}s", $anonymized{$address_id}[1];
}

sub anonymizeZip {
    my $self = shift;
    my $real_zip = shift;
    my $zip_field_len = length($real_zip);
    unless ($anonymized{$address_id}) {
        $anonymized{$address_id} = $self->__get_address;
    }
    return sprintf "%- ${zip_field_len}s", $anonymized{$address_id}[2];
}


sub anonymizeZipNew {
    my $self = shift;
    my $real_zip = shift;
    my $zip_field_len = length($real_zip);
    unless ($anonymized{$address_id}) {
        $anonymized{$address_id} = $self->__get_address;
    }
    return sprintf "%- ${zip_field_len}s", $anonymized{$address2_id}[2];


sub __get_address {
    if ($#address_rows < 0) {
        my $statement = "SELECT * FROM $address_table order by random() limit $limit";
        my $sth = $dbh->prepare( $statement );
        $sth->execute;
        @address_rows = @{$sth->fetchall_arrayref};
    }
    my $idx = int(rand($#address_rows));
    my @address_row = @{$address_rows[$idx]};
    splice @address_rows, $idx, 1;
    my $street = $address_row[$street_pos];
    $street =~ s/\s*$//; # Remove trailing space
    my $street_num = $address_row[$num_range_low_pos] + int(rand($address_row[$num_range_high_pos]-$address_row[$num_range_low_pos]));
    my $street_addr = $street_num > 0 ? "$street $street_num" : $street;
    return [ $street_addr, $address_row[$municipality_pos], $address_row[$zip_pos] ];
}



1;