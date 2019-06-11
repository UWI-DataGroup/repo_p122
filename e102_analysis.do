** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e102_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Testing the Life Table process using BRB death dataseet (2016)

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
    log using "`logpath'\e102_analysis", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p122"

** ------------------------------------------------------------
** LIFE TABLE ANALYSIS
** ------------------------------------------------------------

** BRB. Death information 
use "`datapath'/version01/2-working/file08_who_deaths_lac.dta", clear

** Prepare the dataset
** We do the data preparation here - on a smaller dataset - before transfer to the FULL global dataset
** Keep selected years + descriptors
keep iso3 cause2015 causename sex age agegroup dths* low* upp* 
** Keep selected causes of death. We keep the following causes for now
** all NCDs                                        600
** Malignant neoplasms                             610
** diabetes mellitus                               800
** endocrine blood, immune disorders               810
** Cardiovascular diseases                         1100
** Rheumatic heart disease                         1110
** Hypertensive heart disease                      1120
** Ischaemic heart disease                         1130
** Stroke                                          1140
** Ischaemic stroke                                1141
** Haemorrhagic stroke                             1142
** Cardiomyopathy, myocarditis, endocarditis       1150
** Other circulatory diseases                      1160
** Respiratory diseases                            1170
** Chronic obstructive pulmonary disease           1180
** Asthma                                          1190
** Other respiratory diseases                      1200
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

** Country code 
label var iso3 "Country code"

** Cause of death group 
labmask cause2015, values(causename)
drop causename 
label var cause2015 "Cause of death grouping"
order cause2015, after(iso3) 

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
drop agegroup 

** Reshape YEAR wide to long
reshape long dths low upp , i(iso3 cause2015 sex age18 age20) j(year)

** Collapse DEATH DATAASET into 5-year age groups (18 groups)
** And merge with BRB population dataset
collapse (sum) dths low upp, by(iso3 year cause2015 sex age18)  
recode age18 2=0

** Deaths + Tempfile
label var dths "Number of deaths"
label var low "Number of deaths: Lower UI"
label var upp "Number of deaths: Upper UI"
sort iso3 cause2015 year sex age18 
order iso3 cause2015 year sex age18 dths low upp
tempfile deaths_lac
save `deaths_lac', replace 



** POPULATION file for BRB
** We want population in 18 five-year groups
use "`datapath'/version01/2-working/file09_un_pop_lac", clear 
sort unid year sex age18 
order unid year sex age18 pop  
tempfile pop_lac 
save `pop_lac', replace

** Need to merge iso3 ID numbers into this population file before we merge with DEATH dataset
use "`datapath'/version01/2-working/file03_country.dta", clear
rename cid iso3 
keep iso3 unid 
merge 1:m unid using `pop_lac'
** Drop all non LAC countries 
drop if _merge== 1
** Also drop the followig territories
**  254     French guiana
**  312     Guadeloupe
**  474     Martinique
**  531     Curacao 
**  533     Aruba
**  630     Puerto Rico
**  850     USVI
drop if _merge==2
drop _merge
save `pop_lac', replace

merge m:m iso3 year sex age18 using `deaths_lac'
sort iso3 year cause2015 sex age18 
order iso3 unid year cause2015 sex age18 pop dths low upp 
drop _merge

** Life Table 
**        _Rx           - Life table mortality rates, per 10^5 persons
**        _qx           - Probability of dying in interval
**        _dx           - Expected number of deaths in interval
**        _px           - Probability of surviving the interval
**        _lx           - Number of people alive at the beginning of the interval
**        _Lx           - Cumulative years lived through x
**        _Tx           - Total time lived beyond x
**        _ExpYL        - Expected years of life at age x
**        _Surv         - Survival probability
**        _SurvVar      - Greenwood variance for _Surv
**        _HRate        - Hazard rate
gen span=5
replace span = 1 if age18==85

** FOUR NCD groups
** Malignant neoplasms                             610
** diabetes mellitus                               800
** Cardiovascular diseases                         1100
** Respiratory diseases                            1170
keep if cause2015==610 | cause2015==800 | cause2015==1100 | cause2015==1170
collapse (sum) dths low upp (mean) pop2=pop span2=span, by(iso3 unid year sex age18)

** Dataset for entry to life table loop
tempfile lt_entry
save `lt_entry', replace

** CENTRAL AMERICA
** replace rid = 1 if   iso3=="AIA" | iso3=="ATG" | iso3=="ABW" | iso3=="BHS" | iso3=="BRB" | iso3=="BMU" | iso3=="BLZ" | iso3=="VGB"      /// Car
**        | iso3=="CYM" | iso3=="CUB" | iso3=="CUW" | iso3=="DMA" | iso3=="DOM" | iso3=="GRD" | iso3=="GUF" | iso3=="GUY"                  /// Car  
**        | iso3=="GLP" | iso3=="HTI" | iso3=="JAM" | iso3=="MTQ" | iso3=="MSR" | iso3=="PRI" | iso3=="KNA" | iso3=="LCA"                  /// Car  
**        | iso3=="VCT" | iso3=="SXM" | iso3=="SUR" | iso3=="TTO" | iso3=="TCA" | iso3=="VIR"                                              

** replace rid = 2 if iso3=="CRI" | iso3=="SLV" | iso3=="GTM" | iso3=="HND" | iso3=="NIC" | iso3=="PAN"                                    /// CA

