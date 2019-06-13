** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e007_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading WHO Death data for 2000-2016, ready for Life Table test

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
    log using "`logpath'\e007_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do
/*
** GRAB ISO-3 CODES for LAC countries
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_btsx.csv", clear

** CENTRAL AMERICA (N=6)
** {"region":"AMERICA","subregion":"Central America","iso3":"CRI","country":"Costa Rica"},
** {"region":"AMERICA","subregion":"Central America","iso3":"SLV","country":"El Salvador"},
** {"region":"AMERICA","subregion":"Central America","iso3":"GTM","country":"Guatemala"},
** {"region":"AMERICA","subregion":"Central America","iso3":"HND","country":"Honduras"},
** {"region":"AMERICA","subregion":"Central America","iso3":"NIC","country":"Nicaragua"},
** {"region":"AMERICA","subregion":"Central America","iso3":"PAN","country":"Panama"},
** SOUTH AMERICA (N=14)
** {"region":"AMERICA","subregion":"North America","iso3":"CAN","country":"Canada"},
** {"region":"AMERICA","subregion":"North America","iso3":"MEX","country":"Mexico"},
** {"region":"AMERICA","subregion":"North America","iso3":"USA","country":"United States of America"},
** {"region":"AMERICA","subregion":"South America","iso3":"ARG","country":"Argentina"},
** {"region":"AMERICA","subregion":"South America","iso3":"BOL","country":"Bolivia (Plurinational State of)"},
** {"region":"AMERICA","subregion":"South America","iso3":"BRA","country":"Brazil"},
** {"region":"AMERICA","subregion":"South America","iso3":"CHL","country":"Chile"},
** {"region":"AMERICA","subregion":"South America","iso3":"COL","country":"Colombia"},
** {"region":"AMERICA","subregion":"South America","iso3":"ECU","country":"Ecuador"},
** {"region":"AMERICA","subregion":"South America","iso3":"FLK","country":"Falkland Islands (Malvinas)"},
** {"region":"AMERICA","subregion":"South America","iso3":"PRY","country":"Paraguay"},
** {"region":"AMERICA","subregion":"South America","iso3":"PER","country":"Peru"},
** {"region":"AMERICA","subregion":"South America","iso3":"URY","country":"Uruguay"},
** {"region":"AMERICA","subregion":"South America","iso3":"VEN","country":"Venezuela (Bolivarian Republic of)"},
** CARIBBEAN (N=30)
** (Note: Belize, Guyana, French Guiana, Suriname switched to Caribbean)
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"AIA","country":"Anguilla"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"ATG","country":"Antigua and Barbuda"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"ABW","country":"Aruba"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"BHS","country":"Bahamas"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"BRB","country":"Barbados"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"BMU","country":"Bermuda"},
** {"region":"AMERICA","subregion":"Central America","iso3":"BLZ","country":"Belize"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"VGB","country":"British Virgin Islands"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"CYM","country":"Cayman Islands"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"CUB","country":"Cuba"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"CUW","country":"Curaçao"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"DMA","country":"Dominica"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"DOM","country":"Dominican Republic"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"GRD","country":"Grenada"},
** {"region":"AMERICA","subregion":"South America","iso3":"GUF","country":"French Guiana"},
** {"region":"AMERICA","subregion":"South America","iso3":"GUY","country":"Guyana"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"GLP","country":"Guadeloupe"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"HTI","country":"Haiti"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"JAM","country":"Jamaica"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"MTQ","country":"Martinique"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"MSR","country":"Montserrat"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"PRI","country":"Puerto Rico"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"KNA","country":"Saint Kitts and Nevis"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"LCA","country":"Saint Lucia"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"VCT","country":"Saint Vincent and the Grenadines"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"SXM","country":"Sint Maarten"},
** {"region":"AMERICA","subregion":"South America","iso3":"SUR","country":"Suriname"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"TTO","country":"Trinidad and Tobago"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"TCA","country":"Turks and Caicos Islands"},
** {"region":"AMERICA","subregion":"The Caribbean","iso3":"VIR","country":"United States Virgin Islands"},

keep if  iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"      /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"      /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                  /// Car
       | iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                  /// CA
       | iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                  /// SA
         iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                     /// SA

** Also label the sub-regions here 
gen rid = .
replace rid = 1 if   iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"                  /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"                  /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                              /// Car

replace rid = 2 if iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                    /// CA

replace rid = 3 if iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                    /// SA
        iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                                 /// SA

label data "WHO Death Data: BOTH SEXES LAC"
save "`datapath'/version01/2-working/file08_who_deaths_both_lac", replace



** REPEATING FOR FEMALE SEX 
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_fmle.csv", clear
keep if  iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"      /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"      /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                  /// Car
       | iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                  /// CA
       | iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                  /// SA
        iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                     

** Also label the sub-regions here 
gen rid = .
replace rid = 1 if   iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"                  /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"                  /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                              

replace rid = 2 if iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                    /// CA

replace rid = 3 if iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                    /// SA
        iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                                 

label data "WHO Death Data: Female LAC"
save "`datapath'/version01/2-working/file08_who_deaths_female_lac", replace


** REPEATING FOR MALE SEX 
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_mle.csv", clear
keep if  iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"      /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"      /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                  /// Car
       | iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                  /// CA
       | iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                  /// SA
        iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                     
** Also label the sub-regions here 
gen rid = .
replace rid = 1 if   iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
       | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"                  /// Car  
       | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"                  /// Car  
       | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                              

replace rid = 2 if iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                    /// CA

replace rid = 3 if iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                    /// SA
        iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                                 

label data "WHO Death Data: Male LAC"
save "`datapath'/version01/2-working/file08_who_deaths_male_lac", replace

** JOINING DATASETS TO CREATE BOTH, FEMALE< MALE IN SAME DATASET
use "`datapath'/version01/2-working/file08_who_deaths_female_lac", clear
append using "`datapath'/version01/2-working/file08_who_deaths_male_lac"
append using "`datapath'/version01/2-working/file08_who_deaths_both_lac"
rename sex t1 
gen sex = 1 if t1=="FMLE"
replace sex = 2 if t1=="MLE"
replace sex = 3 if t1=="BTSX"
label define sex_ 1 "women" 2 "men" 3 "both", modify
label values sex sex_ 
label var sex "Sex: Women, Men, Both"
drop t1 
label data "WHO Death Data: Female, Male, Both Sexes for LAC"
save "`datapath'/version01/2-working/file08_who_deaths_lac", replace




** ------------------------------------------------------------
** FILE 8 -   WHO DEATH DATA - for entry into life tables 
**            BARBADOS ONLY
** ------------------------------------------------------------
** Extracted manually from WHO website (https://www.who.int/healthinfo/global_burden_disease/estimates/en/)
** Download Date: 6-JUN-2019
** EXTRACTED FOLDER: ghe2016_deaths_country_btsx
** Dataset (BOTH SEXES): ghe2016_deaths_country_btsx.csv
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_btsx.csv", clear
** Save Barbados dataset for testing the Life Table procedure
** Will then compare against WHO estimates
keep if iso3=="BRB"
label data "WHO Death Data: both sexes BRB "
save "`datapath'/version01/2-working/file08_who_deaths_both_brb", replace
** FEMALE
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_fmle.csv", clear
keep if iso3=="BRB"
label data "WHO Death Data: Female BRB"
save "`datapath'/version01/2-working/file08_who_deaths_female_brb", replace
** MALE 
import delimited using "`datapath'/version01/1-input/ghe2016_deaths_country_mle.csv", clear
keep if iso3=="BRB"
label data "WHO Death Data: Male BRB"
save "`datapath'/version01/2-working/file08_who_deaths_male_brb", replace

** JOINING DATASETS TO CREATE BOTH, FEMALE< MALE IN SAME DATASET
use "`datapath'/version01/2-working/file08_who_deaths_female_brb", clear
append using "`datapath'/version01/2-working/file08_who_deaths_male_brb"
append using "`datapath'/version01/2-working/file08_who_deaths_both_brb"
rename sex t1 
gen sex = 1 if t1=="FMLE"
replace sex = 2 if t1=="MLE"
replace sex = 3 if t1=="BTSX"
label define sex_ 1 "women" 2 "men" 3 "both", modify
label values sex sex_ 
label var sex "Sex: Women, Men, Both"
drop t1 
label data "WHO Death Data: Female, Male, Both Sexes for BRB"
save "`datapath'/version01/2-working/file08_who_deaths_brb", replace





*/


