** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e002_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading the Country CodesWHO premature mortality dataset

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

** ------------------------------------------------------------
** FILE 3 - COUNTRY CODES
** ------------------------------------------------------------
** Extracted from WHO Observatory (https://apps.who.int/gho/data/view.main.2485)
** Download Date: 6-JUN-2019
import excel "`datapath'/version01/1-input/NCDMORT3070.xlsx", clear sheet("Country") first
keep Code DisplayValue MORT WorldBankincomegroup

** Country ISO Code and name
** ISO codes are 3-digit alphanumeric codes unique to a country - there are no codes for world or region 
rename Code cid 
label var cid "ISO-3166 country codes"
order cid

** Country name 
rename DisplayValue country 
label var country "Country name" 
order country, after(cid)

** MORT - 4 digit coding to link with mortality database (I recall)
gen mid = real(MORT) 
label var mid "Mortality database country ID: 4-digit numeric code"
order mid, after(cid)
drop MORT 

** World Bank grouping from 2017 
gen wbg = .
replace wbg = 1 if WorldBankincomegroup == "Low income"
replace wbg = 2 if WorldBankincomegroup == "Lower middle income"
replace wbg = 3 if WorldBankincomegroup == "Upper middle income"
replace wbg = 4 if WorldBankincomegroup == "High income"
label define wbg_ 1 "wb_li" 2 "wb_lmi" 3 "wb_umi" 4 "wb_hi", modify 
label values wbg wbg_ 
label var wbg "World Bank income groups"
order wbg, after(mid) 
drop  WorldBankincomegroup
tempfile country_id
save `country_id', replace 

** NEXT, we add in 2-digit numeric codes, used by UN datasets
** Which allows me to join population data from UN WPP
import excel "`datapath'/version01/1-input/wikipedia-iso-country-codes.xlsx", clear sheet("wikipedia-iso-country-codes") first
drop  Alpha2code ISO31662
rename  Alpha3code cid 
rename  Numericcode unid 
label var unid "UN WPP country ID"
merge 1:1 cid using `country_id' 
keep if _merge==3 
drop _merge 
tempfile country_id2
save `country_id2', replace 

** NEXT, we add in country codes used by FAO datasets (!) 
** Which allows me to join FAO data
import excel "`datapath'/version01/1-input/country_code_linkage.xlsx", clear sheet("Sheet1") first
drop  shortname officialname iso2 unid undpid gaul
rename iso3 cid 
label var faoid "FAOSTAT country ID"
merge 1:1 cid using `country_id2' 
keep if _merge==3 
drop _merge 

** Save the analysis dataset 
save "`datapath'/version01/2-working/file03_country.dta", replace


/*
** ------------------------------------------------------------
** FILE 3 - COUNTRY and PREMATURE MORTALITY FROM NCDs (30q70)
** ------------------------------------------------------------
** Joining COUNTRY and PREMATURE MORTAITY files
merge 1:m cid using "`datapath'/version01/2-working/file02_pmort2000_2016.dta"
sort cid sex year 
drop _merge
save "`datapath'/version01/2-working/file02_file03.dta", replace
