package Collector;
# Supervisory class to coordinate fetching of test objects with specific properties

use strict;

use Module::Pluggable search_path => [ 'properties::handlers' ], require => 1, sub_name => 'handlers';
#use properties::handlers::AB;
#use properties::handlers::Rating;

sub get_testobjects {
    my $class = shift;
    my $dbargs = shift;
    my @handlers = $class->handlers;
    my $handler;
    for my $handler_name (@handlers) {
        print "$handler_name\n";
        eval "use $handler_name";
        # Remove leading path
        $handler_name =~ s/.+://;
        $handler = $handler_name->new;
        print ":: @{[ ref($handler) ]}\n";
        #my $handler =new AB;
        my $result_ref = $handler->collect_data($dbargs);
        for my $row (@{$result_ref}) {
            print @{$row}, "\n" ;
        }
        #print ":: Rating\n";
        #$handler =new Rating;
        #$result_ref = $handler->collect_data($dbargs);
        #for my $row (@{$result_ref}) {
        #    print @{$row}, "\n" ;
        #}
    }
}



1;
