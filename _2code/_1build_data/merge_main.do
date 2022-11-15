
/*******************************************************************************
Merge clean data to create main panel

Inputs:     - regional_fdi_month.dta
            - regional_controls.dta
			- insurance rates
			- annual CPI data
		
Output:     -clean_data.dta

********************************************************************************/


*load raw FDI data

use _1data/raw/fdi/regional_fdi_month.dta, clear

*merge controls

*use _1data/raw/regional_characteristics/regional_controls.dta, clear

merge 1:1 region date using  _1data/raw/regional_characteristics/regional_controls.dta, keep(3) nogen

*merge disaster info


merge 1:1 region date using  _1data/raw/disasters/disaster_timing_affected.dta, keep(3) nogen

merge m:1 region using  _1data/raw/disasters/spatial_disaster.dta, nogen

encode region, gen(region1)

/*
*generate the appropriate monthly date

gen month=month(date)
gen year = year(date)
drop date
gen date = ym(year, month)
format date %tm
drop year month

order region date
*/

gen year = yofd(dofm(date))

*month count

bysort region1: gen Count = _n
*fill education values
replace edu = edu[_n-1] if missing(edu) 

* generate the logged variables
generate pop_log = ln(pop)
generate GDP_log = ln(GDP)
generate edu_log = ln(edu)
gen lfdi = ln(fdi)
generate fdi_ihs = asinh(fdi)
replace density = density/100


** We want to lag these controls by at least one year bc the disaster has an impact on GDP and/or Population.
** Given that we observe the controls at yearly frequency and the panel starts middle of 2005,
** the lagging by 12 month is tricky and some values need to be fixed.
* generate lagged variables:
gen lag_lgdp = .
bysort region (date): replace lag_lgdp=GDP_log[_n-12]
bysort region (date): replace lag_lgdp=GDP_log[1] if year==2006

gen lag_gdp = .
bysort region (date): replace lag_gdp=GDP[_n-12]
bysort region (date): replace lag_gdp=GDP[1] if year==2006


** I noticed that there is a weird empty observation. Not sure where it came from. This drops the empty line:


** Back to creating the lags:
gen lag_lpop = .
bysort region (date): replace lag_lpop=pop_log[_n-12]
bysort region (date): replace lag_lpop=pop_log[1] if year==2006

gen lag_pop = .
bysort region (date): replace lag_pop=pop[_n-12]
bysort region (date): replace lag_pop=pop[1] if year==2006


gen lag_ledu = .
bysort region (date): replace lag_ledu=edu_log[_n-12]
bysort region (date): replace lag_ledu=edu_log[1] if year==2006

gen lag_edu = .
bysort region (date): replace lag_edu=edu[_n-12]
bysort region (date): replace lag_edu=edu[1] if year==2006



** Declare the panel dataset:
xtset region1 date


** YOUR PREVIOUS DEFINITIONS OF AFFECTED AND CONTINGUOUS REGIONS DO NO MATCH YOUR CODE!!! ****
** PLEASE DOUBLE CHECK THIS!!! ***
** HERE I ADJUST ACCORDING TO TABLE 1 IN THE PAPER
** IF THE CODE IS RIGHT AND THE PAPER TABLE 1 IS WRONG, WE JUST DELETE THIS PART:

* Disaster 1:
tab region if one_affected==1 /*According to your paper this should only include Patna Kolkata*/
replace one_affected=0 if region=="kanpur"

tab region if one_contiguous==1
replace one_contiguous=0 if region=="patna"


* Disaster 2:
tab region if two_affected==1 /*Please double check*/
tab region if two_contiguous==1 /*Please double check*/


* Disaster 3:
tab region if three_affected==1 /*Please double check*/
tab region if three_contiguous==1 /*Please double check*/


* Disaster 4:
tab region if four_affected==1 /*Please double check*/
tab region if four_contiguous==1 /*Please double check*/


