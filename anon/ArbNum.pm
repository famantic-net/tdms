package ArbNum;

use strict;
use feature 'unicode_strings';

use anon::AnonymizedFields;
use anon::LegalEntity;
use anon::data::ARN_DUNS;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our $wpnum_store = undef;

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->arbnum;
    unless ($wpnum_store) {
        $wpnum_store = new ARN_DUNS;
    }
    return bless $self;
}


sub anonymizeWorkplaceNumber { # wpnum
    my $self = shift;
    my $wpnum = shift;
    unless ($anonymized{$wpnum}) {
        my @ARNs_arr = $wpnum_store->get_ARNs;
        my $arn_key = $ARNs_arr[int(rand($#ARNs_arr))];
        my ($ARN) = $arn_key =~ m/(\d+)$/;
        $anonymized{$wpnum} = $ARN;

        $wpnum_store->discard_ARN($arn_key);
    }
    return $anonymized{$wpnum};
}



1;