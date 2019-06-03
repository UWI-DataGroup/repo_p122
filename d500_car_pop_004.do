** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\a054_car_pop_004, replace

**  GENERAL DO-FILE COMMENTS
**  program:      a054_car_pop_004.do
**  project:      
**  author:       HAMBLETON \ 13-SEP-2015
**  task:         
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

use "data\input\who_md\pop_aging\carib_pop_002", clear
sort cidun year sex ag_start
keep if year>=1990 & year<=2012 


** Merge with age range extremes from UN WPP (DB2)
merge 1:1 cidun year sex ag_start using "data\input\who_md\pop_aging\carib_pop_003"
sort cidun year sex ag_start

** Cleaning
drop ag
replace ag_span = 1 if ag_start==0
replace ag_span = 4 if ag_start==1
replace ag_span = . if ag_start==85

drop _merge PopMale PopFemale

** Completing INVARIANT vectors after data merge
** Fill cid
by cidun: egen cid1 = min(cid)
replace cid = cid1 if cid==.
drop cid1

** Fill population 1990
bysort cidun sex: egen y1990_1 = min(y1990)
replace y1990 = y1990_1 if y1990==.
drop y1990_1
** Fill population 1991
bysort cidun sex: egen y1991_1 = min(y1991)
replace y1991 = y1991_1 if y1991==.
drop y1991_1
** Fill population 1992
bysort cidun sex: egen y1992_1 = min(y1992)
replace y1992 = y1992_1 if y1992==.
drop y1992_1
** Fill population 1993
bysort cidun sex: egen y1993_1 = min(y1993)
replace y1993 = y1993_1 if y1993==.
drop y1993_1
** Fill population 1994
bysort cidun sex: egen y1994_1 = min(y1994)
replace y1994 = y1994_1 if y1994==.
drop y1994_1
** Fill population 1995
bysort cidun sex: egen y1995_1 = min(y1995)
replace y1995 = y1995_1 if y1995==.
drop y1995_1
** Fill population 1996
bysort cidun sex: egen y1996_1 = min(y1996)
replace y1996 = y1996_1 if y1996==.
drop y1996_1
** Fill population 1997
bysort cidun sex: egen y1997_1 = min(y1997)
replace y1997 = y1997_1 if y1997==.
drop y1997_1
** Fill population 1998
bysort cidun sex: egen y1998_1 = min(y1998)
replace y1998 = y1998_1 if y1998==.
drop y1998_1
** Fill population 1999
bysort cidun sex: egen y1999_1 = min(y1999)
replace y1999 = y1999_1 if y1999==.
drop y1999_1
** Fill population 2000
bysort cidun sex: egen y2000_1 = min(y2000)
replace y2000 = y2000_1 if y2000==.
drop y2000_1
** Fill population 2001
bysort cidun sex: egen y2001_1 = min(y2001)
replace y2001 = y2001_1 if y2001==.
drop y2001_1
** Fill population 2002
bysort cidun sex: egen y2002_1 = min(y2002)
replace y2002 = y2002_1 if y2002==.
drop y2002_1
** Fill population 2003
bysort cidun sex: egen y2003_1 = min(y2003)
replace y2003 = y2003_1 if y2003==.
drop y2003_1
** Fill population 2004
bysort cidun sex: egen y2004_1 = min(y2004)
replace y2004 = y2004_1 if y2004==.
drop y2004_1
** Fill population 2005
bysort cidun sex: egen y2005_1 = min(y2005)
replace y2005 = y2005_1 if y2005==.
drop y2005_1
** Fill population 2006
bysort cidun sex: egen y2006_1 = min(y2006)
replace y2006 = y2006_1 if y2006==.
drop y2006_1
** Fill population 2007
bysort cidun sex: egen y2007_1 = min(y2007)
replace y2007 = y2007_1 if y2007==.
drop y2007_1
** Fill population 2008
bysort cidun sex: egen y2008_1 = min(y2008)
replace y2008 = y2008_1 if y2008==.
drop y2008_1
** Fill population 2009
bysort cidun sex: egen y2009_1 = min(y2009)
replace y2009 = y2009_1 if y2009==.
drop y2009_1
** Fill population 2010
bysort cidun sex: egen y2010_1 = min(y2010)
replace y2010 = y2010_1 if y2010==.
drop y2010_1
** Fill population 2011
bysort cidun sex: egen y2011_1 = min(y2011)
replace y2011 = y2011_1 if y2011==.
drop y2011_1
** Fill population 2012
bysort cidun sex: egen y2012_1 = min(y2012)
replace y2012 = y2012_1 if y2012==.
drop y2012_1

