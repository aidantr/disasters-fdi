************ Clean Insurance Data ****************
clear
set more off
set matsize 11000

cd "C:\Users\ffriedt\Desktop\FDI_disaster_&_spillovers\Insurance_data"

/*
import excel using "p.34.xlsx", clear cellrange(A4:L39)
drop B

** Rename variables
rename A state
rename C pol_10
rename D prem_10
rename E pol_11
rename F prem_11
rename G pol_12
rename H prem_12
rename I pol_13
rename J prem_13
rename K pol_14
rename L prem_14

destring pol_10-prem_13, replace force

reshape long pol_ prem_, i(state) j(year)

rename pol_ policies
rename prem_ premiums
replace year=year+2000

save p.34, replace



import excel using "p.33.xlsx", clear cellrange(A4:J39)
drop B

** Rename variables
rename A state
rename C pol_6
rename D prem_6
rename E pol_7
rename F prem_7
rename G pol_8
rename H prem_8
rename I pol_9
rename J prem_9

destring pol_6-prem_9, replace force

reshape long pol_ prem_, i(state) j(year)

rename pol_ policies
rename prem_ premiums
replace year=year+2000

append using p.34

sort state year

save p.33_34, replace
*/


** collapse existing data to yearly obs:
use clean_data, clear

collapse (mean) GDP pop lag_lgdp lag_lpop one_bin-five_affected region1 (sum) fdi, by(region year)
drop if year==2005

foreach var of varlist one_bin-five_bin {
replace `var'=1 if `var'>0
}

foreach x in one two three four five {
gen `x' = `x'_bin*`x'_affected 
}

*/

drop if year>2017
save control_data, replace



import excel using "ind_new_business_14-19.xlsx", clear cellrange(A5:K40)

** Rename variables
rename A state
rename B pol_13
rename C prem_13
rename D pol_14
rename E prem_14
rename F pol_15
rename G prem_15
rename H pol_16
rename I prem_16
rename J pol_17
rename K prem_17

destring pol_13-prem_13, replace force

reshape long pol_ prem_, i(state) j(year)
rename pol_ policies
rename prem_ premiums
replace year=year+2000
drop if year==2014

append using p.33_34
sort state year

replace state="Andaman and Nicobar Islands" if state=="Andaman & Nicobar"
replace state="Chhattisgarh" if state=="Chattisgarh"
replace state="Dadra and Nagar Haveli" if state=="Dadra & Nagra Haveli"
replace state="Daman and Diu" if state=="Daman & Diu"
replace state="Jammu and Kashmir" if state=="Jammu & Kashmir"
replace state="Uttarakhand" if state=="Uttrakhand"
rename state State

** Merge in state-region concordance:
merge m:1 State using states_affected
keep if _merge==3
drop _merge
*collapse (sum) policies premiums, by(District year)

rename District region
replace region=lower(region)
foreach x in one two three four five {
rename `x'_affected s_`x'_affected
}

drop if region=="na"
replace region="new_delhi" if region=="new delhi"
replace region="bubaneshwar" if region=="bhubaneshwar"
replace region="guwahati" if region=="guwhati"


merge m:1 region year using control_data
drop _merge

gen per_prem=premiums/policies

gen lpol = ln(policies)
gen lprem = ln(premiums)
gen lper_prem = ln(per_prem)



sort State year
quietly by State year:  gen dup = cond(_N==1,0,_n)
drop if dup>1




* Identify the pre-treatment years for the affected regions.
* These are the relavant pre-treatment dummies = 1 for the specific year for the affected regions
gen pre_1 =0
replace pre_1=1 if 	(year==2008 & inlist(State, "Odisha", "Assam")) | ///
					(year==2011 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2013 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))
					
gen pre_2 =0
replace pre_2=1 if (year==2007 & inlist(State, "Odisha", "Assam")) | ///
					(year==2010 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2012 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))
gen pre_3 =0
replace pre_3=1 if (year==2006 & inlist(State, "Odisha", "Assam")) | ///
					(year==2009 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2011 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))

gen pre_4 =0
replace pre_4=1 if (year==2008 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2010 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))
					
gen pre_5 =0
replace pre_5=1 if (year==2007 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2009 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))					
					
gen pre_6 =0
replace pre_6=1 if (year==2006 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2008 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))					
					
