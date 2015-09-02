package AnonymizedFields;
# This class holds the tables and their respective fields that should be anonymized
# Anonymized data should be
# - business number
# - person number
# - Name
# - Address

use strict;

# Fields to anonymize. Generated from selected entries obtained with 'rdb_data.pl -xl'
# perl -e 'open(my $fh, "<", "anonymize_me.txt") or die "Cant open"; {local undef $/; $anon = <$fh>};  while ($anon =~ m/(.+?)^>\n/smg) {$block = $1; ($table) = $block =~ m/^([^\n]+)/; my @fields; while ($block =~ m/<([^>]+)>/smg) {push @fields, $1} print "$table => [ qw(@fields) ],\n"}'
# The keys separate different types
our %AnonymizedFields = (
    all => {
        acba_rathist => [ qw(orgnr) ],
        acba_ratindik => [ qw(orgnr) ],
        acba_rating => [ qw(orgnr) ],
        acba_scoring2 => [ qw(orgnr) ],
        acdt_dttph => [ qw(org_num dobnr_num) ],
        acdt_dttpv => [ qw(org_num dobnr_num) ],
        acgd_empfun01 => [ qw(dunsnr orgnr firstname lastname) ],
        acgd_organi01 => [ qw(dunsnr orgnr) ],
        acib_acitaga => [ qw(aga_org_num) ],
        acib_acitarn => [ qw(arn_dunsnr_num arn_org_num arn_badr arn_bpost_num arn_bport arn_padr arn_ppost_num arn_pport) ],
        acib_acitbif => [ qw(bif_org_num bif_iregnamn bif_namn1) ],
        acib_acitbiv => [ qw(biv_org_num) ],
        acib_acitboa => [ qw(boa_org_num) ],
        acib_acitefi => [ qw(efi_org_num efi_iregnamn efi_namn1 efi_namn2 efi_iadr efi_coadr efi_ipost_num efi_iport efi_kommun efi_lan) ],
        acib_acitft2 => [ qw(ft2_org_num ft2_presnamn ft2_co_adress) ],
        acib_acitft3 => [ qw(ft3_org_num) ],
        acib_acitftg => [ qw(ftg_org_num ftg_namn1 ftg_namn2 ftg_iadr ftg_ipost_num ftg_iport ftg_land_kod ftg_iregnamn ftg_namn1_nrm) ],
        acib_acitgaf => [ qw(gaf_org_num gaf_namn1 gaf_namn2 gaf_iadr gaf_ipost_num gaf_iport gaf_rikt_num gaf_abon_num gaf_namn1_nrm) ],
        acib_acitkcn => [ qw(kcn_id_num kcn_modr_num kcn_dottr_num kcn_landkod kcn_dobnr kcn_namn) ],
        acib_acitmin => [ qw(min_id_num min_modr_num min_dottr_num min_landkod min_dobnr min_namn) ],
        acib_acitnon => [ qw(non_org_num) ],
        acib_acitntf => [ qw(ntf_org_num) ],
        acib_acitoms => [ qw(oms_org_num oms_org12_num) ],
        acib_acitver => [ qw(ver_org_num) ],
        acin_intr10 => [ qw(orgnr) ],
        acin_intr20 => [ qw(pnr orgnr namn) ],
        acin_intr30 => [ qw(orgnr) ],
        acin_intr40 => [ qw(pnr orgnr namn namnas) ],
        acpr_prtpr => [ qw(pnr pnr12 namn sp_coadress sp_foadress sp_gatuadress sp_postnr sp_postort utl_landkod utl_postkod utl_postort utl_land mnamn enamn fnamn fbf_coadress fbf_foadress fbf_gatuadress fbf_postnr fbf_postort rel_pnr) ],
        acpr_prtprh => [ qw(pnr pnr12 namn sp_coadress sp_foadress sp_gatuadress sp_postnr sp_postort utl_landkod utl_postkod utl_postort utl_land mnamn enamn fnamn fbf_coadress fbf_foadress fbf_gatuadress fbf_postnr fbf_postort) ],
        acra_klient => [ qw(orgnr) ],
        acra_rapp => [ qw(orgnr) ],
        acra_ratssa => [ qw(orgnr12 orgnr) ],
        acra_ratssah => [ qw(orgnr12 orgnr) ],
        acra_uphi => [ qw(orgnr) ],
        actx_ftax => [ qw(orgnr) ],
        actx_tax01 => [ qw(pnr pnr12) ],
        actx_tax02 => [ qw(pnr pnr12) ],
        nsdb_sync => [ qw(ftg_org_num) ],
        nyckeltal => [ qw(org_num) ],
    },
    orgnum => {
        acba_rathist => [ qw(orgnr) ],
        acba_ratindik => [ qw(orgnr) ],
        acba_rating => [ qw(orgnr) ],
        acba_scoring2 => [ qw(orgnr) ],
        acdt_dttph => [ qw(org_num) ],
        acdt_dttpv => [ qw(org_num) ],
        acgd_empfun01 => [ qw(orgnr) ],
        acgd_organi01 => [ qw(orgnr) ],
        acib_acitaga => [ qw(aga_org_num) ],
        acib_acitarn => [ qw(arn_org_num) ],
        acib_acitbif => [ qw(bif_org_num) ],
        acib_acitbiv => [ qw(biv_org_num) ],
        acib_acitboa => [ qw(boa_org_num) ],
        acib_acitefi => [ qw(efi_org_num) ],
        acib_acitft2 => [ qw(ft2_org_num) ],
        acib_acitft3 => [ qw(ft3_org_num) ],
        acib_acitftg => [ qw(ftg_org_num) ],
        acib_acitgaf => [ qw(gaf_org_num) ],
        acib_acitkcn => [ qw(kcn_id_num kcn_modr_num kcn_dottr_num) ],
        acib_acitmin => [ qw(min_id_num min_modr_num min_dottr_num) ],
        acib_acitnon => [ qw(non_org_num) ],
        acib_acitntf => [ qw(ntf_org_num) ],
        acib_acitoms => [ qw(oms_org_num oms_org12_num) ],
        acib_acitver => [ qw(ver_org_num) ],
        acin_intr10 => [ qw(orgnr) ],
        acin_intr20 => [ qw(orgnr) ],
        acin_intr30 => [ qw(orgnr) ],
        acin_intr40 => [ qw(orgnr) ],
        acra_klient => [ qw(orgnr) ],
        acra_rapp => [ qw(orgnr) ],
        acra_ratssa => [ qw(orgnr12 orgnr) ],
        acra_ratssah => [ qw(orgnr12 orgnr) ],
        acra_uphi => [ qw(orgnr) ],
        actx_ftax => [ qw(orgnr) ],
        nsdb_sync => [ qw(ftg_org_num) ],
        nyckeltal => [ qw(org_num) ],
    },
    duns => {
        acdt_dttph => [ qw(dobnr_num) ],
        acdt_dttpv => [ qw(dobnr_num) ],
        acgd_empfun01 => [ qw(dunsnr) ],
        acgd_organi01 => [ qw(dunsnr) ],
        acib_acitarn => [ qw(arn_dunsnr_num) ],
        acib_acitkcn => [ qw(kcn_dobnr) ],
        acib_acitmin => [ qw(min_dobnr) ],
    },
    pnum => {
        acin_intr20 => [ qw(pnr) ],
        acin_intr40 => [ qw(pnr) ],
        acpr_prtpr => [ qw(pnr pnr12) ],
        acpr_prtprh => [ qw(pnr pnr12) ],
        actx_tax01 => [ qw(pnr pnr12) ],
        actx_tax02 => [ qw(pnr pnr12) ],
    },
    pname => {
        full => {
            acin_intr20 => [ qw(namn) ],
            acin_intr40 => [ qw(namn) ],
            acpr_prtpr => [ qw(namn) ],
            acpr_prtprh => [ qw(namn) ],
        },
        given_name => {
            acgd_empfun01 => [ qw(firstname) ],
            acpr_prtpr => [ qw(fnamn) ],
            acpr_prtprh => [ qw(fnamn) ],
        },
        surname => {
            acgd_empfun01 => [ qw(lastname) ],
            acpr_prtpr => [ qw(enamn) ],
            acpr_prtprh => [ qw(enamn) ],
        },
    },
    orgname => {
        full => {
            acib_acitbif => [ qw(bif_iregnamn bif_namn1) ],
            acib_acitefi => [ qw(efi_iregnamn efi_namn1 efi_namn2) ],
            acib_acitftg => [ qw(ftg_namn1 ftg_namn2 ftg_iregnamn) ],
            acib_acitgaf => [ qw(gaf_namn1 gaf_namn2) ],
            acin_intr40 => [ qw(namnas) ],
        },
        abbr => {
            acib_acitftg => [ qw(ftg_namn1_nrm) ],
            acib_acitgaf => [ qw(gaf_namn1_nrm) ],
        },
    },
    business_address => {
        street => {
            acib_acitarn => [ qw(arn_badr arn_padr) ],
            acib_acitefi => [ qw(efi_iadr) ],
            acib_acitftg => [ qw(ftg_iadr) ],
            acib_acitgaf => [ qw(gaf_iadr) ],
        },
        zip => {
            acib_acitarn => [ qw(arn_bpost_num arn_ppost_num) ],
            acib_acitefi => [ qw(efi_ipost_num) ],
            acib_acitftg => [ qw(ftg_ipost_num) ],
            acib_acitgaf => [ qw(gaf_ipost_num) ],
        },
        municipality => {
            acib_acitarn => [ qw(arn_bport arn_pport) ],
            acib_acitefi => [ qw(efi_iport) ],
            acib_acitftg => [ qw(ftg_iport) ],
            acib_acitgaf => [ qw(gaf_iport) ],
        },
        country => {
            acib_acitftg => [ qw(ftg_land_kod) ],
        },
    },
    private_address => {
        street => {
            acpr_prtpr => [ qw(fbf_gatuadress) ],
            acpr_prtprh => [ qw(fbf_gatuadress) ],
        },
        zip => {
            acpr_prtpr => [ qw(fbf_postnr) ],
            acpr_prtprh => [ qw(fbf_postnr) ],
        },
        municipality => {
            acpr_prtpr => [ qw(fbf_postort) ],
            acpr_prtprh => [ qw(fbf_postort) ],
        },
    },
);


# http://search.cpan.org/~gsar/perl-5.6.1/pod/perltootc.pod
# tri-natured: function, class method, or object method
sub _classobj {
    my $obclass = shift || __PACKAGE__;
    my $class   = ref($obclass) || $obclass;
    no strict "refs";   # to convert sym ref to real one
    return \%$class;
} 

for my $datum (keys %{ _classobj() } ) { 
    # turn off strict refs so that we can
    # register a method in the symbol table
    no strict "refs";       
    *$datum = sub {
        use strict "refs";
        my $self = shift->_classobj();
        $self->{$datum} = shift if @_;
        return $self->{$datum};
    }
}



1;