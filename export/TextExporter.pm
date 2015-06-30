package TextExporter;
# Delegates to one of the Testdata subclasses in exporter::layout::

use strict;
use feature 'unicode_strings';
use export::layout::acra_rapp;
use export::layout::acba_rathist;

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