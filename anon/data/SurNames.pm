package SurNames;

use strict;
use utf8;

our @SurNames = qw(    
    Andersson
    Johansson
    Karlsson
    Nilsson
    Eriksson
    Larsson
    Olsson
    Persson
    Svensson
    Gustafsson
    Pettersson
    Jonsson
    Jansson
    Hansson
    Bengtsson
    Jönsson
    Lindberg
    Jakobsson
    Magnusson
    Olofsson
    Lindström
    Lindqvist
    Lindgren
    Axelsson
    Berg
    Bergström
    Lundberg
    Lundgren
    Lundqvist
    Lind
    Mattsson
    Berglund
    Fredriksson
    Sandberg
    Henriksson
    Forsberg
    Sjöberg
    Wallin
    Engström
    Danielsson
    Håkansson
    Eklund
    Lundin
    Gunnarsson
    Holm
    Björk
    Bergman
    Samuelsson
    Fransson
    Wikström
    Isaksson
    Bergqvist
    Arvidsson
    Nyström
    Holmberg
    Löfgren
    Söderberg
    Nyberg
    Claesson
    Blomqvist
    Mårtensson
    Nordström
    Lundström
    Eliasson
    Pålsson
    Björklund
    Viklund
    Berggren
    Sandström
    Lund
    Mohamed
    Nordin
    Ali
    Ström
    Åberg
    Hermansson
    Ekström
    Holmgren
    Sundberg
    Hedlund
    Dahlberg
    Hellström
    Sjögren
    Falk
    Abrahamsson
    Martinsson
    Öberg
    Blom
    Andreasson
    Ek
    Månsson
    Strömberg
    Åkesson
    Jonasson
    Hansen
    Norberg
    Åström
    Sundström
    Lindholm
    Holmqvist
);


sub new {
    my $class = shift;
    no strict "refs";
    return bless \@{$class};
}


1;