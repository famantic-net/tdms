package TextExporter;
# Delegates to one of the Testdata subclasses in exporter::layout::

use strict;
use feature 'unicode_strings';
use export::layout::acra_rapp;
use export::layout::acba_rathist;
use export::layout::acba_ratindik;
use export::layout::acba_rating;
use export::layout::acba_scoring2;
use export::layout::acib_acitbiv;
use export::layout::acib_acitbif;
use export::layout::acib_acitarn;
use export::layout::acib_acitaga;
use export::layout::acgd_organi01;
use export::layout::acgd_empfun01;
use export::layout::acdt_dttpv;
use export::layout::acdt_dttph;
use export::layout::acib_acitftg;
use export::layout::acib_acitft3;
use export::layout::acib_acitefi;
use export::layout::acib_acitver;
use export::layout::acib_acitntf;
use export::layout::acib_acitnon;
use export::layout::acib_acitnoe;
use export::layout::acib_acitmin;
use export::layout::acib_acitkcn;
use export::layout::acib_acitgaf;
use export::layout::acib_acitoms;
use export::layout::acib_acitft2;
use export::layout::acib_acitboa;
use export::layout::actx_tax02;
use export::layout::actx_tax01;
use export::layout::actx_ftax;
use export::layout::acra_uphi;
use export::layout::acra_ratssah;
use export::layout::acra_ratssa;
use export::layout::acra_klient;
use export::layout::acpr_prtprh;
use export::layout::acpr_prtpr;
use export::layout::acin_intr40;
use export::layout::acin_intr30;
use export::layout::acin_intr20;
use export::layout::acin_intr10;
use export::layout::acxx_bnycktal;

#our %table_map = (
#    acra_rapp => "AcraRapp",
#);

# Takes the table name as argument and delegates to the corresponding layout class
# The layout classes have the same names as their corresponding tables
sub new() {
    my $class = shift;
    my $table_name = shift;
    no strict 'refs';
    #my $self = new AcraRapp;
    #my $self = $table_map{$table}->new;
    no strict 'refs';
    my $self = $table_name->new;
    use strict 'refs';
    return $self;
}




1;