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

Andra inledande nummer är 19 och 16.
=cut

use strict;
use feature 'unicode_strings';
use Carp;
use List::Util qw(shuffle);

use anon::AnonymizedFields;
use anon::LegalEntity;
use anon::data::Discarded_bnums;

our @ISA = qw(LegalEntity);
our %anonymized = ();
our $bnum_store = undef;
our $tried_all;

sub new() {
    my $class = shift;
    my $self = AnonymizedFields->orgnum;
    unless ($bnum_store) {
        $bnum_store = new Discarded_bnums;
    }
    return bless $self;
}


# Returns a new business number based on the received number
# with the same JFR
sub anonymizeOrgNumber { # orgnum, anonparams
    my $self = shift;
    my $orgnum = shift;
    my $anonparams = shift;
    my $JFR;
    if ($anonparams->JFR) {
        $JFR = $anonparams->JFR;
    }
    else{
        my $statement = "SELECT * FROM acib_acitftg WHERE ftg_org_num='$orgnum'";
        my $sth = eval { $anonparams->dbh->prepare( $statement ) };
        $sth->execute();
        my $result_ref = $sth->fetchall_arrayref;
        my @result_set = @{ $result_ref };
        # Find the column that contains the key
        my $field_num = sub {
            my $field = shift;
            #print "Field     : $field\n";
            for ( my $i = 0 ; $i < $sth->{NUM_OF_FIELDS} ; $i++ ) {
                return $i if $sth->{NAME}->[$i] eq $field; 
            }
        };
        my $row = $result_set[0];
        ($JFR) = ${$row}[&{$field_num}("ftg_iklass_kod")] =~ m/(\d\d)$/;
    }
    $JFR = "JFR_$JFR";
    my $lead_dig;
    if (length($orgnum) == 12) {
        ($lead_dig) = $orgnum =~ m/^(\d\d)/;
        $orgnum =~ s/^(\d\d)//;
    }
    unless ($anonymized{$orgnum}) {
        my (@bnums, $idx);
        if ($bnum_store->can($JFR)) {
            @bnums = @{$bnum_store->$JFR};
            unless ($#bnums < 0) { # No more numbers in that JFR category
                $idx = int(rand($#bnums));
            }
            else {
                $idx = _get_random_number($orgnum, $JFR);
            }
        }
        else {
            $idx = _get_random_number($orgnum, $JFR);
        }
        $orgnum = $lead_dig . $orgnum if defined $lead_dig;
        $anonymized{$orgnum} = $lead_dig ? $lead_dig . $bnums[$idx] : $bnums[$idx];
        $bnum_store->discard_number($JFR, $idx);
    }
    return $anonymized{$orgnum};
}

sub _get_random_number {
    my $orgnum = shift;
    my $JFR = shift if @_;
    my $idx;
    print "\nWARNING: NO AVAILABLE DISCARDED BUSINESS NUMBER FOR $orgnum in $JFR!\n";
    unless ($tried_all) {
        # Assign a business number from any of the other available
        my @JFRs = @{$bnum_store->JFRall};
        for my $jfr (shuffle @JFRs) {
            $JFR = "JFR_$jfr";
            my @bnums = @{$bnum_store->$JFR};
            unless ($#bnums < 0) {
                $idx = int(rand($#bnums));
                last;
            }
        }
        $tried_all = 1 unless defined $idx;
    }
    else {
        confess "\nERROR: Can't anonymize business number $orgnum\n";
    }
    return $idx;
}



1;