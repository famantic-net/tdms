package PersonName;

use strict;
use feature 'unicode_strings';

use tdms_conf qw($testobject_tag);
use anon::LegalEntity;
use anon::AnonymizedFields;
use anon::data::SurNames;
use anon::data::GivenNames;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our (@surnames, @given_names);

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
        @surnames = @{SurNames->new} unless $#surnames > -1;
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
        @given_names = @{GivenNames->new} unless $#given_names > -1;
        my $grand = int(rand($#given_names+1));
        $anonymized{$real_name} = uc("$given_names[$grand] " . $testobject_tag);
    }
    #print "Anon: $anonymized{$real_name}\n";
    return sprintf "%- ${name_field_len}s", $anonymized{$real_name};
}


1;