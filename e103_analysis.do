** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e103_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    30q70 from Life Table Analysis (2000 to 2016)

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

** Regional estimates
use "`datapath'/version01/2-working/file100_q3070_region.dta", clear 
label define rid_ 1 "caribbean" 2 "c america" 3 "s america" 4 "n america"
label values rid rid_ 

** LAC
use "`datapath'/version01/2-working/file100_q3070_region2.dta", clear
tabdisp rid year if (year==2000 | year==2016) & sex==3, c(q3070) format(%9.1f)
                                                                                                             