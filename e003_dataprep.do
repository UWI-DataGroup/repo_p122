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

** DATA PREPARATION OF COUNTRY POPULATION (2000 to 2015)

** ------------------------------------------------------------
** FILE 4 - POPULATION
** ------------------------------------------------------------
** Extracted from UN World Populatio Prospects (WEB ADDRESS)
** Download Date: 7-JUN-2019
** import excel "`datapath'/version01/1-input/NCDMORT3070.xlsx", clear sheet("data-coded") first

