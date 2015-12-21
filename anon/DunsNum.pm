package DunsNum;

use strict;
use feature 'unicode_strings';

use anon::AnonymizedFields;
use anon::LegalEntity;
use anon::data::ARN_DUNS;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our $duns_store = undef;

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->dunsnum;
    unless ($duns_store) {
        $duns_store = new ARN_DUNS;
    }
    return bless $self;
}


sub anonymizeDunsNumber { # wpnum
    my $self = shift;
    my $dunsnum = shift;
    unless ($anonymized{$dunsnum}) {
        my @ARNs_arr = $duns_store->get_ARNs;
        my $arn_key = $ARNs_arr[int(rand($#ARNs_arr))];
        my ($anon_dunsnum) = $duns_store->$arn_key;
        $anonymized{$dunsnum} = $anon_dunsnum;

        $duns_store->discard_ARN($arn_key);
    }
    return $anonymized{$dunsnum};
}



1;