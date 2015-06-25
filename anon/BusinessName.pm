package BusinessName;

use strict;
#use feature 'unicode_strings';
use utf8;

use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our ($dbh, $name_id);
our $name_table = "acib_acitftg";
our $name_field = "ftg_namn1";
our $limit = 100000; # The number of business names to fetch from RDB
our @name_rows;


sub new() {
    my $class = shift;
    $dbh = shift;
    $name_id = shift;
    my $self = AnonymizedFields->orgname;
    return bless $self;
}


sub anonymizeBusinessName {
    my $self = shift;
    my $real_name = shift;
    return $real_name if $real_name =~ m/^\s*$/; # If empty return what came in
    my $name_field_len = length($real_name);
    unless ($anonymized{$name_id}) {
        my $base_names_ref = $self->__get_names;
        #print join "\n", @{$base_names_ref}, "\n";
        my $anon_name;
        for my $item (@{$base_names_ref}) {
            my @item = split /[\s,]+/, $item;
            my $item_part;
            do {
                $item_part = $item[int(rand($#item+1))];
            } while ($item_part =~ m/\bAB\b/);
            $anon_name .= $item_part . " ";
        }
        $anon_name =~ s/\s*$//; # Remove any trailing space
        if ($real_name =~ m/\bAB\b/) {
            $anon_name .= " AB";
        }
        elsif ($real_name =~ m/\bHB\b/) {
            $anon_name .= " HB";
        }
        $anonymized{$name_id}{full} = $anon_name;
    }
    return substr(sprintf("%- ${name_field_len}s", $anonymized{$name_id}{full}), 0, $name_field_len); # In case the new name is too long
}


sub anonymizeBusinessAbbr {
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
    #my @name = split '', $name;
    #print ": @name\n";
    #my $pos;
    #while ($pos < ($name_field_len - 4)) {
    #    $pos += int(rand(3)+1);
    #    $abbr .= $name[$pos];
    #}
    #print "Abbr: $abbr\n";
    $anonymized{$name_id}{abbr} = substr("ACME" . int(rand(10)) . $name, 0, $name_field_len);
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