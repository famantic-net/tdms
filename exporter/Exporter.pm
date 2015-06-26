package Exporter;

use strict;
use exporter::layout::acra_rapp;

#our %table_map = (
#    acra_rapp => "AcraRapp",
#);

# Takes the table name as argument and delegates to the corresponding layout class
sub new() {
    my $class = shift;
    my $table = shift;
    #print $table;
    no strict 'refs';
    #my $self = new AcraRapp;
    #my $self = $table_map{$table}->new;
    no strict 'refs';
    my $self = $table->new;
    use strict 'refs';
    return $self;
}




1;