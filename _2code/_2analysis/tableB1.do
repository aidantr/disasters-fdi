
use _1data/clean/clean_data, clear

** Regression of IHS FDI with Year and Month fixed effects
* USING ONLY CENTROIDS OF FLOODS/STORMS AS TREATED REGION

** Merge centroid regions:
merge m:1 region using _1data/raw/disasters/centroid_regions.dta
drop _merge

** redefine treatment variables:
drop one two three four five

gen one = one_bin*one_centroid 
gen two = two_bin*two_centroid 
gen three = three_bin*three_centroid 
gen four = four_bin*four_centroid 
gen five = five_bin*five_centroid

** Set the control variables:
global control lag_lgdp lag_lpop

** Identify regions partially affected:
gen partial = 0
foreach x in "one" "two" "three" "four" "five" {
replace partial=1 if `x'_affected==1 & `x'_centroid==0
}

** Set up matrix:
mat p_val=J(8,6,.)
estimates clear
local j=1
foreach x in "one" "two" "three" "four" "five" "one two three four five" {
reg fdi_ihs `x' $control i.date i.region1 if partial==0, cluster(region1)

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



mat list p_val
outtable using _3results/tables/p_val_b1, mat(p_val) replace format(%9.3f) norow nodots

esttab _all using _3results/tables/tableb2.tex, order(one two three four five lag_lgdp lag_lpop _cons) keep(one two three four five lag_lgdp lag_lpop _cons)  ///
	nostar b(3) p(3) coeflabel(lag_lgdp "Lagged ln(GDP)" lag_lpop "Lagged ln(Pop.)" _cons "Constant") replace r2	

	

	
