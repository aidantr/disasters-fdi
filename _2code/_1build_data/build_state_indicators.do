/*******************************************************************************
Table 3: Build dataset with economic indicators

Inputs:     - annual "principal characteristics" by state 
            - annual "important characteritsics" by state
			- insurance rates
			- annual CPI data
		
Output:     -principal_indicators.dta

********************************************************************************/



forvalues i=2006/2017 {


if `i'==2006{
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A4:H37) clear
drop in 1/2
}

if `i'==2007 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A1:H33) clear
drop in 1
}

if `i'==2008 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A2:H34) clear
drop in 1
}

if `i'==2009 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A3:H36) clear
drop in 1
}

if inlist(`i', 2010, 2011) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A4:H38) clear
drop in 1/2
}

if inlist(`i', 2012) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A4:H39) clear
drop in 1/2
}

if `i'==2013 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A3:H37) clear
drop in 1
}

if inlist(`i', 2014, 2015, 2016, 2017) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A4:H40) clear
drop in 1/2
}


rename States State
rename Factories factories
rename Fixed fixed_cap
rename Productive productive_cap
rename Invested invested_cap
rename Workers workers
rename TotalPersons persons_engaged
rename Wagesto wages



foreach var of varlist factories-wages {
destring `var', replace
}

gen year=`i'
order State year
save _1data/raw/indicators/temp/`i'_1, replace

if `i'==2006{
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A43:H76) clear
drop in 1/2
}

if `i'==2007 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A35:H68) clear
drop in 1/2
}

if `i'==2008 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A37:H69) clear
drop in 1
}

if `i'==2009 {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A40:H73) clear
drop in 1
}

if inlist(`i', 2010, 2011) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A44:H78) clear
drop in 1/2
}

if inlist(`i', 2012) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A45:H80) clear
drop in 1/2
}

if inlist(`i', 2013) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xlsx, first cellrange(A41:H75) clear
drop in 1
}

if inlist(`i', 2014, 2015, 2016, 2017) {
import excel using _1data/raw/indicators/ministry_statistics/pc_`i'.xls, first cellrange(A46:H82) clear
drop in 1/2
}

rename States State
if inlist(`i', 2008, 2009, 2013) {
rename TotalEmol total_earnings
}
else {
rename Total total_earnings
}

if inlist(`i', 2007, 2008, 2009, 2013) {
rename TotalInput inputs
}
else {
rename C inputs
}


if inlist(`i', 2008, 2009, 2013) {
rename TotalOutput output
}
else if inlist(`i', 2010, 2011, 2012, 2014, 2015, 2016, 2017) {
rename D output
}
else {
rename Gross output
}
rename Deprec depreciation
rename NetValue nva
rename RentPaid rents
rename Interest interest



foreach var of varlist total_earnings-interest {
destring `var', replace
}

gen year=`i'
order State year

save _1data/raw/indicators/temp/`i'_2, replace


use _1data/raw/indicators/temp/`i'_1, clear
merge 1:1 State using _1data/raw/indicators/temp/`i'_2


save _1data/raw/indicators/temp/`i', replace
}


** Append all files:
forvalues i=2006/2016 {
append using _1data/raw/indicators/temp/`i'
}
sort State year

drop _merge

** Fix State names:
replace State="Andaman & N. Island" if State=="A & N. Island"
replace State="Chandigarh" if State=="Chandigarh (U.T.)" | State=="Chandigarh(U.T.)" | State=="Chandigarh "
replace State="Dadra & Nagar Haveli" if State=="Dadra & N Haveli"
replace State="Odisha" if State=="Orissa"
replace State="Puducherry" if State=="Pondicherry"
replace State="Telangana" if State=="Telengana"
replace State="Uttarakhand" if State=="Uttaranchal"

drop if inlist(State, "Arunachal Pradesh", "Sikkim", "Telangana")

tab State


foreach var of varlist factories-interest {
gen l`var' = ln(`var')
}


** Merge in State-Region concordance:
replace State="Delhi" if State=="NCT Delhi"
replace State="Andaman and Nicobar Islands" if State=="Andaman & N. Island"
replace State="Chhattisgarh" if State=="Chattisgarh"
replace State="Dadra and Nagar Haveli" if State=="Dadra & Nagar Haveli"
replace State="Daman and Diu" if State=="Daman & Diu"
replace State="Jammu and Kashmir" if State=="Jammu & Kashmir"

** Merge in state-region concordance:
merge m:1 State using _1data/xwalks/states_affected
keep if _merge==3
drop _merge
rename District region
replace region=lower(region)
foreach x in one two three four five {
rename `x'_affected s_`x'_affected
}

replace region="bubaneshwar" if region=="bhubaneshwar"
replace region="guwahati" if region=="guwhati"
replace region="new_delhi" if region=="new delhi"
drop if region=="na"

/*
collapse (mean) factories-interest, by(region year)
foreach var of varlist factories-interest {
gen l`var' = ln(`var')
}
*/

merge 1:1 State year using _1data/raw/indicators/insurance/ins_data
keep if _merge==3
drop _merge



merge 1:1 State year using _1data/raw/indicators/cpi/cpi_annual
drop if _merge==2
drop _merge

save _1data/clean/principal_indicators.dta, replace


