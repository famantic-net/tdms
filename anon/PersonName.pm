package PersonName;

use strict;
#use feature 'unicode_strings';
use utf8;

use anon::LegalEntity;
use anon::AnonymizedFields;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our ($surnames, @surnames, $given_names, @given_names);

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->pname;
    return bless $self;
}


sub anonymizeName {
    my $self = shift;
    my $real_name = shift;
    my $name_field_len = length($real_name);
    unless ($anonymized{$real_name}) {
        my ($sname, $gname) = $real_name =~ m/([^,]+),\s*(.*)/;
        my $anon_sname = $self->anonymizeSurname($sname);
        $anon_sname =~ s/\s*$//; # Remove trailing space
        my $anon_gname = $self->anonymizeGivenName($gname);
        $anon_gname =~ s/\s*$//; # Remove trailing space
        $anonymized{$real_name} = "$anon_sname, $anon_gname";
    }
    return sprintf "%- ${name_field_len}s", $anonymized{$real_name};
}

sub anonymizeSurname {
    my $self = shift;
    my $real_name = shift;
    my $name_field_len = length($real_name);
    $real_name =~ s/\s*$//; # Remove trailing space
    unless ($anonymized{$real_name}) {
        unless ($surnames) {
            local undef $/;
            open my $fh, "<", "surnames.txt" or die "Can't open 'surnames.txt': $!\n";
            $surnames = <$fh>;
            close $fh;
            @surnames = split "\n", $surnames;
        }
        my $srand = int(rand($#surnames+1));
        $anonymized{$real_name} = uc($surnames[$srand]);
    }
    return sprintf "%- ${name_field_len}s", $anonymized{$real_name};
}

sub anonymizeGivenName {
    my $self = shift;
    my $real_name = shift;
    #print "Got : $real_name\n";
    my $name_field_len = length($real_name);
    $real_name =~ s/\s*$//; # Remove trailing space
    unless ($anonymized{$real_name}) {
        unless ($given_names) {
            open my $fh, "<", "given_names.txt" or die "Can't open 'given_names.txt': $!\n";
            $given_names = <$fh>;
            close $fh;
            @given_names = split "\n", $given_names;
        }
        my $grand = int(rand($#given_names+1));
        $anonymized{$real_name} = uc("$given_names[$grand] ACME");
    }
    #print "Anon: $anonymized{$real_name}\n";
    return sprintf "%- ${name_field_len}s", $anonymized{$real_name};
}


1;