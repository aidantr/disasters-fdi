
********************************************************************************
* Table 1: Regional Sample Averages

********************************************************************************

use _1data/clean/clean_data, clear

keep if date >= ym(2006,1)


gen disaster = 0
replace disaster = 1 if inlist(region, "kolkata", "patna")
replace disaster = 2 if inlist(region, "bubaneshwar", "guwahati", "kolkata", "patna")
replace disaster = 3 if inlist(region, "chandigarh", "kanpur", "new_delhi")
replace disaster = 4 if inlist(region, "chennai", "hyderabad")
replace disaster = 5 if inlist(region, "kochi")


replace GDP=GDP/1000
replace pop=pop/1000


estimates clear

estpost tabstat fdi disaster GDP pop density urban lat_s port lit_s grad_s manu_s, ///
	by(region) statistics(mean) nototal

esttab using _3results/tables/table1.tex, cells("fdi(fmt(1)) disaster(fmt(0)) GDP pop density urban lat_s port lit_s grad_s manu_s") ///
	noobs nomtitle nonumber replace


