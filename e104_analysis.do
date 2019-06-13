** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e104_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Average Annual Change in 30q70 between 2000 and 2016

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
    log using "`logpath'\e104_analysis", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
keep if sex==3
keep if iso3=="GTM"

** Average annual change between 2000 and 2016
** Load up the 30q70 dataset (with data from between 2000 and 2016)
local nam "USA CAN MEX"
local sa  "ARG BOL BRA CHL COL ECU PER PRY URY VEN"
local ca  "CRI GTM HND NIC PAN SLV "
local car  "ATG BHS BLZ BRB CUB DOM GRD GUY HTI JAM LCA SUR TTO VCT"
local sa_ca  "ARG BOL BRA CHL COL CRI ECU SLV GTM HND NIC PAN PRY PER URY VEN"
local ca  " "

** CARIBBEAN
tempname change01 
postfile `change01' rid str3 iso3 unid sex q3070 ac using "`datapath'/version01/2-working/file102_change.dta", replace
foreach a of local car {
    use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
    keep if iso3=="`a'"
    keep if sex==3 
    regress q3070 year if year>=2000
    matrix coeff = e(b)
    local coeff = coeff[1,1]
    ** % annual change
    keep if year==2016
    gen change = (`coeff'/q3070)*100
    local change = change 
    post `change01' (rid) ("`a'") (unid) (sex) (q3070) (`change')
}
postclose `change01'
use  "`datapath'/version01/2-working/file102_change.dta", clear
** years to a 30% decrease
replace ac = ac*-1 
gen time = 30/ac

** CENTRAL AMERICA and SOUTH AMERICA
tempname change02
postfile `change02' rid str3 iso3 unid sex q3070 ac using "`datapath'/version01/2-working/file102_change2.dta", replace
foreach a of local sa_ca {
    use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
    keep if iso3=="`a'"
    keep if sex==3 
    regress q3070 year if year>=2000
    matrix coeff = e(b)
    local coeff = coeff[1,1]
    ** % annual change
    keep if year==2016
    gen change = (`coeff'/q3070)*100
    local change = change 
    post `change02' (rid) ("`a'") (unid) (sex) (q3070) (`change')
}
postclose `change02'

use  "`datapath'/version01/2-working/file102_change.dta", clear
append using "`datapath'/version01/2-working/file102_change2.dta"
** years to a 30% decrease
replace ac = ac*-1 
gen time = 30/ac
tabdisp iso3 if rid==1 , c(ac) format(%9.1f)
tabdisp iso3 if rid==2|rid==3 , c(ac) format(%9.1f)
