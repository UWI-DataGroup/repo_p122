** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version04"
log using logfiles\a054_barcharts, replace

**  GENERAL DO-FILE COMMENTS
**  program:      a054_barcharts.do
**  project:      
**  author:       HAMBLETON \ 2-NOV-2014
**  task:         Mortality rates in the Caribbean 
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200




** Caribbean data
tempfile car
use "data\result\car_003\caribbean_data", clear
gen race=1
rename cid loc
rename rateadj2000 i2000
rename rateadj2009 i2009
drop deaths* crude* tot* p2000 p2009
order loc race sex cod i2000 i2009 pchange change
save `car', replace

** US data, and appending the Caribbean data
use "data\result\us_001\us_data", clear
rename state loc
rename measure cod
drop c2000 c2009 ill* iul* ise* pop* deaths*
order loc race sex cod i2000 i2009 pchange
append using `car'

** Labelling variables
#delimit ;
label define loc 
			09      "Connecticut"
			23      "Maine"
			25      "Massachusetts"
			33      "New Hampshire"
			34      "New Jersey"
			36      "New York"
			42      "Pennsylvania"
			44      "Rhode Island"
			50      "Vermont"
			17      "Illinois"
			18      "Indiana"
			19      "Iowa"
			20      "Kansas"
			26      "Michigan"
			27      "Minnesota"
			29      "Missouri"
			31      "Nebraska"
			38      "North Dakota"
			39      "Ohio"
			46      "South Dakota"
			55      "Wisconsin"
			01      "Alabama"
			05      "Arkansas"
			10      "Delaware"
			11      "District of Columbia"
			12      "Florida"
			13      "Georgia"
			21      "Kentucky"
			22      "Louisiana"
			24      "Maryland"
			28      "Mississippi"
			37      "North Carolina"
			40      "Oklahoma"
			45      "South Carolina"
			47      "Tennessee"
			48      "Texas"
			51      "Virginia"
			54      "West Virginia"
			02      "Alaska"
			04      "Arizona"
			06      "California"
			08      "Colorado"
			15       "Hawaii"
			16       "Idaho"
			30       "Montana"
			32       "Nevada"
			35       "New Mexico"
			41       "Oregon"
			49       "Utah"
			53       "Washington"
			56       "Wyoming"
			0		 "USA"
			1000 "Caribbean"
			2010 "Antigua and Barbuda"
			2025 "Aruba"
			2030 "Bahamas"
			2040 "Barbados"
			2045 "Belize"
			2150" Cuba"
			2170 "Dominican Republic"
			2210 "French Guiana"
			2230 "Grenada"
			2240 "Guadeloupe"
			2260 "Guyana"
			2270 "Haiti"
			2290 "Jamaica"
			2300 "Martinique"
			2380 "Puerto Rico"
			2400 "St.Lucia"
			2420 "St.Vincent & Grenadines"
			2430 "Suriname"
			2440 "Trinidad and Tobago"
			2455 "USVI", replace;
label values loc loc;
#delimit cr
label define cod 	1 "le" 2 "all-cause" 3 "cancer" 4 "cvd/diabetes",modify
label values cod cod

** Country / US State indicators
** 0 = USA			<100 = USA States
** 1000 = Caribbean	>1000 = Caribbean countries
gen i2000us = i2000 if loc<100
gen i2000ca = i2000 if loc>=1000
gen i2009us = i2009 if loc<100
gen i2009ca = i2009 if loc>=1000

** Not graphing life expectancy
drop if cod==1

** Create STRING variable from label of LOC. This is to allow meaningful country/state names to be used on graphic Y-AXIS
decode loc, gen(loc_string)


** ************************************************************************************
** GRAPHICS - UNADJUSTED 
** SELECT sub-group for graphing. We produce 3 graphs
** ************************************************************************************
** ALL-CAUSE 				(COD=2). 
** CANCER					(COD=3)
** CVD/DIABETES				(COD=4)
** HEART					(COD=5)
** STROKE					(COD=6)
** DIABETES					(COD=7)