* Disaster 5:
tab region if five_affected==1 /*Please double check*/
tab region if five_contiguous==1 /*Please double check*/



* The previous regression with the interaction terms (##) let's stata decide what to exclude due to multicollinearity
* As a result, STATA drops some fixed effects and keeps some of the bin and/or affected variables, which it shouldn't
* This messes with the interpretation. Instead, we need to only include what needs to be included. 
* I.e. we only include the region and time (year and month or monthly) fixed effects and the interaction terms
* Here I generate these treatment indicators:
gen one = one_bin*one_affected 
gen two = two_bin*two_affected 
gen three = three_bin*three_affected 
gen four = four_bin*four_affected 
gen five = five_bin*five_affected

***********************************************************************************************
***********************************************************************************************
***********************************************************************************************
******************* GEOGRAPHY SPILLOVER MECHANISMS ************************
***********************************************************************************************
***********************************************************************************************
***********************************************************************************************

** 1) Continguity treatment indicator:
gen one_cont = one_bin*one_contiguous 
gen two_cont = two_bin*two_contiguous 
gen three_cont = three_bin*three_contiguous 
gen four_cont = four_bin*four_contiguous 
gen five_cont = five_bin*five_contiguous 

** 2) Inverse distance:
replace one_distance = one_bin/one_distance
replace two_distance = two_bin/two_distance 
replace three_distance = three_bin/three_distance
replace four_distance = four_bin/four_distance
replace five_distance = five_bin/five_distance 

foreach y in "one_" "two_" "three_" "four_" "five_" {
replace `y'distance = 0 if `y'affected==1
}

/*
** Robustness: X) Kth nearest neighbor indicator - does not yield any striking results
replace one_kth_neighbor = one_kth_neighbor * one_bin
replace two_kth_neighbor = two_kth_neighbor * two_bin
replace three_kth_neighbor = three_kth_neighbor * three_bin
replace four_kth_neighbor = four_kth_neighbor * four_bin
replace five_kth_neighbor = five_kth_neighbor * five_bin

* set it = 0 for directly affected regions
foreach x in "one_kth_neighbor" "two_kth_neighbor" "three_kth_neighbor" "four_kth_neighbor" "five_kth_neighbor" {
replace `x'=0 if `x'==.
}
*/




************************************ REGIONAL DEVELOPMENT **********************************

** Spillover by development indicator: 3) density, 4) urban percent 
** and 5) water, 6) electricity, and 7) latrine access (within premises)

rename urban_percent urban

merge m:1 region using _1data/raw/regional_characteristics/census/development.dta, nogen



foreach x in "density" "urban" "water_s" "elec_s" "lat_s" {
foreach y in "one_" "two_" "three_" "four_" "five_" {
gen `y'`x' = `y'bin*`x'
replace `y'`x' = 0 if `y'affected==1
}
}




************************************ REGIONAL INFRASTRUCTURE **********************************

** 8 & 9) Access to Golden Quadriladeral (GQ) and Major Seaport:

* Create Port Indicator:
gen port=0
replace port=1 if inlist(region, "chandigarh", "mumbai", "bangalore", "panaji", "kochi", "chennai", "hyderabad", "bhubaneshwar", "kolkata")

* rename
rename golden_quad gq

** Create weighted spillover indicator:
foreach x in "gq" "port" {
foreach y in "one_" "two_" "three_" "four_" "five_" {
gen `y'`x' = `y'bin*`x'
replace `y'`x' = 0 if `y'affected==1
}
}







************************************ LABOR SKILL & COMPOSITION *******************************************

** Merge 2 datasets on skill and composition:
merge m:1 region using _1data/raw/regional_characteristics/census/skill.dta, nogen


merge m:1 region using _1data/raw/regional_characteristics/census/employment.dta, nogen



