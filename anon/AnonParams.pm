package AnonParams;
# Storing arguments for test object collection

use strict;


sub new() {
    my $invocant = shift;
    my $class   = ref($invocant) || $invocant;
    my $self = {
        target => undef,
        dbh => undef,
        entry_table => undef,
        tob_tuple => [],
        sth => undef,
        JFR => undef,
        ANR => undef,
        @_,                 # Override previous attributes
    };
    #map {print "$_ => ${$self}{$_}, "} sort keys %{$self};
    #print "\n";
    return bless $self, $class;
}


sub target {
    my $self = shift;
    $self->{target} = shift if @_;
    return $self->{target};
} 


sub dbh {
    my $self = shift;
    $self->{dbh} = shift if @_;
    return $self->{dbh};
} 


sub entry_table {
    my $self = shift;
    $self->{entry_table} = shift if @_;
    return $self->{entry_table};
} 


sub tob_tuple {
    my $self = shift;
    $self->{tob_tuple} = shift if @_;
    return $self->{tob_tuple};
} 


sub sth {
    my $self = shift;
    $self->{sth} = shift if @_;
    return $self->{sth};
} 


sub JFR {
    my $self = shift;
    $self->{JFR} = shift if @_;
    return $self->{JFR};
} 


sub ANR {
    my $self = shift;
    $self->{ANR} = shift if @_;
    return $self->{ANR};
} 





1;
