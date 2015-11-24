package Collector;
# Supervisory class to coordinate fetching of test objects with specific properties

use strict;

use Module::Pluggable search_path => [ 'properties::handlers' ], require => 1, sub_name => 'handlers';

sub get_testobjects {
    my $class = shift;
    my $dbargs = shift;
    my @handlers = $class->handlers;
    my $handler;
    for my $handler_name (@handlers) {
        #print "$handler_name\n";
        eval "use $handler_name";
        # Remove leading path
        $handler_name =~ s/.+://;
        $handler = $handler_name->new;
        print ":: @{[ ref($handler) ]}\n";
        my $result_ref = $handler->collect_data($dbargs);
        for my $row (@{$result_ref}) {
            print @{$row}, "\n" ;
        }
    }
}



1;
