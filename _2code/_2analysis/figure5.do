
********************************************************************************
* Figure 5: Event studies

********************************************************************************

use _1data/clean/clean_data, clear

global control lag_lgdp lag_lpop


*generate months to event

generate dif=1000
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
forvalues i=1/21 {
local j=22-`i'
gen pre_`j'=t_fe`i'
}


* Identify the post-treatment month for the affected regions.
* These are the relavant post-treatment dummies = 1 for the specific month for the affected regions
forvalues i=23/41{
local j=`i'-22
gen post_`j'=t_fe`i'
}


*** Event study regression on AFFECTED REGIONS:

reg fdi_ihs pre* post* $control i.region1 if (affected_event==1), robust

boottest {pre_18} {pre_17} {pre_16} {pre_15} {pre_14} {pre_13} {pre_12} ///
		{pre_11} {pre_10} {pre_9} {pre_8} {pre_7} {pre_6} {pre_5} {pre_4} ///
		{pre_3} {pre_2} {pre_1} {post_1} {post_2} {post_3} {post_4}  {post_5} ///
		{post_6} {post_7} {post_8} {post_9} {post_10} {post_11} {post_12} {post_13} ///
		{post_14} {post_15} {post_16} {post_17} {post_18} {post_19} ///
		, reps(9999) gridpoints(10) bootcluster(region1 date) nograph seed(123) 


** These are too many coefficients to report and I like to create my own coeffient plot
** Here is the code:

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
egen pre_fdi_avg = mean(fdi) if inlist(dif, -1) & affected_event==1
bysort id (pre_fdi_avg): replace pre_fdi_avg = pre_fdi_avg[1]
sum pre_fdi_avg


* Convert relative changes to absolute changes 
/* Remember direct2 is already in percentage terms */

forvalues i=8/10 {
local j=`i'-6
gen direct`i'= asinh(pre_fdi_avg) + direct`j'
replace direct`i'=sinh(direct`i') - pre_fdi_avg
}



* FIGURE 5A: IHS FDI Effect:
sort direct1
sum direct5  if direct1>0



graph twoway (rarea direct3 direct4 direct1 if inrange(direct1,-18,18), color(gs10%20) fintensity(100))  ///
	(connected direct2 direct1 if inrange(direct1,-18,18), msize(medium) xline(0) yline(0) lc(ebblue) mc(ebblue%70) msymbol(circle)) ///
	, ytitle("Change in IHS of FDI", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0) yline(0, axis(2 1)) ///
	name(event_direct, replace) xscale(r(-18,18)) xlabel(-18(4)18) ///
	ylabel( , angle(horizontal)) yscale(titlegap(*+1)) ///
	legend(off)
	
	

	
	*legend(order(2 1) lab(1 "95% C. I.") lab(2 "Relative Change in FDI (%)") col(2) position(6)) ///
	
	
	
	*note("Note: Changes in IHS-transformed FDI are depicted with their respective 95% C.I. Point" ///
	*"      estimates are based on 405 observations and range from -2.98 to 0.49. The regression produces" ///
	*"      an R-squared of 0.79 and the C.I. is based on two-way wild cluster bootstrapped standard errors.")


graph export _3results/figures/figure5a.pdf, replace


** FIGURE 5.C: Relative FDI Effects
sum direct5
sum direct5 if direct1>0
 	
graph twoway (connected direct5 direct1 if inrange(direct1,-18,18), msize(medium) xline(0 ) yline(0 ) lc(ebblue) mc(ebblue%70) msymbol(circle)) ///
	, ytitle("Change in FDI (%)", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0, axis(1)) yline(0, axis(2 1)) ///
	name(event_direct_rel, replace) xscale(r(-18,19)) xlabel(-18(4)19) yscale(r(-100,75)) ylabel(-100(25)75)  ///
	yscale(titlegap(*+1)) //////
	
	
	*legend(lab(1 "Relative Change in FDI (%)")) ///
	
	*note("Note: Transformed point estimates range from -94.9% to 62.6% and average -86.3% post disaster.")

graph export _3results/figures/figure5c.pdf, replace



* FIGURE 5.E: Absolute FDI Effect:
sum direct8
sum direct8 pre_fdi_avg if direct1>0
replace direct10=200 if direct10>200


