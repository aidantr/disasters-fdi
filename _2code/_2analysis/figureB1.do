********************************************************************************
* Figure B1: Spillover effects excluding Mumbai and Banglore

********************************************************************************

use _1data/clean/clean_data, clear

** Exclude Mumbai and Bangalore:

drop if region=="mumbai" | region=="bangalore"

global control lag_lgdp lag_lpop

*generate months to event for new disasters

generate dif=1000
order region date Count dif

replace dif=Count-23 if Count<39 
replace dif=Count-55 if Count>=39 & Count <74 
replace dif=Count-93 if Count>=74 & Count <107 
replace dif=Count-122 if Count>=107 & Count <138 
replace dif=Count-155 if Count>=138



*generate affected region dummy for event study
gen affected_event=0
replace affected_event=1 if (Count<39 & (region=="kolkata" | region=="patna"))
replace affected_event=1 if (Count>=39 & Count <74 & (region=="bubaneshwar" | region=="guwahati" | region=="kolkata" | region=="patna"))
replace affected_event=1 if (Count>=74 & Count <107  & (region=="chandigarh" | region=="new_delhi" | region=="kanpur"))
replace affected_event=1 if (Count>=107 & Count <138   & (region=="hyderabad" | region=="chennai"))
replace affected_event=1 if (Count>=138  & region=="kochi")

*time to event variables as factors
tostring dif, replace

destring dif, replace
tab dif, gen(t_fe)

	

* Identify the pre-treatment month for the unaffected regions.
* These are the relavant pre-treatment dummies = 1 for the specific month for the affected regions
forvalues i=1/22 {
local j=23-`i'
gen pre_`j'=t_fe`i'
}

* Identify the post-treatment month for the affected regions.
* These are the relavant post-treatment dummies = 1 for the specific month for the affected regions
forvalues i=24/41{
local j=`i'-23
gen post_`j'=t_fe`i'
}

* Drop the t_fe* which are no longer needed:
drop t_fe*



sort region date

reg fdi_ihs pre* post* $control i.region1 if (affected_event==0), robust

boottest {pre_19} {pre_18} {pre_17} {pre_16} {pre_15} {pre_14} {pre_13} {pre_12} ///
		{pre_11} {pre_10} {pre_9} {pre_8} {pre_7} {pre_6} {pre_5} {pre_4} ///
		{pre_3} {pre_2} {pre_1} {post_1} {post_2} {post_3} {post_4}  {post_5} ///
		{post_6} {post_7} {post_8} {post_9} {post_10} {post_11} {post_12} {post_13} ///
		{post_14} {post_15} {post_16} {post_17} {post_18}  ///
		, reps(9999) gridpoints(10)  bootcluster(region1 date) nograph seed(123)
		
** These are too many coefficients to report and I like to create my own coeffient plot
** Here is the code:

* Pull coefficients into matrix:
* Pull coefficients into matrix:
mat beta=e(b)

** Average Treatment Effects:
mat A = beta[1,4..40]

mat pre= A[1,1..18]
mat post= A[1,19..37]

* Need to set the reference month at 0:
mat pre_post=(pre, 0, post)
mat list pre_post


** Create a counter column:
mat Z=J(1,38,0)
local j=1
forvalues i=-18/19 {
mat Z[1,`j'] = `i'
local j=`j'+1
}

** Grab the confidence intervals and append them together:
mat CI=r(CI_1)





mat missing=J(1,2,.)
forvalues i=2/18 {
capture confirm mat r(CI_`i')
if !_rc {
mat CI=CI\r(CI_`i')
}
else {
mat CI=CI\missing
}
}

mat zero=J(1,2,0)
mat CI = CI\zero

forvalues i=19/37 {
capture confirm mat r(CI_`i')
if !_rc {
mat CI=CI\r(CI_`i')
}
else {
mat CI=CI\missing
}
}
mat list CI


** Build Coefficient and Confidence Interval Matrix:
mat AZ= (Z', pre_post')
mat AZ= AZ,CI
mat list AZ
* Create variables from matrix so that you can graph them:
svmat AZ, names(direct)
sort direct1




** Coefficient estimates and CI are in IHS terms.
* We can transform coefficient estimates in relative terms (i.e. % change):
forvalues i = 5/7 {
local j=`i'-3
gen direct`i' = (exp(direct`j')-1)*100
}


* We can also transform coefficient estimates in absolute terms ($ mil.):
** For this we need to know the average value of FDI in the pre-treatment month for each affected region
** Then we take the average of that because the coefficient estimate is evaluated against this average:

* Generate pre-treatment average FDI inflows for each affected region:
egen pre_fdi_avg = mean(fdi) if inlist(dif, 0) & affected_event==0
bysort id (pre_fdi_avg): replace pre_fdi_avg = pre_fdi_avg[1]
sum pre_fdi_avg



* Convert relative changes to absolute changes 
/* Remember direct2 is already in percentage terms */

forvalues i=8/10 {
local j=`i'-6
gen direct`i'= asinh(pre_fdi_avg) + direct`j'
replace direct`i'=sinh(direct`i') - pre_fdi_avg
}

* Let's graph the relative changes with CI and the absolute changes in FDI:
*** The confidence interval reaches to far and messes up the scale of the graph.
** We restrict the cofidence interval to max 300 see note on figure


* FIGURE 5.B: Indirect IHS FDI Effect:
sort direct1
sum direct2  
sum direct2  if direct1>0



graph twoway (rarea direct3 direct4 direct1 if inrange(direct1,-18,18), color(gs10%20) fintensity(100))  ///
	(connected direct2 direct1 if inrange(direct1,-18,18), msize(medium) xline(0 ) yline(0 ) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in IHS of FDI", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0, axis(1) lcolor(black)) yline(0, axis(2 1) lcolor(black)) ///
	name(event_indirect, replace) xscale(r(-18,18)) xlabel(-18(4)18) ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+1)) ///
	legend(off)
	


graph export _3results/figures/figureB1.pdf, replace



	