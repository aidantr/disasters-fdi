
********************************************************************************
* Table 3: Differences-in-differences for economic indicators

********************************************************************************




** collapse existing data to yearly obs:
use _1data/clean/clean_data, clear

collapse (mean) GDP pop lag_lgdp lag_lpop one_bin-five_affected region1 (sum) fdi, by(region year)
drop if year==2005

foreach var of varlist one_bin-five_bin {
replace `var'=1 if `var'>0
}

foreach x in one two three four five {
gen `x' = `x'_bin*`x'_affected 
}


** Merge in clean data:
drop if year>2017
merge 1:m region year using _1data/clean/principal_indicators.dta
keep if _merge==3
drop _merge






* Identify the pre-treatment years for the affected regions.
* These are the relavant pre-treatment dummies = 1 for the specific year for the affected regions
drop pre* post* affected
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
replace affected=1 if inlist(region, "kolkata" , "patna", "bubaneshwar" ,"guwahati")
replace affected=1 if inlist(region, "chandigarh", "new_delhi", "kanpur", "hyderabad", "chennai")


egen s_id=group(State)
local k=1
xtset s_id year
gen lfdi = ln(fdi)
gen lcpi = ln(cpi)


foreach x in one two three four {
tab State if `x'==1
}

distinct State
tab year

* Iniate p-value matrix:
mat p_val_ei=J(4,6,.)


* Static Effects:
local i = 1
foreach var of varlist lfixed_cap lworkers lwages lrents lcpi lper_prem  {
xtreg `var' one two three four i.year, fe

boottest {one} {two} {three} {four}  ///
	, reps(9999) gridpoints(10) cluster(s_id year) bootcluster(s_id year) nograph seed(123)

eststo tb_ei_`i'

* Collect p-values:
mat p_val_ei[1,`i']=r(p_1)
mat p_val_ei[2,`i']=r(p_2)
mat p_val_ei[3,`i']=r(p_3)
mat p_val_ei[4,`i']=r(p_4)

local i = `i'+1

}


mat list p_val_ei
outtable using _3results/tables/table3_pval_ei, mat(p_val_ei) replace format(%9.3f) norow nodots

esttab _all using _3results/tables/table3.tex, order(one two three four) keep(one two three four)  ///
	nostar b(3) p(3) coeflabel(one "Disaster 1" two "Disaster 2" three "Disaster 3" four "Disaster 4") replace r2	


	