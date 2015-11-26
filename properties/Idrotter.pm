package Idrotter;

use strict;
use utf8;

our @Idrotter = qw(    
    Aerobics
    Aikido
    Armbryt
    Backhoppning
    Badminton
    Bågskytte
    Ballongflyg
    Bandy
    Bangolf
    Baseboll
    Basket
    Beachvolleyboll
    Biljard
    Bilsport
    BMX
    Bob
    Bordtennis
    Boule
    Bowling
    Boxning
    Brottning
    Budo
    Bujinkan
    Capoeira
    Casting
    Cheerleading
    Cricket
    Curling
    Cykel
    Cykling
    Dans
    Dart
    Dövidrott
    Draghundsport
    Dragkamp
    Dragracing
    Enduro
    Fäktning
    Fallskärmshoppning
    Fotboll
    fridykning
    Friidrott
    Frisbee
    Gevär
    Glima
    Golf
    Gym
    Gymnastik
    Gympa
    Handboll
    Hängflyg
    Hapkido
    HEMA
    Hockey
    Iaido
    Idrott
    Innebandy
    Ishockey
    Islandshäst
    Isracing
    Issegling
    Jiu-Jitsu
    Jodo
    Judo
    Ju-Jutsu
    Kägel
    Kampsport
    Kanot
    Karate
    Kendo
    Kickboxning
    Klättring
    Konståkning
    Konstflyg
    Korpen
    Krav Maga
    Kyokushin
    Kyudo
    Längdåkning
    Linedance
    Löpning
    Mångkamp
    MMA
    Modellflyg
    Motocross
    Motorflyg
    Muaythai
    Naginata
    Orientering
    Parasport
    Pilates
    Pistol
    Racerbåt
    Rid
    Ringette
    Roadracing
    Rodd
    Rodel
    Rugby
    Sambo
    Savate
    Segelflyg
    Segling
    Shootfighting
    Shorinjikempo
    Sim
    Skärmflyg
    Skateboard
    Skid
    Skidorientering
    Skidskytte
    Skolidrott
    Skridsko
    Skytte
    Snowboard
    Softboll
    Speedway
    Spinning
    Sportdykning
    Squash
    Stavgång
    Streetdance
    Styrkelyft
    Sumo
    Systema
    Taekwondo
    Taido
    Telemark
    Tennis
    Thaiboxning
    Tipspromenad
    Triathlon
    Tyngdlyftning
    Varpa
    Vattenskidor
    Volleyboll
    Wakeboard
    Wrestling
    Wushu
    Yoga
    Zumba
);


sub new {
    my $class = shift;
    no strict "refs";
    return bless \@{$class};
}


1;