** FEMALE 					(SEX=1). 
** US ALL RACES 				(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 	(RACE=1 & LOC>1000)
keep if cod==2 & sex==1 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** ALL-CAUSE 				(COD=2). 
** MALE 						(SEX=2). 
** US ALL RACES 				(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 	(RACE=1 & LOC>1000)
** keep if cod==6 & sex==2 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** FOR MEN in 2009--> Fudge Guyana rate to fit into x-axis --> Then add real MR as text onto graph
** ALL-CAUSE
**replace i2009=2000 if loc==2260
** CVD-DIABETES
**replace i2009=890 if loc==2260
** HEART
**replace i2009=490 if loc==2260
** STROKE
** replace i2009=270 if loc==2260


** ALL-CAUSE 					(COD=2). 
** BOTH 						(SEX=3). 
** US ALL RACES 					(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 		(RACE=1 & LOC>1000)
**keep if cod==7 & sex==3 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** SELECT YEAR (2000 or 2009)
local yr = 2000

** SELECT RATE RANGE FOR X-AXIS

** CANCER
local tick1 = "0(100)500"
local tick2 = "0(50)500"
local title1 = "Cancer mortality rate"

** DIABETES
local tick1 = "0(50)250"
local tick2 = "0(25)250"
local title1 = "Diabetes mortality rate"

** CVD/DIABETES
local tick1 = "100(200)900"
local tick2 = "0(100)900"
local title1 = "CVD / diabetes mortality rate"

** HEART
local tick1 = "0(100)500"
local tick2 = "0(50)500"
local title1 = "Heart disease mortality rate"

** STROKE
local tick1 = "0(50)275"
local tick2 = "0(25)275"
local title1 = "Stroke disease mortality rate"

** ALL-CAUSE
local tick1 = "400(200)2100"
local tick2 = "400(100)2100"
local title1 = "All-cause mortality rate"

** ************************************************************************************

** Year specific values
gen inc = i`yr'
gen us  = i`yr'us if loc==0
gen ca  = i`yr'ca if loc==1000

** US average 
egen usmean = min(us)
drop us
replace usmean = round(usmean,1)
local usmean = usmean 
** Caribbean average 
egen carmean = min(ca)
drop ca
replace carmean = round(carmean,1)
local carmean = carmean
** Drop regional averages --> we don't want these as bars in the charts
drop if loc==0 | loc==1000
** Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc
gen loc2 = _n
order loc loc_string loc2
labmask loc2, values(loc_string) 
order loc loc_string loc2 

** This generates "r(levels)" for use as labelling on Y-AXIS
qui levelsof loc2 if loc>=1000

** THE GRAPHIC
#delimit ;
	graph twoway 
		(bar inc loc2 if loc<100 , horizontal lc(gs0*0.5) fc(gs0*0.5))
		(bar inc loc2 if loc>100 , horizontal lc(green*0.5) fc(green*0.5) )
		(line loc2 usmean          , lp("-") lc(gs0) lw(medium))
		(line loc2 carmean         , lp("-") lc(green) lw(medium))
	  ,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(6)
		yscale(reverse)

		xlab(`tick1', 
		labs(2.5) nogrid glc(gs14) angle(0) labgap(1))
		xscale(lw(vthin)) xtitle("`title1'", margin(t=4) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab
		labs(1.3) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("", margin(r=3) size(large))
		yscale(lw(vthin) fill) 	
		
		text(-1 `carmean' "`carmean'", place(e) size(2.5))
		text(-1 `usmean' "`usmean'", place(w) size(2.5))

		/// NOTE TO ADD TO MALE 2009 ALL-CAUSE GRAPH
		///text(66 2000 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 2460 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 CVD-DIABETES GRAPH
		///text(66 900 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 1225 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 HEART GRAPH
		///text(66 500 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 612 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 STROKE GRAPH
		// text(66 275 "*", place(e) size(3.5))
		/// note("* Guyanese mortality rate was 417 deaths per 100,000", size(2))
		
		legend(off)
		;
	#delimit cr

table race if loc>=1000, c(p50 loc2)


/*

** ************************************************************************************
** QUALITY-ADJUSTED
** ************************************************************************************

** Caribbean data
tempfile car
use "data\result_qa\car_003\caribbean_data", clear
gen race=1
rename cid loc
rename rateadj2000 i2000
rename rateadj2009 i2009
drop deaths* crude* tot* p2000 p2009
order loc race sex cod i2000 i2009 pchange change
save `car', replace

** US data, and appending the Caribbean data
use "data\result\us_001\us_data", clear
rename state loc
rename measure cod
drop c2000 c2009 ill* iul* ise* pop* deaths*
order loc race sex cod i2000 i2009 pchange
append using `car'

** Labelling variables
#delimit ;
label define loc 
			09      "Connecticut"
			23      "Maine"
			25      "Massachusetts"
			33      "New Hampshire"
			34      "New Jersey"
			36      "New York"
			42      "Pennsylvania"
			44      "Rhode Island"
			50      "Vermont"
			17      "Illinois"
			18      "Indiana"
			19      "Iowa"
			20      "Kansas"
			26      "Michigan"
			27      "Minnesota"
			29      "Missouri"
			31      "Nebraska"
			38      "North Dakota"
			39      "Ohio"
			46      "South Dakota"
			55      "Wisconsin"
			01      "Alabama"
			05      "Arkansas"
			10      "Delaware"
			11      "District of Columbia"
			12      "Florida"
			13      "Georgia"
			21      "Kentucky"
			22      "Louisiana"
			24      "Maryland"
			28      "Mississippi"
			37      "North Carolina"
			40      "Oklahoma"
			45      "South Carolina"
			47      "Tennessee"
			48      "Texas"
			51      "Virginia"
			54      "West Virginia"
			02      "Alaska"
			04      "Arizona"
			06      "California"
			08      "Colorado"
			15       "Hawaii"
			16       "Idaho"
			30       "Montana"
			32       "Nevada"
			35       "New Mexico"
			41       "Oregon"
			49       "Utah"
			53       "Washington"
			56       "Wyoming"
			0		 "USA"
			1000 "Caribbean"
			2010 "Antigua and Barbuda"
			2025 "Aruba"
			2030 "Bahamas"
			2040 "Barbados"
			2045 "Belize"
			2150" Cuba"
			2170 "Dominican Republic"
			2210 "French Guiana"
			2230 "Grenada"
			2240 "Guadeloupe"
			2260 "Guyana"
			2270 "Haiti"
			2290 "Jamaica"
			2300 "Martinique"
			2380 "Puerto Rico"
			2400 "St.Lucia"
			2420 "St.Vincent & Grenadines"
			2430 "Suriname"
			2440 "Trinidad and Tobago"
			2455 "USVI", replace;
label values loc loc;
#delimit cr
label define cod 	1 "le" 2 "all-cause" 3 "cancer" 4 "cvd/diabetes",modify
label values cod cod

** Country / US State indicators
** 0 = USA			<100 = USA States
** 1000 = Caribbean	>1000 = Caribbean countries
gen i2000us = i2000 if loc<100
gen i2000ca = i2000 if loc>=1000
gen i2009us = i2009 if loc<100
gen i2009ca = i2009 if loc>=1000

** Not graphing life expectancy
drop if cod==1

** Create STRING variable from label of LOC. This is to allow meaningful country/state names to be used on graphic Y-AXIS
decode loc, gen(loc_string)



** ************************************************************************************
** GRAPHICS - QUALITY-ADJUSTED 
** SELECT sub-group for graphing. We produce 3 graphs
** ************************************************************************************
** ALL-CAUSE 				(COD=2). 
** CANCER					(COD=3)
** CVD/DIABETES				(COD=4)
** HEART					(COD=5)
** STROKE					(COD=6)
** DIABETES					(COD=7)

** FEMALE 					(SEX=1). 
** US ALL RACES 				(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 	(RACE=1 & LOC>1000)
keep if cod==3 & sex==1 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** MALE 						(SEX=2). 
** US ALL RACES 				(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 	(RACE=1 & LOC>1000)
**keep if cod==3 & sex==2 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** FOR MEN in 2009--> Fudge Guyana rate to fit into x-axis --> Then add real MR as text onto graph
** ALL-CAUSE
** replace i2009=2000 if loc==2260
** CVD-DIABETES
**replace i2009=890 if loc==2260
** HEART
**replace i2009=490 if loc==2260
** STROKE
** replace i2009=270 if loc==2260

** BOTH 					(SEX=3). 
** US ALL RACES 				(RACE=3 & LOC<100). 
** CARIBBEAN ALL COUNTRIES 	(RACE=1 & LOC>1000)
**keep if cod==4 & sex==3 & ((race==3 & loc<100) | (race==1 & loc>=1000))

** SELECT YEAR (2000 or 2009)
local yr = 2000

** SELECT RATE RANGE FOR X-AXIS

** ALL-CAUSE
local tick1 = "400(200)2100"
local tick2 = "400(100)2100"
local title1 = "All-cause mortality rate"

** CVD/DIABETES
local tick1 = "100(200)900"
local tick2 = "0(100)900"
local title1 = "CVD/diabetes mortality rate"

** HEART
local tick1 = "0(100)500"
local tick2 = "0(50)500"
local title1 = "Heart disease mortality rate"

** STROKE
local tick1 = "0(50)275"
local tick2 = "0(25)275"
local title1 = "Stroke disease mortality rate"

** CANCER
local tick1 = "0(100)500"
local tick2 = "0(50)500"
local title1 = "Cancer mortality rate"

** DIABETES
local tick1 = "0(50)275"
local tick2 = "0(25)275"
local title1 = "Diabetes mortality rate"

** ************************************************************************************

** Year specific values
gen inc = i`yr'
gen us  = i`yr'us if loc==0
gen ca  = i`yr'ca if loc==1000

** US average 
egen usmean = min(us)
drop us
replace usmean = round(usmean,1)
local usmean = usmean 
** Caribbean average 
egen carmean = min(ca)
drop ca
replace carmean = round(carmean,1)
local carmean = carmean
** Drop regional averages --> we don't want these as bars in the charts
drop if loc==0 | loc==1000
** Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc
gen loc2 = _n
order loc loc_string loc2
labmask loc2, values(loc_string) 
order loc loc_string loc2 


** This generates "r(levels)" for use as labelling on Y-AXIS
qui levelsof loc2 if loc>=1000

** THE GRAPHIC
#delimit ;
	graph twoway 
		(bar inc loc2 if loc<100 , horizontal lc(gs0*0.5) fc(gs0*0.5))
		(bar inc loc2 if loc>100 , horizontal lc(orange*0.5) fc(orange*0.5) )
		(line loc2 usmean          , lp("-") lc(gs0) lw(medium))
		(line loc2 carmean         , lp("-") lc(orange) lw(medium))
	  ,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(6)
		yscale(reverse)

		xlab(`tick1', 
		labs(2.5) nogrid glc(gs14) angle(0) labgap(1))
		xscale(lw(vthin)) xtitle("`title1'", margin(t=4) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab
		labs(1.3) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("", margin(r=3) size(large))
		yscale(lw(vthin) fill) 	
		
		text(-1 `carmean' "`carmean'", place(e) size(2.5))
		text(-1 `usmean' "`usmean'", place(w) size(2.5))

		/// NOTE TO ADD TO MALE 2009 ALL-CAUSE GRAPH
		///text(66 2000 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 2460 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 CVD-DIABETES GRAPH
		///text(66 900 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 1515 deaths per 100,000", size(2))
		///note("* Guyanese mortality rate was 1006 deaths per 100,000", size(2))
				
		/// NOTE TO ADD TO MALE 2009 HEART GRAPH
		///text(66 500 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 758 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 STROKE GRAPH
		///text(66 275 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 515 deaths per 100,000", size(2))
		///note("* Guyanese mortality rate was 342 deaths per 100,000", size(2))
			
		legend(off size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(2)
		region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
		);
	#delimit cr

table race if loc>=1000, c(p50 loc2)

** Rank in Caribbean
gen rank = _n
sum rank if loc>=1000, det
sum rank if loc<1000, det

