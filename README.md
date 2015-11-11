---
# **Test data management system**
---

https://devtools.bisnode.com/confluence/display/~davtor/Test+data+management+system


## Goals

Enable a long term solution for keeping test data viable in the mainframe environment.


## Background and strategic fit

So far test data has been manually updated in the mainframe and automatically been becoming out of
date. Test characteristics are calculated on raw data, some of which will be dependent on how old they
are rather than when they were created. Manual updates are time consuming and as test data becomes old,
they loose their validity for the purposes they were created and generate more work for those who want
to test or provide test data to testers and customers.





       .------------------------------.
       |                              |
       |                              |
       |          mainframe           |     _.-----._  
       |                              |   .-         -.
       |                              |   |-_       _-|
       |                     .----------->|  ~-----~  |
       |                     |        |   |    RDB    |
       |                     |        |   `.postgresql'
       |                     |        |      "-----"   
       |   _.-----._     _.-----._    |         |
       | .-         -. .-         -.  |         |
       | |-_       _-| |-_       _-|  |         v
       | |  ~-----~  | |  ~-----~  |  |     _.-----._  
       | |  Test DB  | |  Prod DB  |  |   .-         -.
       | `._  DB2  _.' `._  DB2  _.'  |   |-_       _-|
       |    "-----"       "-----"     |   |  ~-----~  |
       |       ^             ^        |   test data DB|
       |       |             |        |    postgresql '
       |       |             |        |      "-----"   
       '-------|-------------|--------'         |
               |             |                  |
               '-------------'-----------<------'


## Tool

There are two main programs used, 'tdms_populate.pl' and 'tdms_manage.pl'.


### tdms_manage.pl

    Synopsis
       tdms_manage.pl -[cdelmrtv]

    Purpose
       Helper functions for Test Data Management System work.

    Options
       -c  Count the number of row in each table

       -d  Truncate, ie deletes all rows, in all tables. Implies "-l".

       -e  Export all tables to text format according to layout information
           defined in classes under .../export/layout.

       -f  FTP exported files to mainframe.

       -l  Perform the action locally, ie on the machine where the script
           runs.

       -m  Display metadata for all tables.

       -r  Roll dates, i.e update certain timestamps.

       -s  Show the contents of all tables that are non-empty.

       -t  Display fields that are defined as "SQL_TIMESTAMP" from all tables.

       -v  Turn on verbose prints to STDOUT about what's happening.

       -x  Show random example data for each field in all non-empty tables.


    Examples
       "tdms_manage.pl -lm"

           Show metadata for the local RDB replica.

       "tdms_manage.pl -lc"

           Display a count of rows for each table in the local RBD replica.

       "tdms_manage.pl -d"

           Truncate all local tables.

       "tdms_manage.pl -ef"

           Export all tables to text format and ftp to mainframe.


### tdms_populate.pl

    Synopsis
       tdms_populate.pl -[asv]

    Purpose
       To populate the Test Data Management System with records from RDB (aka
       DB2REP).

       Will fetch records for companies and individuals each and their
       corresponding data in other tables. Number of records and keys that are
       used are specified in the file tdms.conf.

       All data can be anonymized with the -a switch.

    Options
       -a  Anonymize all data before it is stored to the local database. This
           means that business numbers and person numbers will be altered to
           partly random figures. For businesses the first digit, indicating
           type of business, is preserved. For persons the year is preserved.

       -s  Fetch the specific test data for businesses and persons that have
           been specified in tdms.conf.

       -v  Generate trace output showing processed tables and inserts.


    Examples
       "./tdms_populate.pl -av | tee testdb_populate.log"

       Anonymizes and turns on verbose output showing what is being inserted
       into the local database.


## Additional files

       tdms_conf.pmc
           Contains configuration data such as IP-address to RDB and user/pw,
           table/field relations etc.

       Anonymization
       -------------
           Classes used for creating anonymized fields.

            anon::Address.pm
            anon::AnonymizedFields.pm
            anon::Anonymize.pm
            anon::BusinessAddress.pm
            anon::BusinessName.pm
            anon::BusinessNum.pm
            anon::GivenNames.pm
            anon::LegalEntity.pm
            anon::PersonName.pm
            anon::PersonNum.pm
            anon::PrivateAddress.pm
            anon::SurNames.pm

       Mainframe export
       ----------------
           Classes used for creating export files per table.

            export::Testdata.pm
            export::TextExporter.pm
            export::layout::acba_rathist.pm
            export::layout::acba_ratindik.pm
            export::layout::acba_rating.pm
            export::layout::acba_scoring2.pm
            export::layout::acdt_dttph.pm
            export::layout::acdt_dttpv.pm
            export::layout::acgd_empfun01.pm
            export::layout::acgd_organi01.pm
            export::layout::acib_acitaga.pm
            export::layout::acib_acitarn.pm
            export::layout::acib_acitbif.pm
            export::layout::acib_acitbiv.pm
            export::layout::acib_acitboa.pm
            export::layout::acib_acitefi.pm
            export::layout::acib_acitft2.pm
            export::layout::acib_acitft3.pm
            export::layout::acib_acitftg.pm
            export::layout::acib_acitgaf.pm
            export::layout::acib_acitkcn.pm
            export::layout::acib_acitmin.pm
            export::layout::acib_acitnoe.pm
            export::layout::acib_acitnon.pm
            export::layout::acib_acitntf.pm
            export::layout::acib_acitoms.pm
            export::layout::acib_acitver.pm
            export::layout::acin_intr10.pm
            export::layout::acin_intr20.pm
            export::layout::acin_intr30.pm
            export::layout::acin_intr40.pm
            export::layout::acpr_prtpr.pm
            export::layout::acpr_prtprh.pm
            export::layout::acra_klient.pm
            export::layout::acra_rapp.pm
            export::layout::acra_ratssa.pm
            export::layout::acra_ratssah.pm
            export::layout::acra_uphi.pm
            export::layout::actx_ftax.pm
            export::layout::actx_tax01.pm
            export::layout::actx_tax02.pm
            export::layout::bnycktal.pm




## Attribute

nenad.antic@bisnode.com
