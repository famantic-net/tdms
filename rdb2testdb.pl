#!/usr/bin/env perl

use DBI;
use Getopt::Std;

our @company_entry = qw(acib_acitftg ftg_org_num);
our @person_entry = qw(acpr_prtpr pnr);
# Mapping of table to relevant column
# %orgnum{tablename}
require "testdata_columns.plx";

$dbh_local = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=localhost;
                        port=5432',
                        'db2moto',
                        '',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );

$dbh_rdb = DBI->connect('dbi:Pg:dbname=DB2REP;
                        host=10.46.117.29;
                        port=5432',
                        'nenant',
                        'Nen00ant',
                        {AutoCommit=>1,RaiseError=>1,PrintError=>0}
                    );

print "\nFetching from $company_entry[0]\n";
our $statement = "SELECT * FROM $company_entry[0] order by random() limit 100";
our $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
$sth_rdb->execute();

our $ins = "insert into $company_entry[0] values (";
for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
    $ins .= "?, ";
}
$ins =~ s/, $//;
$ins .= ");";
#print "$ins\n";

our $sth_local = eval { $dbh_local->prepare($ins) };
my $fields = $sth_rdb->{NUM_OF_FIELDS};
for ( my $i = 0 ; $i < $fields ; $i++ ) {
    #print $sth_rdb->{NAME}->[$i];
    $company_num_col = $i if $sth_rdb->{NAME}->[$i] eq $company_entry[1]; 
}

our @companies;
our $result_ref = $sth_rdb->fetchall_arrayref;
for my $row (@{ $result_ref }) {
    #print ${$row}[0];
    push @companies, ${$row}[$company_num_col];
    #print "Inserting @{$row}\n";
    eval { $sth_local->execute(@{$row}) };
 }

# For every table with some company number fetch the rows that correspond
# to the fetched companies
for my $table (keys %orgnum_name) {
    print "\nFetching from $table\n";
    for my $num (@companies) {
        $statement = "SELECT * FROM $table WHERE $orgnum_name{$table}='$num'";
        #print "$statement\n";
        $sth_rdb = eval { $dbh_rdb->prepare( $statement ) };
        $sth_rdb->execute();
        my $result_table_ref = $sth_rdb->fetchall_arrayref;
        $ins = "INSERT INTO $table VALUES (";
        for ( my $i = 0 ; $i < $sth_rdb->{NUM_OF_FIELDS} ; $i++ ) {
            $ins .= "?, ";
        }
        $ins =~ s/, $//;
        $ins .= ");";
        #print "$ins\n";
        my $sth_local = eval { $dbh_local->prepare($ins) };
        for my $row (@{$result_table_ref}) {
            print "Inserting @{$row}\n";
            eval { $sth_local->execute(@{$row}) };
        }
        
    }
}
