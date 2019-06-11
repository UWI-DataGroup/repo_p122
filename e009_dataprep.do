** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e007_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	    6-JUN-2019
    //  algorithm task			    Reading UN population data for 2016, ready for Life Table test

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

** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - BOTH SEXES for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx", clear sheet("MEDIUM VARIANT") cellrange(a17:aa20743) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
** CENTRAL AMERICA (N=6)
** 188 {"region":"AMERICA","subregion":"Central America","iso3":"CRI","country":"Costa Rica"},
** 222 {"region":"AMERICA","subregion":"Central America","iso3":"SLV","country":"El Salvador"},
** 320 {"region":"AMERICA","subregion":"Central America","iso3":"GTM","country":"Guatemala"},
** 340 {"region":"AMERICA","subregion":"Central America","iso3":"HND","country":"Honduras"},
** 558 {"region":"AMERICA","subregion":"Central America","iso3":"NIC","country":"Nicaragua"},
** 591 {"region":"AMERICA","subregion":"Central America","iso3":"PAN","country":"Panama"},
** SOUTH AMERICA (N=14)
** 124 {"region":"AMERICA","subregion":"North America","iso3":"CAN","country":"Canada"},
** 484 {"region":"AMERICA","subregion":"North America","iso3":"MEX","country":"Mexico"},
** 840 {"region":"AMERICA","subregion":"North America","iso3":"USA","country":"United States of America"},
** 032 {"region":"AMERICA","subregion":"South America","iso3":"ARG","country":"Argentina"},
** 068 {"region":"AMERICA","subregion":"South America","iso3":"BOL","country":"Bolivia (Plurinational State of)"},
** 076 {"region":"AMERICA","subregion":"South America","iso3":"BRA","country":"Brazil"},
** 152 {"region":"AMERICA","subregion":"South America","iso3":"CHL","country":"Chile"},
** 170 {"region":"AMERICA","subregion":"South America","iso3":"COL","country":"Colombia"},
** 218 {"region":"AMERICA","subregion":"South America","iso3":"ECU","country":"Ecuador"},
** 238 {"region":"AMERICA","subregion":"South America","iso3":"FLK","country":"Falkland Islands (Malvinas)"},
** 600 {"region":"AMERICA","subregion":"South America","iso3":"PRY","country":"Paraguay"},
** 604 {"region":"AMERICA","subregion":"South America","iso3":"PER","country":"Peru"},
** 858 {"region":"AMERICA","subregion":"South America","iso3":"URY","country":"Uruguay"},
** 862 {"region":"AMERICA","subregion":"South America","iso3":"VEN","country":"Venezuela (Bolivarian Republic of)"},
** CARIBBEAN (N=30)
** (Note: Belize, Guyana, French Guiana, Suriname switched to Caribbean)
** 660 {"region":"AMERICA","subregion":"The Caribbean","iso3":"AIA","country":"Anguilla"},
** 028 {"region":"AMERICA","subregion":"The Caribbean","iso3":"ATG","country":"Antigua and Barbuda"},
** 533 {"region":"AMERICA","subregion":"The Caribbean","iso3":"ABW","country":"Aruba"},
** 044 {"region":"AMERICA","subregion":"The Caribbean","iso3":"BHS","country":"Bahamas"},
** 052 {"region":"AMERICA","subregion":"The Caribbean","iso3":"BRB","country":"Barbados"},
** 060 {"region":"AMERICA","subregion":"The Caribbean","iso3":"BMU","country":"Bermuda"},
** 084 {"region":"AMERICA","subregion":"Central America","iso3":"BLZ","country":"Belize"},
** 092 {"region":"AMERICA","subregion":"The Caribbean","iso3":"VGB","country":"British Virgin Islands"},
** 136 {"region":"AMERICA","subregion":"The Caribbean","iso3":"CYM","country":"Cayman Islands"},
** 192 {"region":"AMERICA","subregion":"The Caribbean","iso3":"CUB","country":"Cuba"},
** 531 {"region":"AMERICA","subregion":"The Caribbean","iso3":"CUW","country":"Curaçao"},
** 212 {"region":"AMERICA","subregion":"The Caribbean","iso3":"DMA","country":"Dominica"},
** 214 {"region":"AMERICA","subregion":"The Caribbean","iso3":"DOM","country":"Dominican Republic"},
** 308 {"region":"AMERICA","subregion":"The Caribbean","iso3":"GRD","country":"Grenada"},
** 254 {"region":"AMERICA","subregion":"South America","iso3":"GUF","country":"French Guiana"},
** 328 {"region":"AMERICA","subregion":"South America","iso3":"GUY","country":"Guyana"},
** 312 {"region":"AMERICA","subregion":"The Caribbean","iso3":"GLP","country":"Guadeloupe"},
** 332 {"region":"AMERICA","subregion":"The Caribbean","iso3":"HTI","country":"Haiti"},
** 388 {"region":"AMERICA","subregion":"The Caribbean","iso3":"JAM","country":"Jamaica"},
** 474 {"region":"AMERICA","subregion":"The Caribbean","iso3":"MTQ","country":"Martinique"},
** 500 {"region":"AMERICA","subregion":"The Caribbean","iso3":"MSR","country":"Montserrat"},
** 630 {"region":"AMERICA","subregion":"The Caribbean","iso3":"PRI","country":"Puerto Rico"},
** 659 {"region":"AMERICA","subregion":"The Caribbean","iso3":"KNA","country":"Saint Kitts and Nevis"},
** 662 {"region":"AMERICA","subregion":"The Caribbean","iso3":"LCA","country":"Saint Lucia"},
** 670 {"region":"AMERICA","subregion":"The Caribbean","iso3":"VCT","country":"Saint Vincent and the Grenadines"},
** 663 {"region":"AMERICA","subregion":"The Caribbean","iso3":"SXM","country":"Sint Maarten"},
** 740 {"region":"AMERICA","subregion":"South America","iso3":"SUR","country":"Suriname"},
** 780 {"region":"AMERICA","subregion":"The Caribbean","iso3":"TTO","country":"Trinidad and Tobago"},
** 796 {"region":"AMERICA","subregion":"The Caribbean","iso3":"TCA","country":"Turks and Caicos Islands"},
** 850 {"region":"AMERICA","subregion":"The Caribbean","iso3":"VIR","country":"United States Virgin Islands"},

keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA

drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year==2016

** Age group variables
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
rename W pop80
rename X pop85
rename Y pop90
rename Z pop95
rename AA pop100
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000
tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data16
save `data16',replace

** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - BOTH SEXES for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx", clear sheet("ESTIMATES") cellrange(a17:ab15923) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA
         
drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year>=2000 & year<=2015

** Age group variables
drop W
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
gen pop80 = real(X)
gen pop85 = real(Y)
gen pop90 = real(Z)
gen pop95 = real(AA) 
gen pop100 = real(AB) 
drop X Y Z AA AB 
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000
tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data_00_15
save `data_00_15',replace

** Append 2016 
append using `data16'

** Save Barbados dataset for testing the Life Table procedure
** Will then compare against WHO estimates
sort  unid year age 
label data "UN Population Data: Both sexes BRB "
gen sex = 3
save "`datapath'/version01/2-working/file09_un_pop_both_lac", replace








** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - FEMALE for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_3_ANNUAL_POPULATION_BY_AGE_FEMALE.xlsx", clear sheet("MEDIUM VARIANT") cellrange(a17:aa20743) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA

drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year==2016

** Age group variables
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
rename W pop80
rename X pop85
rename Y pop90
rename Z pop95
rename AA pop100
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000

tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data16
save `data16',replace

** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - BOTH SEXES for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_3_ANNUAL_POPULATION_BY_AGE_FEMALE.xlsx", clear sheet("ESTIMATES") cellrange(a17:ab15923) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA

drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year>=2000 & year<=2015

** Age group variables
drop W
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
gen pop80 = real(X)
gen pop85 = real(Y)
gen pop90 = real(Z)
gen pop95 = real(AA) 
gen pop100 = real(AB) 
drop X Y Z AA AB 
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000
tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data_00_15
save `data_00_15',replace

