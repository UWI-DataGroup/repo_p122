** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_map_car_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_map_car_001.do
**  project:      
**  author:       HAMBLETON \ 21-SEP-2015
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

** Keep Caribbean country-level data only (drop US data)
keep if cid>1000

** Save the US only dataset
tempfile car_map_001
save `car_map_001', replace


** -------------------------------------------------------------------------------------------------
** MAPS of mortality rates -- CHOROPLETH MAPS
** -------------------------------------------------------------------------------------------------

** Create TWO files
** pkdata.dta		--> 
** pkcoords.dta	--> Contains THREE variables
**		-->  _ID polygon ID
**		-->  _X polygon shape
**		-->  _Y polygon shape


/*

** *********************************************
** ID 2010. ANTIGUA and BARBUDA
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\antigua\ATG_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\atg1_database) coor(C:\ado\personal\map_coordinates\atg1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\atg1_database, replace
** Ignore Barbuda (ID=1) and Redonda (ID=2)
drop if inlist(_ID, 1,2)
tempfile atg1_database
save `atg1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
save C:\ado\personal\map_coordinates\atg1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2010
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\atg1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** Antigua. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\atg1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		bgcolor(gs16)
		;
# delimit cr




** *********************************************
** ID 2030. BAHAMAS
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\bahamas\BHS_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\bhs1_database) coor(C:\ado\personal\map_coordinates\bhs1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\bhs1_database, replace
tempfile bhs1_database
save `bhs1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
save C:\ado\personal\map_coordinates\bhs1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2030
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\bhs1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** Bahamas. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\bhs1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		;
# delimit cr




** *********************************************
** ID 2040. BARBADOS
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\barbados\BRB_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\brb1_database) coor(C:\ado\personal\map_coordinates\brb1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\brb1_database, replace
tempfile brb1_database
save `brb1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
save C:\ado\personal\map_coordinates\brb1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2040
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\brb1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** Barbados. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\brb1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		;
# delimit cr




** *********************************************
** ID 2045. BELIZE
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\belize\BLZ_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\blz1_database) coor(C:\ado\personal\map_coordinates\blz1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\blz1_database, replace
tempfile blz1_database
save `brb1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
save C:\ado\personal\map_coordinates\blz1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2045
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\blz1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** Belize. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\blz1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		;
# delimit cr




** *********************************************
** ID 2400. ST. LUCIA
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\st-lucia\LCA_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\lca1_database) coor(C:\ado\personal\map_coordinates\lca1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\lca1_database, replace
tempfile lca1_database
save `lca1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
replace cid = "St.Lucia" if cid=="Saint Lucia"
save C:\ado\personal\map_coordinates\lca1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2400
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\lca1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** St.Lucia. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\lca1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		bgcolor(gs16)
		;
# delimit cr






** *********************************************
** ID 2420. ST. VINCENT
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\st-vincent\VCT_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\vct1_database) coor(C:\ado\personal\map_coordinates\vct1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\vct1_database, replace
tempfile vct1_database
save `vct1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
replace cid = "St.Vincent & Grenadines" if cid=="Saint Vincent and the Grenadines"
save C:\ado\personal\map_coordinates\vct1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2420
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\vct1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** St.Vincent. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\vct1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		bgcolor(gs16)
		;
# delimit cr


*/




** *********************************************
** ID 2440. TRINIDAD
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\trinidad\TTO_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\tto1_database) coor(C:\ado\personal\map_coordinates\tto1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\tto1_database, replace
tempfile tto1_database
save `tto1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
save C:\ado\personal\map_coordinates\tto1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2440
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\tto1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** TnT. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\tto1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		bgcolor(gs16)
		;
# delimit cr





** *********************************************
** ID 2455. USVI
** *********************************************

* Shapefile from  http://www.gadm.org/country
shp2dta using "C:\ado\personal\shapefiles\caribbean\usvi\VIR_adm1.shp", ///
        data(C:\ado\personal\map_coordinates\vir1_database) coor(C:\ado\personal\map_coordinates\vir1_coords) replace

** USE the converted database file
use C:\ado\personal\map_coordinates\vir1_database, replace
tempfile vir1_database
save `vir1_database', replace
** Prepare adatabase file for merging with Mortality rates 
rename NAME_0 cid
rename NAME_1 district
gen sabbr = ISO
keep cid district sabbr _ID 
order cid district sabbr _ID
replace cid = "USVI"
save C:\ado\personal\map_coordinates\vir1_database_clean, replace

** Merge CLEAN DATABASE file with mortality rates by states
use `car_map_001', clear
keep if decade==2 & sex==1 & cod==4 & arange==3 & dataset==28
keep if cid==2455
rename cid cid1
decode cid1, gen(cid)
merge m:m cid using "C:\ado\personal\map_coordinates\vir1_database_clean"
drop if _merge==1
drop _merge
tempfile basemap
save `basemap', replace

** DATASET
use `basemap', clear
format i %9.0f

** TnT. FEMALE. CVD-DIABETES. 0-64 (1999-2001)
#delimit ;
spmap 	i using "C:\ado\personal\map_coordinates\vir1_coords", moc(gs14) mfc(gs14)
		id(_ID) oc(gs13 gs13 gs13 gs13 gs13 gs13 )
		title("", size(7.5) pos(12) ring(0))
		fcolor(Oranges) clmethod(eqint) eirange(16 90) legstyle(3) ndf(gs10) ndo(gs13) 
		legend(off ring(0) position(5) bm(l=5 r=2 t=5) size(7) symy(7) symx(7)) 
		bgcolor(gs16)
		;
# delimit cr


