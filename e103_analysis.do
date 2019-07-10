** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e103_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Table 1 Statistics

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
    log using "`logpath'\e103_analysis", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** TABLE 1.
** We load the 30q70 dataset created in e102_analysis.do
** Which presents 30q70 for LAC countries between 2000 and 2016

** We are first interested in 30q70 in 2000 and 2016
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear
** Caribbean
tabdisp iso3 year if (year==2000 | year==2016) & rid==1 & sex==3, c(q3070) format(%9.1f)
** Central America
tabdisp iso3 year if (year==2000 | year==2016) & rid==2 & sex==3, c(q3070) format(%9.1f)
** South America
tabdisp iso3 year if (year==2000 | year==2016) & rid==3 & sex==3, c(q3070) format(%9.1f)
** North America
tabdisp iso3 year if (year==2000 | year==2016) & rid==4 & sex==3, c(q3070) format(%9.1f)
** LAC REGION + various sub-region variants
use "`datapath'/version01/2-working/file100_q3070_region_various.dta", clear
tabdisp rid year if (year==2000 | year==2016) & sex==3, c(q3070) format(%9.1f)


** Population (+ various sub-regional variants)
**use "`datapath'/version01/2-working/file09_un_pop_lac", clear
use "`datapath'/version01/2-working/file101_pop_country.dta", clear
label define rid_ 1 "caribbean" 2 "central am" 3 "south am" 4 "north am" 5 "LAC w/ NA" 6 "CA + SA" 7 "CA w/ MEX" 8 "LAC", modify 
label values rid rid_ 
keep if year==2016 & sex==3
** Country populations
collapse (sum) pop2 dths low upp , by(rid iso3 unid)
** Format population to be per 1000 remove Engineering format
gen pop1000 = pop2/1000
format pop2 %12.0fc

** Population for each of the THREE sub-regions
** Individual sub-regions 
preserve
    collapse (sum) pop2 , by(rid)
    tabdisp rid , c(pop2) format(%9.0fc)
restore
** CA and SA combined
preserve
    recode rid 2 3 = 6
    collapse (sum) pop2 , by(rid)
    tabdisp rid , c(pop2) format(%9.0fc)
restore
** CA, SA, CAR combined
preserve
    recode rid 1 2 3 = 8
    collapse (sum) pop2 , by(rid)
    tabdisp rid , c(pop2) format(%9.0fc)
restore

** Number of premature deaths by country
use "`datapath'/version01/2-working/file101_pop_country.dta", clear
preserve
    keep if age18>=30 & age18<=65
    keep if year==2016 & sex==3
    collapse (sum) pop2 dths low upp , by(rid iso3 unid)
    ** Caribbean 
    tabdisp iso3 if rid==1, c(dths) format(%9.1f)
    tabdisp iso3 if rid==2 | rid==3, c(dths) format(%9.1f)
restore

** Premature deaths in Caribbean
preserve
    keep if age18>=30 & age18<=65
    keep if year==2016 & sex==3
    keep if rid == 1
    collapse (sum) pop2 dths low upp , by(rid)
    ** Caribbean 
    tabdisp rid if rid==1, c(dths) format(%9.1f)
restore

** Premature deaths in CA + SA
preserve
    keep if age18>=30 & age18<=65
    keep if year==2016 & sex==3
    keep if rid == 2 | rid==3
    recode rid 3=2
    collapse (sum) pop2 dths low upp , by(rid)
    ** Caribbean 
    tabdisp rid if rid==2, c(dths) format(%9.1f)
restore

** Premature deaths in CAR + CA + SA
preserve
    keep if age18>=30 & age18<=65
    keep if year==2016 & sex==3
    keep if rid==1 | rid == 2 | rid==3
    recode rid 1 2 3 = 2
    collapse (sum) pop2 dths low upp , by(rid)
    ** Caribbean 
    tabdisp rid if rid==2, c(dths) format(%9.1f)
restore


** Country populations
keep if year==2016
keep if sex==3
collapse (sum) pop2, by(rid iso3 unid year sex)
format pop2 %12.0f
recode rid 3=2
sort rid iso3 
