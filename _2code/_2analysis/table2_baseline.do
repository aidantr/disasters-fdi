
********************************************************************************
* Table 2: Baseline estimates

********************************************************************************


** Regression of IHS FDI with Year and Month fixed effects
* It's robust to true alternative fixed effect specificaions and not sensitive to changing controls
* We estimate the relative average treatment effect of each disaster separately and then jointly
* Then we measure the outcome variable (FDI) in absolute terms and logs (ln(FDI)), which ignores the negative and 0-valued FDI inflows


** Set the control variables:

use _1data/clean/clean_data, clear 

keep if date >= ym(2006,1)
global control lag_lgdp lag_lpop


*reg fdi_ihs one two three four five i.date i.region1, cluster(region1)

** Set up matrix:
mat p_val=J(8,9,.)
estimates clear
local j=1
foreach x in "one" "two" "three" "four" "five" "one two three four five" {
reg fdi_ihs `x' $control i.date i.region1, cluster(region1)




if "`x'"=="one" {
boottest {one} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[1,1]=r(p_1)
mat p_val[6,1]=r(p_2)
mat p_val[7,1]=r(p_3)
mat p_val[8,1]=r(p_4)
}

if "`x'"=="two" {
boottest {two} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[2,2]=r(p_1)
mat p_val[6,2]=r(p_2)
mat p_val[7,2]=r(p_3)
mat p_val[8,2]=r(p_4)
}
if "`x'"=="three" {
boottest {three} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[3,3]=r(p_1)
mat p_val[6,3]=r(p_2)
mat p_val[7,3]=r(p_3)
mat p_val[8,3]=r(p_4)
}
if "`x'"=="four" {
boottest {four} {lag_lgdp} {lag_lpop} {_cons},  reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[4,4]=r(p_1)
mat p_val[6,4]=r(p_2)
mat p_val[7,4]=r(p_3)
mat p_val[8,4]=r(p_4)
}
if "`x'"=="five" {
boottest {five} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[5,5]=r(p_1)
mat p_val[6,5]=r(p_2)
mat p_val[7,5]=r(p_3)
mat p_val[8,5]=r(p_4)
}
if "`x'"=="one two three four five" {
boottest {one} {two} {three} {four} {five} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[1,6]=r(p_1)
mat p_val[2,6]=r(p_2)
mat p_val[3,6]=r(p_3)
mat p_val[4,6]=r(p_4)
mat p_val[5,6]=r(p_5)
mat p_val[6,6]=r(p_6)
mat p_val[7,6]=r(p_7)
mat p_val[8,6]=r(p_8)
}

eststo tb1_`j'
local j=`j'+1

}


** Absolute FDI

reg fdi one two three four five $control i.date i.region1, cluster(region1)
boottest {one} {two} {three} {four} {five} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[1,8]=r(p_1)
mat p_val[2,8]=r(p_2)
mat p_val[3,8]=r(p_3)
mat p_val[4,8]=r(p_4)
mat p_val[5,8]=r(p_5)
mat p_val[6,8]=r(p_6)
mat p_val[7,8]=r(p_7)
mat p_val[8,8]=r(p_8)
eststo tb1_`j'
local j=`j'+1





* ROBUSTNESS - UNREPORTED: No controls:
reg fdi_ihs one two three four five i.date i.region1, cluster(region1)
boottest {one} {two} {three} {four} {five} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[1,7]=r(p_1)
mat p_val[2,7]=r(p_2)
mat p_val[3,7]=r(p_3)
mat p_val[4,7]=r(p_4)
mat p_val[5,7]=r(p_5)

mat p_val[8,7]=r(p_6)
eststo tb1_`j'
local j=`j'+1



* ROBUSTNESS - UNREPORTED: Logged FDI
reg lfdi one two three four five $control i.date i.region1, cluster(region1)
boottest {one} {two} {three} {four} {five} {lag_lgdp} {lag_lpop} {_cons}, reps(9999) gridpoints(10) cluster(region1 date) bootcluster(region1 date) nograph seed(123)
mat p_val[1,9]=r(p_1)
mat p_val[2,9]=r(p_2)
mat p_val[3,9]=r(p_3)
mat p_val[4,9]=r(p_4)
mat p_val[5,9]=r(p_5)
mat p_val[6,9]=r(p_6)
mat p_val[7,9]=r(p_7)
mat p_val[8,9]=r(p_8)

eststo tb1_`j'



mat list p_val
outtable using _3results/tables/p_val1, mat(p_val) replace format(%9.3f) norow nodots

esttab _all using _3results/tables/table2_baseline.tex, order(one two three four five lag_lgdp lag_lpop _cons) keep(one two three four five lag_lgdp lag_lpop _cons)  ///
	nostar b(3) p(3) coeflabel(lag_lgdp "Lagged ln(GDP)" lag_lpop "Lagged ln(Pop.)" _cons "Constant") replace r2	


	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	