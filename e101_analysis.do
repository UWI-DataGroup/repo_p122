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

** TABLE 1. LAC Countries and sub-Regions in 2016
** Table to introduce the XX countries by sub-region
** METRICS
**      - Population
**      - Percentage of world population
**      - Number of NCD deaths
**      - Percentage of world NCD deaths
**      - 30q70 in 2016
**      - 30q70 change since 2000