** REPLACE with new population values
gen pop1 = pop
replace pop1 = p if p<.

** Correct the totals from 60+ onwards
sort cidun year sex ag_start
gen pop2 = pop1
replace pop2 = pop2 - pop2[_n+1] if ag_start==60
replace pop2 = pop2 - pop2[_n+1] if ag_start==65
replace pop2 = pop2 - pop2[_n+1] if ag_start==70
replace pop2 = pop2 - pop2[_n+1] if ag_start==75
replace pop2 = pop2 - pop2[_n+1] if ag_start==80
drop if ag_start>=90

** Check totals
bysort cid year sex: egen pop_check = sum(pop2)
drop pop pop1 p y1990 y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 ///
				y2000 y2001 y2002 y2003 y2004 y2005 y2006 y2007 y2008 y2009 y2010 y2011 y2008 y2012 pop_check
rename pop2 pop
rename ag_start ag
replace pop = round(pop)

** Revamping age to match the US Stanadard population for age-standardisation
** 11 groups
** 0-1, 1-4, 5-14, 15-24, 25-34, 35-44, 45-54, 55-64, 65-74, 75,84, 85+
gen age11 = .
replace age11 = 1 if ag==0
replace age11 = 2 if ag==1
replace age11 = 3 if ag==5 | ag==10
replace age11 = 4 if ag==15 | ag==20
replace age11 = 5 if ag==25 | ag==30
replace age11 = 6 if ag==35 | ag==40
replace age11 = 7 if ag==45 | ag==50
replace age11 = 8 if ag==55 | ag==60
replace age11 = 9 if ag==65 | ag==70
replace age11 = 10 if ag==75 | ag==80
replace age11 = 11 if ag==85 

** Labelling age
label define age11	1 "0-1"		///
					2 "1-4"		///
					3 "5-14"		///
					4 "15-24"		///
					5 "25-34"		///
					6 "35-44"		///
					7 "45-54"		///
					8 "55-64"		///
					9 "65-74"		///
					10 "75-84"		///
					11 "85+", modify
label values age11 age11			
label var age11 "11 Age groups"

** Note that this analysis DOES stratify by sex
collapse (sum) pop, by(cid cidun year sex age11)
bysort cid year sex: egen poptot = sum(pop)

** Keep all 20 countries
keep if 				cid==2010 | cid==2025 |					///
						cid==2030 | cid==2040 | cid==2045 |		///
						cid==2150 | cid==2170 |					///
						cid==2210 | cid==2230 | cid==2240 |		///
						cid==2260 | cid==2270 | cid==2290 | 	///
						cid==2300 | cid==2380 |					///
						cid==2400 | 							///
						cid==2420 | cid==2430 | cid==2440 |		///
						cid==2455 
sort cid year sex age11
label data "Final UN population dataset for merging with WHO death data"
tempfile women_men both
save `women_men', replace

** Collapse for Women + Men combined total
collapse (sum) pop poptot, by(cid cidun year age11)
gen sex = 3
save `both', replace

use `women_men', clear
append using `both'

sort cid cidun year sex age11
save "data\input\who_md\pop_aging\carib_pop_004", replace
