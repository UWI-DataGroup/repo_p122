** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e001_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading the NCD CountDown 30q70 dataset

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
    log using "`logpath'\e001_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** DATA PREPARATION --> PREMATURE NCD MORTALITY (30q70)

** ------------------------------------------------------------
** FILE 1 - PREMATURE MORTALITY FROM NCDs (30q70)
** ------------------------------------------------------------
** Extracted from NCD CounDown (http://www.ncdcountdown.org/data-downloads-ncd4.html)
** Download Date: 6-JUN-2019
import delimited  "`datapath'/version01/1-input/Press_2018Sept12_v41 - web download v3.txt", clear 
drop country 

** Country ISO Code and name
** ISO codes are 3-digit alphanumeric codes unique to a country - there are no codes for world or region 
label var iso3 "ISO-3166 country codes"
order iso3

** Vital Registry Quality
gen vrq = . 
replace vrq = 1 if vitalregistrationdataquality == "Very Low"
replace vrq = 2 if vitalregistrationdataquality == "Low"
replace vrq = 3 if vitalregistrationdataquality == "Medium"
replace vrq = 4 if vitalregistrationdataquality == "High"
label define vrq_ 1 "very low" 2 "low" 3 "medium" 4 "high"
label values vrq vrq_
label var vrq "Vital Registry Quality"
drop vitalregistrationdataquality
order vrq, after(iso3)

** Region
encode region, gen(mrid)
label var mrid "Major Region ID: internal ID"
order mrid, after(iso3)
drop region 

** Year 
label var year "Year of estimate"

** Women 30q70 
rename femalemeanprobabilityofdyingbetw f70 
rename femaleprobabilityofdyingbetween3 f70_lo 
rename v8 f70_hi 
gen ftarget = . 
replace ftarget = 1 if femalesdgtarget34expectedtobemet == "Stagnating or deteriorating"
replace ftarget = 2 if femalesdgtarget34expectedtobemet == "Target met after 2040"
replace ftarget = 3 if femalesdgtarget34expectedtobemet == "Target met 2031 - 2040"
replace ftarget = 4 if femalesdgtarget34expectedtobemet == "Target met by 2030"
label define target_ 1 "stagnant" 2 "by 2040" 3 "2031-2040" 4 "by 2030"
label values ftarget target_
label var f70 "Women 30q70"
label var f70_lo "Women 30q70 UI LOW"
label var f70_hi "Women 30q70 UI HIGH"
label var ftarget "Women. SDG 3.4 target"
order f70 f70_lo f70_hi ftarget, after(year)
drop femalesdgtarget34expectedtobemet

** Men 30q70 
rename malemeanprobabilityofdyingbetwee m70 
rename maleprobabilityofdyingbetween30a m70_lo 
rename v12 m70_hi 
gen mtarget = . 
replace mtarget = 1 if malesdgtarget34expectedtobemet == "Stagnating or deteriorating"
replace mtarget = 2 if malesdgtarget34expectedtobemet == "Target met after 2040"
replace mtarget = 3 if malesdgtarget34expectedtobemet == "Target met 2031 - 2040"
replace mtarget = 4 if malesdgtarget34expectedtobemet == "Target met by 2030"
label values mtarget target_
label var m70 "Men 30q70"
label var m70_lo "Men 30q70 UI LOW"
label var m70_hi "Men 30q70 UI HIGH"
label var mtarget "Men. SDG 3.4 target"
order m70 m70_lo m70_hi mtarget, after(ftarget)
drop malesdgtarget34expectedtobemet

** Women 0q80
rename v14 f80 
rename femaleprobabilityofdyingbetweenb f80_lo 
rename v16 f80_hi 
label var f80 "Women 0q80"
label var f80_lo "Women 0q80 UI LOW"
label var f80_hi "Women 0q80 UI HIGH"

** Men 0q80
rename v17 m80 
rename maleprobabilityofdyingbetweenbir m80_lo 
rename v19 m80_hi 
label var m80 "Men 0q80"
label var m80_lo "Men 0q80 UI LOW"
label var m80_hi "Men 0q80 UI HIGH"

** Save the analysis dataset 
save "`datapath'/version01/2-working/file01_pmort2016.dta", replace
