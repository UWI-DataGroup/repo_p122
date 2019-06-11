** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e002_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading the WHO premature mortality dataset

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
    log using "`logpath'\e002_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** DATA PREPARATION OF PREMATURE MORTALITY

** ------------------------------------------------------------
** FILE 2 - PREMATURE MORTALITY FROM NCDs (30q70)
** ------------------------------------------------------------
** Extracted from WHO Observatory (https://apps.who.int/gho/data/view.main.2485)
** Download Date: 6-JUN-2019
import excel "`datapath'/version01/1-input/NCDMORT3070.xlsx", clear sheet("data-coded") first
drop PUBLISHSTATEcode NCDMORT3070string NCDMORT3070comment

** Year 
gen year = real(YEARcode) 
label var year "Year of 30q70 estimate"
drop YEARcode 

** Region code 
gen rid = .
replace rid = 1 if REGIONcode=="AFR"
replace rid = 2 if REGIONcode=="AMR"
replace rid = 3 if REGIONcode=="SEAR"
replace rid = 4 if REGIONcode=="EUR"
replace rid = 5 if REGIONcode=="EMR"
replace rid = 6 if REGIONcode=="WPR"
label define rid_ 1 "africa" 2 "americas" 3 "se asia" 4 "europe" 5 "eastern med" 6 "w pacific", modify 
label values rid rid_ 
label var rid "WHO region codes" 
drop REGIONcode 
order rid , after(year)

** Country code 
rename COUNTRYcode cid 
label var cid "ISO-3166 country code"

** Sex
gen sex = . 
replace sex = 1 if SEXcode=="FMLE"
replace sex = 2 if SEXcode=="MLE"
replace sex = 3 if SEXcode=="BTSX"
label define sex_ 1 "women" 2 "men" 3 "both", modify 
label values sex sex_ 
label var sex "Sex (women, men, both)"
drop SEXcode 
order sex , after(cid)

** 30q70 
rename NCDMORT3070numeric pmort70
label var pmort70 "Premature mortality from NCDs (30q70)" 
order pmort70, after(sex) 

** Save the analysis dataset 
save "`datapath'/version01/2-working/file02_pmort2000_2016.dta", replace


