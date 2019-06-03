** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_map_us_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_map_us_001.do
**  project:      
**  author:       HAMBLETON \ 16-SEP-2015
**  task:         Mortality rates in the Caribbean: mapping

** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Temporary scalar to be used as file prefix 
local file = "us"
** Primary dataset created using --> d100_join_mr_datasets.do
use "data\result\us_carib\mr_us_carib_001", clear

** Keep State-level data only (drop US level data)
drop if cid==0

** Save the US only dataset
tempfile us_map_001 us1_database
save `us_map_001', replace


** -------------------------------------------------------------------------------------------------
** MAPS of mortality rates -- CHOROPLETH MAPS
** -------------------------------------------------------------------------------------------------

** Create TWO files
** pkdata.dta		--> 
** pkcoords.dta	--> Contains THREE variables
**		-->  _ID polygon ID
**		-->  _X polygon shape
**		-->  _Y polygon shape

* Shapefile from http://www2.census.gov/geo/tiger/GENZ2013/cb_2013_us_state_500k.zip
shp2dta using "C:\ado\personal\shapefiles\US\cb_2013_us_state_500k\cb_2013_us_state_500k.shp", ///
        data(C:\ado\personal\map_coordinates\us1_database) coor(C:\ado\personal\map_coordinates\us1_coords) replace

** Remove Alaska etc
use C:\ado\personal\map_coordinates\us1_database, replace
save `us1_database', replace

use C:\ado\personal\map_coordinates\us1_coords, replace
** Ignore Alaska (37), Puerto Rico (32), American Samoa,  Marianas, Guam, Hawaii, Virgin Islands
drop if inlist(_ID, 37,32,55,54,40,28,29)
save "C:\ado\personal\map_coordinates\us1_coords_clean", replace 


** US States with "high Performing" AA populations (CVD-DIAB, Male, 2009-11)
keep if _ID==1 | _ID==3 | _ID==4 | _ID==13 | _ID==34 | _ID==47 | _ID==48 | _ID==50 | _ID==52
save "C:\ado\personal\map_coordinates\us1_overlay", replace


** Clean the database file
use `us1_database', clear

** STATES	Mapped to Mortality Rate data 
rename NAME state
gen sabbr = STUSPS

keep state sabbr _ID 
order state sabbr _ID	
save C:\ado\personal\map_coordinates\us1_database_clean, replace





** Merge CLEAN DATABASE file with mortality rates by states
use `us_map_001', clear
decode cid, gen(state)
merge m:m state using "C:\ado\personal\map_coordinates\us1_database_clean"
** Drop N=2 rows --> Hawaii and Alaska from Mortality rate file
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace


** DATASET
use `basemap', clear

format i %9.0f

/*
** MALE. AFRICAN-AMERICAN. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(100 140 180 220 260) clnumber(4) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		;
# delimit cr

** MALE. AFRICAN-AMERICAN. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr


** FEMALE. AFRICAN-AMERICAN. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==1 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr



** MALE. WHITE. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==2
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr


** FEMALE. WHITE. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==1 & cod==4 & race==2
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr


** FEMALE. AFRICAN-AMERICAN. CVD-DIAB. 0.74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==1 & cod==2 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) 	clmethod(custom) clbreaks(100 140 180 220 260) clnumber(4) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		;
# delimit cr


** 	SUPERIMPOSED GREEN FOR THE X STATES with
**	AA levels within range of WA states
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(100 140 180 220 260) clnumber(4) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		polygon(data("C:\ado\personal\map_coordinates\us1_overlay.dta") oc(gs13 ..) os(0.1 ..) fc(orange*0.5))
		;
# delimit cr




** Min and Max by population subgroup
sort dataset race sex 
table race sex if dataset==500 & cod==4, c(min i max i)
sort dataset race sex i
list race sex cid i if dataset==500 & cod==4, sepby(race sex)


*/

** Graphics for FMS poster
** Sep 2016
** In these we simplify the legend on one, and remove the legend on the other 3

** Legend ONLY
gen i2 = i*100
#delimit ;
spmap 	i2 if dataset==500 & sex==2 & cod==4 & race==1 
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(ring(0) position(5) bm(l=5 r=2 t=5) size(9) symy(9) symx(9)) 
		;
# delimit cr


** MALE. AFRICAN-AMERICAN. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(8) symy(8) symx(8)) 
		;
# delimit cr


** FEMALE. AFRICAN-AMERICAN. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==1 & cod==4 & race==1
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr


** MALE. WHITE. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==2 & cod==4 & race==2
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr


** FEMALE. WHITE. CVD-DIAB. 0-74 (2009-11)
#delimit ;
spmap 	i if dataset==500 & sex==1 & cod==4 & race==2
		using "C:\ado\personal\map_coordinates\us1_coords_clean", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Blues2) clmethod(custom) clbreaks(20 60 100 140 180 220 260) clnumber(6) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(6) symy(6) symx(6)) 
		;
# delimit cr

