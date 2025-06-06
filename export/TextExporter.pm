package TextExporter;
# Delegates to one of the Testdata subclasses in export::layout::

use strict;
use Module::Pluggable search_path => [ 'export::layout' ],
                      except => qr/export::layout::disable::[^.]*/,
                      require => 1,
                      sub_name => 'layouts';


sub new() {
    my $class = shift;
    my $table_name = shift;
    my @layouts = $class->layouts;
    my @layout = grep /$table_name$/, @layouts;
    return undef if $#layout < 0; # If table definition not found
    eval "use $layout[0]";
    #no strict 'refs';
    my $self = $table_name->new;
    #use strict 'refs';
    return $self;
}



1;