** replace rid = 3 if iso3=="CAN" | iso3=="MEX" | iso3=="USA" | iso3=="ARG" | iso3=="BOL" | iso3=="BRA" | iso3=="CHL" |                    /// SA
**         iso3=="COL" | iso3=="ECU" | iso3=="FLK" | iso3=="PRY" | iso3=="PER" | iso3=="URY" | iso3=="VEN"                                 


local nam "USA CAN MEX"
local sa  "ARG BOL BRA CHL COL ECU PER PRY URY VEN"
local ca  "CRI GTM HND NIC PAN SLV "
local car  "ATG BHS BLZ BRB CUB DOM GRD GUY HTI JAM LCA SUR TTO VCT"

** Caribbean 
tempname post_q3070_car
postfile `post_q3070_car' rid str3 iso3 unid year sex q3070 using "`datapath'/version01/2-working/file100_q3070_car.dta", replace
foreach a of local car {
    forval b = 2000(1)2016 {
        forval c = 1(1)3 { 
            use `lt_entry', clear
            keep if iso3=="`a'" & year==`b' & sex==`c' 
            lifetabl, strata(age18) deaths(dths) pop(pop) ny(span) saving(lt) replace not
            keep iso3 unid age18 pop dths span _Rx _qx 
            gen prob = 1 - _qx
            keep if _n>=7 & _n<=14
            gen double product = prob[1]
            replace product = product[_n-1] * prob if _n > 1
            replace product = product[_N]
            gen q3070 = (1-product)*100 
            local est1 = q3070
            gen region = 1 
            post `post_q3070_car' (region) ("`a'") (unid) (`b') (`c') (`est1')
            }
        } 
    }
postclose `post_q3070_car'

** Central America
tempname post_q3070_ca
postfile `post_q3070_ca' rid str3 iso3 unid year sex q3070 using "`datapath'/version01/2-working/file100_q3070_ca.dta", replace
foreach a of local ca {
    forval b = 2000(1)2016 {
        forval c = 1(1)3 { 
            use `lt_entry', clear
            keep if iso3=="`a'" & year==`b' & sex==`c' 
            lifetabl, strata(age18) deaths(dths) pop(pop) ny(span) saving(lt) replace not
            keep iso3 unid age18 pop dths span _Rx _qx 
            gen prob = 1 - _qx
            keep if _n>=7 & _n<=14
            gen double product = prob[1]
            replace product = product[_n-1] * prob if _n > 1
            replace product = product[_N]
            gen q3070 = (1-product)*100 
            local est1 = q3070
            gen region = 2 
            post `post_q3070_ca' (region) ("`a'") (unid) (`b') (`c') (`est1')
            }
        } 
    }
postclose `post_q3070_ca'

** South America
tempname post_q3070_sa
postfile `post_q3070_sa' rid str3 iso3 unid year sex q3070 using "`datapath'/version01/2-working/file100_q3070_sa.dta", replace
foreach a of local sa {
    forval b = 2000(1)2016 {
        forval c = 1(1)3 { 
            use `lt_entry', clear
            keep if iso3=="`a'" & year==`b' & sex==`c' 
            lifetabl, strata(age18) deaths(dths) pop(pop) ny(span) saving(lt) replace not
            keep iso3 unid age18 pop dths span _Rx _qx 
            gen prob = 1 - _qx
            keep if _n>=7 & _n<=14
            gen double product = prob[1]
            replace product = product[_n-1] * prob if _n > 1
            replace product = product[_N]
            gen q3070 = (1-product)*100 
            local est1 = q3070
            gen region = 3 
            post `post_q3070_sa' (region) ("`a'") (unid) (`b') (`c') (`est1')
            }
        } 
    }
postclose `post_q3070_sa'

** North America
tempname post_q3070_nam
postfile `post_q3070_nam' rid str3 iso3 unid year sex q3070 using "`datapath'/version01/2-working/file100_q3070_nam.dta", replace
foreach a of local nam {
    forval b = 2000(1)2016 {
        forval c = 1(1)3 { 
            use `lt_entry', clear
            keep if iso3=="`a'" & year==`b' & sex==`c' 
            lifetabl, strata(age18) deaths(dths) pop(pop) ny(span) saving(lt) replace not
            keep iso3 unid age18 pop dths span _Rx _qx 
            gen prob = 1 - _qx
            keep if _n>=7 & _n<=14
            gen double product = prob[1]
            replace product = product[_n-1] * prob if _n > 1
            replace product = product[_N]
            gen q3070 = (1-product)*100 
            local est1 = q3070
            gen region = 4
            post `post_q3070_nam' (region) ("`a'") (unid) (`b') (`c') (`est1')
            }
        } 
    }
postclose `post_q3070_nam'

** Join the datasets
use "`datapath'/version01/2-working/file100_q3070_car.dta", clear 
append using "`datapath'/version01/2-working/file100_q3070_ca.dta" 
append using "`datapath'/version01/2-working/file100_q3070_sa.dta"
append using "`datapath'/version01/2-working/file100_q3070_nam.dta"
label define rid_ 1 "caribbean" 2 "central am" 3 "south am" 4 "north am", modify 
label values rid rid_ 
save "`datapath'/version01/2-working/file100_q3070_lac.dta", replace 
