** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e005_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading World Bank GDP (etc) data

    ** General algorithm set-up
    version 15
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
    local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p122"
    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p122

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\e005_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** ------------------------------------------------------------
** FILE 6 - WORLD BANK VARIABLES
** ------------------------------------------------------------
** Extracted from World Bank  (https://data.worldbank.org/indicator)
** Download Date: 8-JUN-2019
** Importation via the -wbopendata- software package

** METRIC 1. GNI, Atlas method (current US$)
** code: NY.GNP.ATLS.CD
** web: https://data.worldbank.org/indicator/NY.GNP.ATLS.CD
wbopendata, indicator(NY.GNP.ATLS.CD) clear long year(2000:2016)
tempfile wb_metric01
save `wb_metric01'

** METRIC 2. GNI per capita, Atlas method (current US$)
** code: NY.GNP.PCAP.CD
** web: https://data.worldbank.org/indicator/NY.GNP.PCAP.CD
wbopendata, indicator(NY.GNP.PCAP.CD) clear long year(2000:2016)
tempfile wb_metric02
save `wb_metric02'

** METRIC 3. Food production index (2004-2006 = 100)
** code: AG.PRD.FOOD.XD
** web: https://data.worldbank.org/indicator/AG.PRD.FOOD.XD
wbopendata, indicator(AG.PRD.FOOD.XD) clear long year(2000:2016)
tempfile wb_metric03
save `wb_metric03'

** METRIC 4. Surface area (squareed km)
** code: AG.SRF.TOTL.K2
** web: https://data.worldbank.org/indicator/AG.SRF.TOTL.K2
wbopendata, indicator(AG.SRF.TOTL.K2) clear long year(2000:2016)
tempfile wb_metric04
save `wb_metric04'

** METRIC 5. Agricultural land (% of land area)
** code: AG.LND.AGRI.ZS
** web: https://data.worldbank.org/indicator/AG.LND.AGRI.ZS
wbopendata, indicator(AG.LND.AGRI.ZS) clear long year(2000:2016)
tempfile wb_metric05
save `wb_metric05'

** METRIC 6. Population density (people per sq. km of land area)
** code: EN.POP.DNST
** web: https://data.worldbank.org/indicator/EN.POP.DNST
wbopendata, indicator(EN.POP.DNST) clear long year(2000:2016)
tempfile wb_metric06
save `wb_metric06'

** METRIC 7. Current health expenditure per capita (current US$)
** code: SH.XPD.CHEX.PC.CD
** web: https://data.worldbank.org/indicator/SH.XPD.CHEX.PC.CD
wbopendata, indicator(SH.XPD.CHEX.PC.CD) clear long year(2000:2016)
tempfile wb_metric07
save `wb_metric07'

** METRIC 8.  Current health expenditure (% of GDP)
** code: SH.XPD.CHEX.GD.ZS
** web: https://data.worldbank.org/indicator/SH.XPD.CHEX.GD.ZS
wbopendata, indicator(SH.XPD.CHEX.GD.ZS) clear long year(2000:2016)
tempfile wb_metric08
save `wb_metric08'

** METRIC 9  .Out-of-pocket expenditure (% of current health expenditure)
** code: SH.XPD.OOPC.CH.ZS
** web: https://data.worldbank.org/indicator/SH.XPD.OOPC.CH.ZS
wbopendata, indicator(SH.XPD.OOPC.CH.ZS) clear long year(2000:2016)
tempfile wb_metric09
save `wb_metric09'

** METRIC 10.  External health expenditure (% of current health expenditure)
** code: SH.XPD.EHEX.CH.ZS
** web: https://data.worldbank.org/indicator/SH.XPD.EHEX.CH.ZS
wbopendata, indicator(SH.XPD.EHEX.CH.ZS) clear long year(2000:2016)
tempfile wb_metric10
save `wb_metric10'

** METRIC 11. Physicians (per 1,000 people) 
** code: SH.MED.PHYS.ZS
** web: https://data.worldbank.org/indicator/SH.MED.PHYS.ZS
wbopendata, indicator(SH.MED.PHYS.ZS) clear long year(2000:2016)
tempfile wb_metric11
save `wb_metric11'

** METRIC 12. Nurses and midwives (per 1,000 people) 
** code: SH.MED.NUMW.P3
** web: https://data.worldbank.org/indicator/SH.MED.NUMW.P3
wbopendata, indicator(SH.MED.NUMW.P3) clear long year(2000:2016)
tempfile wb_metric12
save `wb_metric12'

** Joining the 12 files
use `wb_metric01', clear
merge m:m countrycode using `wb_metric02'
drop _merge 
merge m:m countrycode using `wb_metric03'
drop _merge 
merge m:m countrycode using `wb_metric04'
drop _merge 
merge m:m countrycode using `wb_metric05'
drop _merge 
merge m:m countrycode using `wb_metric06'
drop _merge 
merge m:m countrycode using `wb_metric07'
drop _merge 
merge m:m countrycode using `wb_metric08'
drop _merge 
merge m:m countrycode using `wb_metric09'
drop _merge 
merge m:m countrycode using `wb_metric10'
drop _merge 
merge m:m countrycode using `wb_metric11'
drop _merge 
merge m:m countrycode using `wb_metric12'
drop _merge 

rename ny_gnp_atls_cd gni 
rename ny_gnp_pcap_cd gni_pc 
rename ag_prd_food_xd fpi
rename ag_srf_totl_k2 land
rename ag_lnd_agri_zs land_agri
rename en_pop_dnst pop_den
rename sh_xpd_chex_pc_cd chexp_pc
rename sh_xpd_chex_gd_zs chexp  
rename sh_xpd_oopc_ch_zs oopexp 
rename sh_xpd_ehex_ch_zs extexp
rename sh_med_phys_zs phys 
rename sh_med_numw_p3 nurse
label var gni "METRIC 1. GNI, Atlas method (current US$)"
label var gni_pc "METRIC 2. GNI per capita, Atlas method (current US$)"
label var fpi "METRIC 3. Food production index (2004-2006 = 100)"
label var land "METRIC 4. Surface area (squareed km)"
label var land_agri "METRIC 5. Agricultural land (% of land area)"
label var pop_den "METRIC 6. Population density (people per sq. km of land area)"
label var chexp_pc "METRIC 7. Current health expenditure per capita (current US$)"
label var chexp "METRIC 8.  Current health expenditure (% of GDP)"
label var oopexp "METRIC 9  .Out-of-pocket expenditure (% of current health expenditure)"
label var extexp "METRIC 10.  External health expenditure (% of current health expenditure)"
label var phys "METRIC 11. Physicians (per 1,000 people) "
label var nurse "METRIC 12. Nurses and midwives (per 1,000 people) "

label data "Various data indicators from - from World Bank Open Data"
save "`datapath'/version01/2-working/file06_worldbank", replace
