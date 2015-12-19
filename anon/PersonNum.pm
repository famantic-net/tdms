package PersonNum;
# TODO: Assuming century 19. Must be corrected after 2015 so that also century 20 is handled correctly
# TODO: Obtain year as close as possible

use strict;
use feature 'unicode_strings';
use Carp;
use List::Util qw(shuffle);

use anon::AnonymizedFields;
use anon::LegalEntity;
use anon::data::TestPersonNums;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our $pnum_store = undef;
our $tried_all;


sub new() {
    my $class = shift;
    my $self = AnonymizedFields->pnum;
    unless ($pnum_store) {
        $pnum_store = new TestPersonNums;
    }
    return bless $self;
}

# Returns a new person number based on the received number
# Tries to obtain same year, otherwise random
sub anonymizePersonNumber { # pnum
    my $self = shift;
    my $pnum = shift;
    if ($pnum =~ m/^\s*$/ or $pnum == 0) { # If empty return what came in
        return $pnum;
    }
    my $year;
    if (length($pnum) == 12) {
        ($year) = $pnum =~ m/^(\d{4})/;
        
    }
    else {
        ($year) = $pnum =~ m/^(\d{2})/;
        $year = "19" . $year; 
    }
    unless ($anonymized{$pnum}) {
        my $YEAR = "Y_" . $year;
        my (@pnums, $idx);
        if ($pnum_store->can($YEAR)) {
            @pnums = @{$pnum_store->$YEAR};
            unless ($#pnums < 0) { # No more numbers in that YEAR category
                $idx = int(rand($#pnums));
            }
            else {
                ($YEAR, $idx) = _get_random_YEAR($pnum, $YEAR);
                @pnums = @{$pnum_store->$YEAR};
            }
        }
        else {
            ($YEAR, $idx) = _get_random_YEAR($pnum, $YEAR);
            @pnums = @{$pnum_store->$YEAR};
        }
        my $anon_pnum = $pnums[$idx];
        my $mod_pnum = $pnum;
        # Assign both normal and full anonymous person numbers
        if (length($pnum) == 12) {
            $anonymized{$pnum} = $anon_pnum; # Full anonymized
            $mod_pnum =~ s/^\d\d//;
            $anon_pnum =~ s/^\d\d//;
            $anonymized{$mod_pnum} = $anon_pnum; # Normal anoymized
        }
        else {
            $mod_pnum = "19" . $mod_pnum;
            $anonymized{$mod_pnum} = $anon_pnum;  # Full anonymized
            $anon_pnum =~ s/^\d\d//;
            $anonymized{$pnum} = $anon_pnum;  # Normal anoymized
        }
        $pnum_store->discard_number($YEAR, $idx);
    }
    return $anonymized{$pnum};
}

sub _get_random_YEAR {
    my $pnum = shift;
    my $YEAR = shift;
    my $idx;
    print "WARNING: NO AVAILABLE TEST PERSON NUMBER FOR $pnum in $YEAR!\n";
    unless ($tried_all) {
        # Assign a person number from the other available
        my @YEARs = $pnum_store->get_all_YEARs;
        for my $year_key (shuffle @YEARs) {
            next unless $pnum_store->can($year_key);
            my @pnums = @{$pnum_store->$year_key};
            unless ($#pnums < 0) {
                $idx = int(rand($#pnums));
                $YEAR = $year_key;
                last;
            }
        }
        $tried_all = 1 unless defined $idx;
    }
    if ($tried_all) {
        confess "\nERROR: Can't anonymize person number $pnum\n";
    }
    return $YEAR, $idx;
}




1;