graph twoway (connected direct8 direct1 if inrange(direct1,-18,18), msize(medium) xline(0) yline(0) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in FDI ($ mil.)") xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0 ) yline(0) ///
	name(event_direct_abs, replace) xscale(r(-18, 19)) xlabel(-18(4)19) ///
	yscale(titlegap(*+1)) ///
	
	
	*note("Note: Absolute changes in FDI are calculated based the average FDI value of $154 mil." ///
	*"         observed during the excluded reference month in the affected regions. Transformed point" ///
	*"         estimates range from -$146 million to $96 million and average -$133 million post treatment.") 



graph export _3results/figures/figure5e.pdf, replace
	


	
	
	
	
	
*********************************************************************
*** Event study regression on unaffected regions:
*********************************************************************

** Reload the data (since I had droped two regions for the dynamic analysis):

drop pre* post* direct*


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
		{post_14} {post_15} {post_16} {post_17} {post_18} ///
		, reps(9999) gridpoints(10)  bootcluster(region1) nograph seed(123)
		
** These are too many coefficients to report and I like to create my own coeffient plot
** Here is the code:
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

*fill up 

gsort -direct1
replace pre_fdi_avg = pre_fdi_avg[_n-1] if missing(pre_fdi_avg)
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

graph twoway (rarea direct3 direct4 direct1 if inrange(direct1,-18,18), color(gs10%20))  ///
	(connected direct2 direct1 if inrange(direct1,-18,18), msize(medium) xline(0 ) yline(0 ) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in IHS of FDI", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0, axis(1) lcolor(black)) yline(0, axis(2 1) lcolor(black)) ///
	name(event_indirect, replace) xscale(r(-18,18)) xlabel(-18(4)18) ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+1)) ///
	legend(off)
	
	
	
	*legend(order(2 1) lab(1 "95% C. I.") lab(2 "Relative Change in FDI (%)") col(2) position(6)) ///
	
	
	
	*note("Note: Changes in IHS-transformed FDI are depicted with their respective 95% confidence interval." ///
	*"      Point estimates are based on 2,283 observations and range from -0.08 to 0.94. The regression" ///
	*"      produces an R-squared of 0.75 and standard errors are heteroskedasticity-robust.")


graph export _3results/figures/figure5b.pdf, replace


* FIGURE 5.D: INDIRECT RELATIVE FDI EFFECTS	
sum direct5 
sum direct5 if direct1>0
graph twoway (connected direct5 direct1 if inrange(direct1,-18,18), msize(medium) xline(0 ) yline(0 ) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in FDI (%)", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0, axis(1) lcolor(black)) yline(0, axis(2 1) lcolor(black)) yscale(titlegap(*+1)) ///
	name(event_indirect_rel, replace) yscale(r(-25,150)) ylabel(-25(25)150) xscale(r(-18,19)) xlabel(-18(4)19) ///
	
	
	*legend(order(2 1) lab(1 "95% C. I.") lab(2 "Relative Change in FDI (%)")) ///
	*note("Note: Transformed point estimates range from -8.0% to 156.3% and average 93.7% post disaster.")
	

graph export _3results/figures/figure5d.pdf, replace


* FIGURE 5.F: INDIRECT ABSOLUTE FDI EFFECTS:	
sum direct8 pre_fdi_avg
sum direct8 if direct1>0
replace direct10=200 if direct10>200

graph twoway (connected direct8 direct1 if inrange(direct1,-18,18), msize(medium) xline(0 ) yline(0 ) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in FDI ($ mil.)") xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0 ) yline(0 ) ///
	name(event_indirect_abs, replace) yscale(r(-25,150)) ylabel(-25(25)150) xscale(r(-18, 19)) xlabel(-18(4)19) ///
	yscale(titlegap(*+1)) ///
	
	
	*note("Note: Absolute changes in FDI are calculated based on the average FDI value of $94 mil." ///
	*"         observed during the excluded reference month in the unaffected regions. Transformed" ///
	*"         point estimates range from -$8 million to $146 million and average $88 million post treatment.")


graph export _3results/figures/figure5f.pdf, replace




	



