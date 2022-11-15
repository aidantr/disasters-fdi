
********************************************************************************
* Table 4: Spillover Patterns

********************************************************************************

use _1data/clean/clean_data, clear


** Set the control variables:
global control lag_lgdp lag_lpop

** Identify spillovers:
* Note: * indicate additional spillover weights that don't produce meaningful results

* five events:
global x "one two three four five"

* Risk
foreach v of varlist one_damages_cum_past20-five_damages_cum_past20 {
replace `v'=ln(`v'+1)
}
global spil1 "one_damages_cum_past20 two_damages_cum_past20 three_damages_cum_past20 four_damages_cum_past20 five_damages_cum_past20"

global spil2 "one_number_major2_past20 two_number_major2_past20 three_number_major2_past20 four_number_major2_past20 five_number_major2_past20"

* Development characteristics:
global spil3 "one_density two_density three_density four_density five_density"
global spil4 "one_urban two_urban three_urban four_urban five_urban"
global spil5 "one_elec_s two_elec_s three_elec_s four_elec_s five_elec_s"


* Infrastructure characteristics:
global spil6 "one_port two_port three_port four_port five_port"


* Labor skill and composition characteristics:
global spil7 "one_grad_s two_grad_s three_grad_s four_grad_s five_grad_s"

global spil8 "one_manu_s two_manu_s  three_manu_s  four_manu_s  five_manu_s "


* Economic similarity
global spil9 "one_sim two_sim three_sim four_sim five_sim"

* Geography Spillovers: 
global spil10 "one_cont two_cont three_cont four_cont five_cont"



* Define empty p-value matrix:
mat p_val4=J(10,10,.)

*** Regression with all five events by spillover characteristic:
estimates clear
local j=1
foreach y in "$spil1" "$spil2" "$spil3" "$spil4" "$spil5" "$spil6" "$spil7" "$spil8" "$spil9" "$spil10" {
reg fdi_ihs $x `y' $control i.date i.region1, cluster(region1)


if "`y'"=="$spil1" {
boottest {one} {two} {three} {four} {five} ///
	{one_damages_cum_past20} {two_damages_cum_past20} {three_damages_cum_past20} {four_damages_cum_past20} {five_damages_cum_past20} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}

if "`y'"=="$spil2" {
boottest {one} {two} {three} {four} {five} ///
	{one_number_major2_past20} {two_number_major2_past20} {three_number_major2_past20} {four_number_major2_past20} {five_number_major2_past20} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}


if "`y'"=="$spil3" {
boottest {one} {two} {three} {four} {five} ///
	{one_density} {two_density} {three_density} {four_density} {five_density} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}


if "`y'"=="$spil4" {
boottest {one} {two} {three} {four} {five} ///
	{one_urban} {two_urban} {three_urban} {four_urban} {five_urban} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}

if "`y'"=="$spil5" {
boottest  {one} {two} {three} {four} {five} ///
	{one_elec_s} {two_elec_s} {three_elec_s} {four_elec_s} {five_elec_s} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}


if "`y'"=="$spil6" {
boottest {one} {two} {three} {four} {five} ///
	{one_port} {two_port} {three_port} {four_port} {five_port} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}

if "`y'"=="$spil7" {
boottest {one} {two} {three} {four} {five} ///
	{one_grad_s} {two_grad_s} {three_grad_s} {four_grad_s} {five_grad_s} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}



if "`y'"=="$spil8" {
boottest {one} {two} {three} {four} {five} ///
	{one_manu_s} {two_manu_s} {three_manu_s} {four_manu_s} {five_manu_s} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}

if "`y'"=="$spil9" {
boottest {one} {two} {three} {four} {five} ///
	{one_sim} {two_sim} {three_sim} {four_sim} {five_sim} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}


if "`y'"=="$spil10" {
boottest {one} {two} {three} {four} {five} ///
	{one_cont} {two_cont} {three_cont} {four_cont} {five_cont} ///
	, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
}




* Collect p-values:


forvalues i=1/10 {
mat p_val4[`i',`j']=r(p_`i')
mat p_val4[`i',`j'] = round(p_val4[`i',`j'], 0.001)

}


eststo spil`j'
local j=`j'+1

}


mat list p_val4

outtable using _3results/tables/p_val4, mat(p_val4) replace format(%9.3f) norow nodots


esttab _all using _3results/tables/table4.tex, rename(one_damages_cum_past20 one_spil two_damages_cum_past20 two_spil ///
	three_damages_cum_past20 three_spil four_damages_cum_past20 four_spil five_damages_cum_past20 five_spil ///
    one_number_major2_past20 one_spil two_number_major2_past20 two_spil three_number_major2_past20 three_spil ///
	four_number_major2_past20 four_spil five_number_major2_past20 five_spil ///
    one_cont one_spil one_distance one_spil one_density one_spil one_urban one_spil ///
	one_water_s one_spil one_elec_s one_spil one_lat_s one_spil one_gq one_spil one_port one_spil ///
	one_lit_s one_spil one_grad_s one_spil one_manu_s one_spil one_retail_s one_spil one_sim one_spil ///
	two_cont two_spil two_distance two_spil two_density two_spil two_urban two_spil ///
	two_water_s two_spil two_elec_s two_spil two_lat_s two_spil two_gq two_spil two_port two_spil ///
	two_lit_s two_spil two_grad_s two_spil two_manu_s two_spil two_retail_s two_spil two_sim two_spil ///
	three_cont three_spil three_distance three_spil three_density three_spil three_urban three_spil ///
	three_water_s three_spil three_elec_s three_spil three_lat_s three_spil three_gq three_spil three_port three_spil ///
	three_lit_s three_spil three_grad_s three_spil three_manu_s three_spil three_retail_s three_spil three_sim three_spil ///
	four_cont four_spil four_distance four_spil four_density four_spil four_urban four_spil ///
	four_water_s four_spil four_elec_s four_spil four_lat_s four_spil four_gq four_spil four_port four_spil ///
	four_lit_s four_spil four_grad_s four_spil four_manu_s four_spil four_retail_s four_spil four_sim four_spil ///
	five_cont five_spil five_distance five_spil five_density five_spil five_urban five_spil ///
	five_water_s five_spil five_elec_s five_spil five_lat_s five_spil five_gq five_spil five_port five_spil ///
	five_lit_s five_spil five_grad_s five_spil five_manu_s five_spil five_retail_s five_spil five_sim five_spil) ///
	order(one two three four five one_spil two_spil three_spil four_spil five_spil) replace nostar r2 b(3) p(3)
	
	







