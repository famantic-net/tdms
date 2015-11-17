package Collector;
# Supervisory class to coordinate fetching of test objects with specific properties

use strict;

use properties::handlers::AB;


sub get_testobjects {
    my $self = shift;
    my $dbargs = shift;
    my $handler =new AB;
    my $result_ref = $handler->collect_data($dbargs);
    for my $row (@{$result_ref}) {
        print @{$row}, "\n" ;
    }
}



1;