** Append 2016 
append using `data16'

** Save Barbados dataset for testing the Life Table procedure
** Will then compare against WHO estimates
sort  unid year age 
label data "UN Population Data: Female BRB "
gen sex = 1
save "`datapath'/version01/2-working/file09_un_pop_female_lac", replace





** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - MALE for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_2_ANNUAL_POPULATION_BY_AGE_MALE.xlsx", clear sheet("MEDIUM VARIANT") cellrange(a17:aa20743) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA

drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year==2016

** Age group variables
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
rename W pop80
rename X pop85
rename Y pop90
rename Z pop95
rename AA pop100
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000

tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data16
save `data16',replace

** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - BOTH SEXES for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Dataset (BOTH SEXES): WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
import excel using "`datapath'/version01/1-input/WPP2017_POP_F15_2_ANNUAL_POPULATION_BY_AGE_MALE.xlsx", clear sheet("ESTIMATES") cellrange(a17:ab15923) first
drop Index Variant Notes 

** Country ID. And restrict to Barbados for now 
rename Countrycode unid 
labmask unid, values(Regionsubregioncountryorar)
keep if  unid==660 | unid==28 | unid==533 | unid==44 | unid==52 | unid==60 | unid==84 | unid==92                /// Car
       | unid==136 | unid==192 | unid==531 | unid==212 | unid==214 | unid==308 | unid==254 | unid==328          /// Car  
       | unid==312 | unid==332 | unid==388 | unid==474 | unid==500 | unid==630 | unid==659 | unid==662          /// Car  
       | unid==670 | unid==663 | unid==740 | unid==780 | unid==796 | unid==850                                  /// Car
       | unid==188 | unid==222 | unid==320 | unid==340 | unid==558 | unid==591                                  /// CA
       | unid==124 | unid==484 | unid==840 | unid==32 | unid==68 | unid==76 | unid==152 |                       /// SA
         unid==170 | unid==218 | unid==238 | unid==600 | unid==604 | unid==858 | unid==862                      /// SA

drop Regionsubregioncountryorar

** Year
rename Referencedateasof1July year 
keep if year>=2000 & year<=2015

** Age group variables
drop W
rename G pop0
rename H pop5
rename I pop10
rename J pop15
rename K pop20
rename L pop25
rename M pop30
rename N pop35
rename O pop40
rename P pop45
rename Q pop50
rename R pop55
rename S pop60
rename T pop65
rename U pop70
rename V pop75
gen pop80 = real(X)
gen pop85 = real(Y)
gen pop90 = real(Z)
gen pop95 = real(AA) 
gen pop100 = real(AB) 
drop X Y Z AA AB 
reshape long pop, i(unid year) j(age18)
replace pop = pop*1000
tempfile pop1 
save `pop1'

** Create 18 age groups
recode age18 90 95 100 = 85
collapse (sum) pop, by(unid year age18)

** Save for merging into historical years 
tempfile data_00_15
save `data_00_15',replace

** Append 2016 
append using `data16'

** Save Barbados dataset for testing the Life Table procedure
** Will then compare against WHO estimates
sort  unid year age 
label data "UN Population Data: Male BRB "
gen sex = 2
save "`datapath'/version01/2-working/file09_un_pop_male_lac", replace


** JOINING DATASETS TO CREATE BOTH, FEMALE< MALE IN SAME DATASET
use "`datapath'/version01/2-working/file09_un_pop_both_lac", clear
append using "`datapath'/version01/2-working/file09_un_pop_female_lac"
append using "`datapath'/version01/2-working/file09_un_pop_male_lac"
label define sex_ 1 "women" 2 "men" 3 "both", modify
label values sex sex_ 
label var sex "Sex: Women, Men, Both"
label data "UN Population Data: Female, Male, Both Sexes for LAC"
save "`datapath'/version01/2-working/file09_un_pop_lac", replace

