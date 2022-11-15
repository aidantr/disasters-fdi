************************************
** Clean 2001 Census Data***********
************************************

clear all

** 1) Skill measured via literacy and education:
import excel using _1data/raw/regional_characteristics/census/skill.xlsx, clear first 

drop in 1/2

rename StateUT State
rename Graduateabove grad

foreach var of varlis Literatewithouteducation-Unclassified {
destring `var' , replace force
}

egen literate = rowtotal(Literatewithouteducation-Unclassified)

keep State literate grad total_pop

** Clean state names:
replace State="Dadra and Nagar Haveli" if State=="Dadra & Nagar Haveli"
replace State="Andaman and Nicobar Islands" if State=="Andaman & Nicobar Islands"
replace State="Daman and Diu" if State=="Daman & Diu"
replace State="Jammu and Kashmir" if State=="Jammu & Kashmir"
replace State="Odisha" if State=="Orissa"
replace State="Puducherry" if State=="Pondicherry"
replace State="Uttarakhand" if State=="Uttaranchal"

** Merge region-to-state concordances
merge 1:1 State using _1data/xwalks/state_region_concordance


** Aggregate by region
collapse (sum) total_pop literate grad, by(District)
rename District region


** Calculate literacy and college graduate rates
gen lit_s = literate/total_pop *100
gen grad_s = grad/total_pop *100
drop grad literate total_pop


** Clean region:
replace region=lower(region)

replace region="new_delhi" if region=="new delhi"
replace region="guwahati" if region=="guwhati"
replace region="bubaneshwar" if region=="bhubaneshwar"
drop if region=="na"

save _1data/raw/regional_characteristics/census/skill , replace





** 2) Development measured via water access, electicity, and latrine:

import excel using _1data/raw/regional_characteristics/census/water_etc.xlsx, clear first

drop in 1/27
drop G I

drop if SNo==.
rename Sourceandlocationofdrinking source

keep if source=="All Sources" & inlist(D, "Total", "Within Premises")
drop source SNo

foreach var of varlist Totalnumberofhouseholds-Latrine {
destring `var', replace
}


rename StateUT State
bysort State: gen id=_n
bysort State (id): gen access_water = Totalnumberofhouseholds[2]
bysort State (id): gen access_elec = Electricity[2]
bysort State (id): gen access_lat = Latrine[2]


keep if D=="Total"


** Clean state names:
replace State=strrtrim(State)
replace State="Dadra and Nagar Haveli" if State=="Dadra & Nagar Haveli"
replace State="Andaman and Nicobar Islands" if State=="Andaman & Nicobar Islands"
replace State="Daman and Diu" if State=="Daman & Diu"
replace State="Jammu and Kashmir" if State=="Jammu & Kashmir"
replace State="Odisha" if State=="Orissa"
replace State="Puducherry" if State=="Pondicherry"
replace State="Uttarakhand" if State=="Uttaranchal"

** Merge region-to-state concordances
merge 1:1 State using _1data/xwalks/state_region_concordance
drop _merge D id Electricity Latrine 

** Aggregate by region
collapse (sum) Totalnumberofhouseholds-access_lat, by(District)
rename District region


** Calculate literacy and college graduate rates



gen water_s = access_water/Totalnumberofhouseholds * 100
gen elec_s = access_elec/Totalnumberofhouseholds *100
gen lat_s = access_lat/Totalnumberofhouseholds * 100

drop Totalnumberofhouseholds-access_lat


** Clean region:
replace region=lower(region)

replace region="new_delhi" if region=="new delhi"
replace region="guwahati" if region=="guwhati"
replace region="bubaneshwar" if region=="bhubaneshwar"
drop if region=="na"

save _1data/raw/regional_characteristics/census/development, replace




** 3) Composition of Employment

import excel using _1data/raw/regional_characteristics/census/employment.xlsx, first clear

drop in 1/2
drop if SNo ==.
rename StateUT State
rename TotalMainworkers total
rename WholesaleandRetailTrade retail

keep SNo State total retail Manufacturing G 

foreach var of varlist total-retail {
destring `var' , replace
} 

egen manu = rowtotal(Manufacturing G)
keep State total retail manu



** Clean state names:
replace State="Dadra and Nagar Haveli" if State=="Dadra & Nagar Haveli"
replace State="Andaman and Nicobar Islands" if State=="Andaman & Nicobar Islands"
replace State="Daman and Diu" if State=="Daman & Diu"
replace State="Jammu and Kashmir" if State=="Jammu & Kashmir"
replace State="Odisha" if State=="Orissa"
replace State="Puducherry" if State=="Pondicherry"
replace State="Uttarakhand" if State=="Uttaranchal"
replace State="Maharashtra" if State=="Maharastra"

** Merge region-to-state concordances
merge 1:1 State using _1data/xwalks/state_region_concordance

** Aggregate by region
collapse (sum) total-manu, by(District)
rename District region

** Calculate share of manufacturing or retail trade workers:
gen manu_s = manu/total *100
gen retail_s = retail/total *100

drop total retail manu

** Clean region:
replace region=lower(region)

replace region="new_delhi" if region=="new delhi"
replace region="guwahati" if region=="guwhati"
replace region="bubaneshwar" if region=="bhubaneshwar"
drop if region=="na"

save _1data/raw/regional_characteristics/census/employment, replace



** 4) Similarity in employment

import excel using _1data/raw/regional_characteristics/census/employment.xlsx, first clear

drop in 1/2
drop if SNo ==.
rename StateUT State
rename TotalMainworkers total
rename WholesaleandRetailTrade retail
rename Agriculturalalliedactivities agri
rename Miningandquarrying mining
rename Manufacturing manu1
rename G manu2
rename ElectricityGasandWaterSuppl util
rename Construction cons
rename HotelsandRestaurants leisure
rename TransportStorageandCommunica transp
rename FinancialIntermediationandRea finance
rename Otherservices other


foreach var of varlist total-other {
destring `var' , replace
} 


** Clean state names:
replace State="Dadra and Nagar Haveli" if State=="Dadra & Nagar Haveli"
replace State="Andaman and Nicobar Islands" if State=="Andaman & Nicobar Islands"
replace State="Daman and Diu" if State=="Daman & Diu"
replace State="Jammu and Kashmir" if State=="Jammu & Kashmir"
replace State="Odisha" if State=="Orissa"
replace State="Puducherry" if State=="Pondicherry"
replace State="Uttarakhand" if State=="Uttaranchal"
replace State="Maharashtra" if State=="Maharastra"

** Merge region-to-state concordances
merge 1:1 State using _1data/xwalks/state_region_concordance

** Aggregate by region
collapse (sum) total-other, by(District)
rename District region

** Calculate share of manufacturing or retail trade workers:
foreach var of varlist agri-other {
gen `var'_s = `var'/total *100
} 

drop total-other

** Clean region:
replace region=lower(region)

replace region="new_delhi" if region=="new delhi"
replace region="guwahati" if region=="guwhati"
replace region="bubaneshwar" if region=="bhubaneshwar"
drop if region=="na"


save _1data/raw/regional_characteristics/census/ind_comp, replace