** Create weighted spillover indicator:
foreach x in "lit_s" "grad_s" "manu_s" "retail_s" {
foreach y in "one_" "two_" "three_" "four_" "five_" {
gen `y'`x' = `y'bin*`x'
replace `y'`x' = 0 if `y'affected==1
}
}



/*
** X) Robustness: Check with 2008 Labor stats
* Merge in employment data:
merge m:1 region using employment_data/mining_emp
drop _merge

merge m:1 region using employment_data/retail_emp
drop _merge

merge m:1 region using employment_data/factory_emp
drop _merge
*/


************************  SPILLOVER BASED ON ECONOMIC SIMILARITY ****************************

** Does it matter whether a region has more manufacturing or has a similar industrial composition? 
** 2) Similar manufacturing or retail employment shares:

merge m:1 region using _1data/raw/regional_characteristics/census/ind_comp.dta, nogen

gen id=1

foreach y in "one_" "two_" "three_" "four_" "five_" {
foreach x of varlist agri_s-other_s {
bysort `y'affected date (region): egen `y'avg_`x'=mean(`x') if `y'affected==1
bysort id (`y'avg_`x'): replace `y'avg_`x'=`y'avg_`x'[1]

gen `y'sim_`x' = (1/abs(`y'avg_`x'-`x'))
bysort date (region): egen tot_`y'sim_`x'=total(`y'sim_`x') if `y'affected==0
replace `y'sim_`x'=`y'sim_`x'/tot_`y'sim_`x'

replace `y'sim_`x' = 0 if `y'affected==1
replace `y'sim_`x' = `y'sim_`x'*`y'bin

drop `y'avg_`x' tot_`y'sim_`x'

}

egen `y'sim = rowtotal(`y'sim_agri_s-`y'sim_other_s)

drop `y'sim_agri_s-`y'sim_other_s


}






************************  SPILLOVER BASED ON RISK BASED ON PREVIOUS DISASTERS ****************************



merge m:1 region using _1data/raw/disasters/disaster_risk.dta, nogen



* set time horizon on risk variable


** Create weighted spillover indicator:
foreach i in "_past10" "_past20" "_past30" {
foreach x in "number_any`i'" "number_major1`i'" "number_major2`i'" "damages_cum`i'" {
foreach y in "one_" "two_" "three_" "four_" "five_" {
gen `y'`x' = `y'bin*`x'
replace `y'`x' = 0 if `y'affected==1
}
}
}


*** Set spillover channels equal to 0 if a region was already hit by a disaster
** That is only focus on regions that have not been previously affected by a disaster.

foreach x in "cont" "distance" "density" "urban" "water_s" "elec_s" "lat_s" "gq" "port" "lit_s" "grad_s" "manu_s" "retail_s" "sim" ///
	"number_any_past10" "number_any_past20" "number_any_past30" "number_major1_past10" "number_major1_past20" "number_major1_past30" ///
	"number_major2_past10" "number_major2_past20" "number_major2_past30" "damages_cum_past10" "damages_cum_past20" "damages_cum_past30" {
*  should not make any changes as all other regions were not hit before:
replace one_`x' = 0 if inlist(region, "kolkata", "patna")

* should not make any changes as all other regions were also not affected by disaster one:
replace two_`x' = 0 if inlist(region, "bubaneshwar", "guwahati", "kolkata", "patna")

* should make changes:
replace three_`x' =0 if inlist(region, "bubaneshwar", "chandigarh", "guwahati",  ///
		"kanpur", "kolkata", "new_dehli", "patna")

replace four_`x' =0 if inlist(region, "bubaneshwar", "chandigarh", "chennai", "guwahati", "hyderabad", ///
		"kanpur", "kolkata", "new_dehli", "patna")

replace five_`x' =0 if (inlist(region, "bubaneshwar", "chandigarh", "chennai", "guwahati", "hyderabad") | ///
		inlist(region, "kanpur", "kochi", "kolkata", "new_dehli", "patna"))

}

sort region date


save _1data/clean/clean_data, replace