** The world 
** Number of premature deaths
import excel using  "`datapath'/version01/1-input/ghe2016_deaths_region_btsx.xlsx", clear first sheet("ghe2016_deaths_region_btsx")
keep if regtype=="world"
#delimit ;
    keep if cause2015==0    |
            cause2015==600  |
            cause2015==610  |
            cause2015==800  |
            cause2015==810  |
            cause2015==1100 |
            cause2015==1110 |
            cause2015==1120 |
            cause2015==1130 |
            cause2015==1140 |
            cause2015==1141 |
            cause2015==1142 |
            cause2015==1150 |
            cause2015==1160 |
            cause2015==1170 |
            cause2015==1180 |
            cause2015==1190 |
            cause2015==1200;
#delimit cr 

** Cause of death group 
labmask cause2015, values(causename)
label var cause2015 "Cause of death grouping"
order cause2015

** Sex
label var sex "Sex: Women, Men, Both"

** Age
labmask age, values(agegroup)
rename age age20 
label var age20 "Age group: 20 age groups incl. infants"
order age20, after(sex)
gen age18 = age20 
recode age18 0 1 = 2
order age18, after(age20)
label var age18 "Age group: 18 five-year age groups "

keep cause2015 causename sex age18 age20 agegroup dths* low* upp* 
keep if age18>=30 & age18 <=65
keep if cause2015==610 | cause2015==800 | cause2015==1100 | cause2015==1170

collapse (sum) dths2016 low2016 upp2016, by(sex) 
