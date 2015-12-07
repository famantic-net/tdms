package BusinessNum;

=pod
http://www.scb.se/statistik/AM/AM0302/_dokument/AM0302_DO_1999.pdf

Dispensnummer eller ordinarie organisationsnummer

Dispensnumret är ett särskilt redovisningsnummer som ett fåtal arbetsgivare
blivit tilldelade av länsstyrelserna för att använda vid inbetalning av de
anställdas skatter.

Dispensnumret är uppbyggt på samma sätt som organisationsnumret och känns igen
på att det alltid inleds med två 6:or. 

Dispensnumret är tolvställigt och börjar på två 6:or.
Om dispensnummer saknas anges ordinarie organisationsnummer.
=cut

use strict;
use feature 'unicode_strings';

use anon::AnonymizedFields;
use anon::LegalEntity;
use anon::Discarded_bnums;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our @used_bnums = ();
our $bnum_store = undef;
our $max_tries = 1000;

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgnum;
    unless ($bnum_store) {
        $bnum_store = new Discarded_bnums;
    }
    return bless $self;
}


# Returns a new organization number stub based on the received number
sub anonymizeOrgNumber { # $orgnum
    my $self = shift;
    my $orgnum = shift;
    my $JFR= "JFR_" . shift;
    unless ($anonymized{$orgnum}) {
        my $lead_dig;
        if (length($orgnum) == 12) {
            #($lead_dig) = $orgnum =~ m/^(\d\d)/;
            $orgnum =~ s/^(\d\d)//;
            $lead_dig = $1;
        }
        my @bnums = @{$bnum_store->$JFR};
        my $idx = int(rand($#bnums));
        my $tries;
        while (grep /$bnums[$idx]/, @used_bnums) {
            $idx = int(rand($#bnums));
            if ($tries++ > $max_tries) {
                warn "\nWARNING: NO AVAILABLE DISCARDED BUSINESS MUMBER FOR $JFR!\n";
                last;
            }
        }
        # print ":: Got number $bnums[$idx] after $tries attempts.\n";
        push @used_bnums, $bnums[$idx];
        $anonymized{$orgnum} = $lead_dig ? $lead_dig . $bnums[$idx] : $bnums[$idx];
    }
    return $anonymized{$orgnum};
}



1;