gen pre_7 =0
replace pre_7=1 if (year==2007 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))					
					
gen pre_8 =0
replace pre_8=1 if (year==2006 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))
					

gen post_1=0
replace post_1=1 if (year==2007 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2010 & inlist(State, "Odisha", "Assam")) | ///
					(year==2013 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2015 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))					
										
gen post_2=0
replace post_2=1 if (year==2008 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2011 & inlist(State, "Odisha", "Assam")) | ///
					(year==2014 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2016 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))	
					
gen post_3=0
replace post_3=1 if (year==2009 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2012 & inlist(State, "Odisha", "Assam")) | ///
					(year==2015 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi")) | ///
					(year==2017 & inlist(State, "Puducherry", "Tamil Nadu", "Andhra Pradesh"))	 
					
gen post_4=0
replace post_4=1 if (year==2010 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2013 & inlist(State, "Odisha", "Assam")) | ///
					(year==2016 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi"))
					
gen post_5=0
replace post_5=1 if (year==2011 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2014 & inlist(State, "Odisha", "Assam")) | ///
					(year==2017 & inlist(State, "Himachal Pradesh", "Uttar Pradesh", "Uttarakhand", "Delhi"))					
					
gen post_6=0
replace post_6=1 if (year==2012 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2015 & inlist(State, "Odisha", "Assam"))	

gen post_7=0
replace post_7=1 if (year==2013 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2016 & inlist(State, "Odisha", "Assam"))					

gen post_8=0
replace post_8=1 if (year==2014 & inlist(State, "Sikkim", "Bihar")) | ///
					(year==2017 & inlist(State, "Odisha", "Assam"))

gen post_9=0
replace post_9=1 if (year==2015 & inlist(State, "Sikkim", "Bihar"))

gen post_10=0
replace post_10=1 if (year==2016 & inlist(State, "Sikkim", "Bihar"))

gen post_11=0
replace post_11=1 if (year==2017 & inlist(State, "Sikkim", "Bihar"))





	
gen affected=0
replace affected=1 if inlist(State, "Sikkim", "Bihar", "Odisha", "Assam", "Himachal Pradesh", "Uttar Pradesh")
replace affected=1 if inlist(State, "Uttarakhand", "Delhi", "Puducherry", "Tamil Nadu", "Andhra Pradesh")


egen s_id=group(State)
local k=1
foreach var of varlist lprem {
cgmreg `var' pre_8 pre_7 pre_6 pre_5 pre_4 pre_3 pre_2 pre_1 post_* i.s_id i.year, cluster(s_id year)

* Pull coefficients into matrix:
mat beta=e(b)

** Average Treatment Effects:
mat A = beta[1,3..17]

mat pre= A[1,1..6]
mat post= A[1,7..14]


* Need to set the reference month at 0:
mat pre_post=(pre, 0, post)
mat list pre_post


** Create a counter column:
mat Z=J(1,15,0)
local j=1
forvalues i=-6/8{
mat Z[1,`j'] = `i'
local j=`j'+1
}

** Build Coefficient and Confidence Interval Matrix:
* Calculate 95% confidence interval +/- 1.96*std. error:
mat AZ= (Z', pre_post')

* Create variables from matrix so that you can graph them:
svmat AZ, names(eff`k'_)
sort eff1_1
local k=`k'+1
}



* Graph the Effects on State Expenditure and Revenue:

* FIGURE 4.C: 
sort eff1_1

graph twoway (connected eff1_2 eff1_1, xline(0) yline(0) lc(blue%40) mc(blue%40) ms(cirle)) ///
	, ytitle("Logged Pre- and Post-Disaster Changes", ax(1)) xtitle("Year relative to Disaster") ///
	scheme(s1color)  xline(0, axis(1)) yline(0, axis(2 1)) ///
	name(state_budget, replace) xscale(r(-6, 8)) xlabel(-6(2)8) ///
	legend(lab(1 "State Sales Tax Revenue")) 

	

keep eff*
drop if eff1_1==.
rename eff1_2 eff7_2

merge 1:1 eff1_1 using "C:\Users\ffriedt\Desktop\FDI_disaster_&_spillovers\yr_effects"
drop _merge
save "C:\Users\ffriedt\Desktop\FDI_disaster_&_spillovers\yr_effects", replace


