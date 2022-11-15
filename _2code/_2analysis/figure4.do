********************************************************************************
* Figure 4: Dynamic difference-in-differences

********************************************************************************

** To do this we can only include regions that were treated one time or those that were never treated
** This implies we exclude Patna and Kolkata and focus only on disasters 2 through 5. 
** We also test the robustness of this assumption if we only include those regions that appear to be
** on similar trends and therefore exclude all regions affect by disasters 1, 2, and 5:


use _1data/clean/clean_data, clear 

global control lag_lgdp lag_lpop

** 2.1 Full Sample (only excluding Patna and Kolkata):
drop if inlist(region, "patna", "kolkata")


* We evaluate these treatment effects against a refence month (i.e. the month before the disaster),
* which changes for every disaster

* Here we put the timing of every disaster on the same footing:
* For example, for each region t=0 the month before the disaster struck:

gen t=Count-171
tab Count if two_bin==1
replace t=t+(171-54) if region=="bubaneshwar" | region=="guwahati"

tab Count if three_bin==1
replace t=t+(171-92) if region=="chandigarh" | region=="new_delhi" | region=="kanpur"

tab Count if four_bin==1
replace t=t+(171-121) if region=="hyderabad" | region=="chennai"


tab Count if five_bin==1
replace t=t+(171-154) if region=="kochi"




* Generate fixed effects based on these values
tab t, gen(t_fe)


forvalues i=1/288 {
* Remove the t_fe=1 for untreated regions:
replace t_fe`i'=0 if !inlist(region, "bubaneshwar", "guwhati", "chandigarh", "new_delhi", "kanpur", "chennai", "hyderabad", "kochi")

* Drop the t_fe that are always zero (i.e. we never observe a the month 171 before the disaster bc there is no 
* region that was treated the last month of our sample. Therefore we must drop t_fe171):
sum t_fe`i'
if r(max)==0 {
drop t_fe`i'
}
}

* Drop the fixed effect for the reference month:
drop t_fe171
sort region date
* Identify the pre-treatment month for the affected regions.
* These are the relavant pre-treatment dummies = 1 for the specific month for the affected regions
forvalues i=18/170 {
local j=171-`i'
gen pre_`j'=t_fe`i'
}

* Identify the post-treatment month for the affected regions.
* These are the relavant post-treatment dummies = 1 for the specific month for the affected regions
forvalues i=172/288{
local j=`i'-171
gen post_`j'=t_fe`i'
}

* Drop the t_fe* which are no longer needed:
drop t_fe*





** Set up CI matrix:


*** Dynamic Dif-in-Difs regression with controls and region and time fixed effects:


reg fdi_ihs pre* post* $control i.date i.region1, robust 

boottest {pre_72} {pre_71} {pre_70} ///
		{pre_69} {pre_68} {pre_67} {pre_66} {pre_65} {pre_64} {pre_63} {pre_62} {pre_61} {pre_60} ///
		{pre_59} {pre_58} {pre_57} {pre_56} {pre_55} {pre_54} {pre_53} {pre_52} {pre_51} {pre_50} ///
		{pre_49} {pre_48} {pre_47} {pre_46} {pre_45} {pre_44} {pre_43} {pre_42} {pre_41} {pre_40} ///
		{pre_39} {pre_38} {pre_37} {pre_36} {pre_35} {pre_34} {pre_33} {pre_32} {pre_31} {pre_30} ///
		{pre_29} {pre_28} {pre_27} {pre_26} {pre_25} {pre_24} {pre_23} {pre_22} {pre_21} {pre_20} ///
		{pre_19} {pre_18} {pre_17} {pre_16} {pre_15} {pre_14} {pre_13} {pre_12} {pre_11} {pre_10} ///
		{pre_9} {pre_8} {pre_7} {pre_6} {pre_5} {pre_4} {pre_3} {pre_2} {pre_1} ///
		{post_1} {post_2} {post_3} {post_4}  {post_5} {post_6} {post_7} {post_8} {post_9} ///
		{post_10} {post_11} {post_12} {post_13} {post_14} {post_15} {post_16} {post_17} {post_18} {post_19} ///
		{post_20} {post_21} {post_22} {post_23} {post_24} {post_25} {post_26} {post_27} {post_28} {post_29} ///
		{post_30} {post_31} {post_32} {post_33} {post_34} {post_35} {post_36} {post_37} {post_38} {post_39} ///
		{post_40} {post_41} {post_42} {post_43} {post_44} {post_45} {post_46} {post_47} {post_48} {post_49} ///
		{post_50} {post_51} {post_52} {post_53} {post_54} {post_55} {post_56} {post_57} {post_58} {post_59} ///
		{post_60} {post_61} {post_62} {post_63} {post_64} {post_65} {post_66} {post_67} {post_68} {post_69} ///
		{post_70} {post_71} {post_72} ///
		, reps(9999) gridpoints(10) boottype(wild)  bootcluster(region1 date) nograph seed(123)


** These are too many coefficients to report and I like to create my own coeffient plot
** Here is the code:

* Pull coefficients into matrix:
mat beta=e(b)

** Average Treatment Effects:
mat A = beta[1,82..225]

mat pre= A[1,1..72]
mat post= A[1,73..144]

* Need to set the reference month at 0:
mat pre_post=(pre, 0, post)
mat list pre_post


** Create a counter column:
mat Z=J(1,145,0)
local j=1
forvalues i=-72/72 {
mat Z[1,`j'] = `i'
local j=`j'+1
}

** Grab the confidence intervals and append them together:
mat CI=r(CI_1)
mat missing=J(1,2,.)
forvalues i=2/72 {
capture confirm mat r(CI_`i')
if !_rc {
mat temp = r(CI_`i')
mat temp2 = temp[1, 1 .. 2]

mat CI=CI\temp2
}
else {
mat CI=CI\missing
}
}

mat zero=J(1,2,0)
mat CI = CI\zero

forvalues i=73/144 {
capture confirm mat r(CI_`i')
if !_rc {
mat temp = r(CI_`i')
mat temp2 = temp[1, 1 .. 2]

mat CI=CI\temp2
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


sort direct1
sum direct2 direct3 direct4 

graph twoway (rarea direct3 direct4 direct1, color(gs10%20) )  ///
	(connected direct2 direct1, xline(0) yline(0) lc(ebblue) mc(ebblue%70) msymbol(smccircle)) ///
	, ytitle("Change in IHS of FDI", ax(1)) xtitle("Month Relative to Disaster") ///
	scheme(plotplain)  xline(0, axis(1) ) yline(0, axis(2 1)) ///
	name(dynamic_did, replace) xscale(r(-72, 72)) xlabel(-72(12)72) ///
	ylabel( , angle(horizontal)) yscale(titlegap(*+1)) ///
	legend(off) ///
	
	
	
	
graph export _3results/figures/figure4.pdf, replace








