
********************************************************************************
* Table 2: Spatial difference-in-differences

********************************************************************************


use _1data/clean/clean_data, clear


 
** Set the control variables:
global control lag_lgdp lag_lpop

*keep if date >= ym(2006,1)
*reg fdi_ihs one two three four five $control i.date i.region1, cluster(region1)
tab region




**********************************************************************************
***** Build Contiguity Matrix:
**********************************************************************************

** Sort Regions North to South and West to East:
gen mat_region_id = .
replace mat_region_id=1 if region=="chandigarh"  /// himachal pradesh, punjab, haryana, chandigarh  
/// neighbors with: jaipur, new delhi, kanpur

replace mat_region_id=2 if region=="jaipur" /// rajasthan 
/// neighbors with: ahmedabad, chandigarh, kanpur, bhopal

replace mat_region_id=3 if region=="new_delhi" /// delhi 
/// neighbors with: chandigarh, kanpur

replace mat_region_id=4 if region=="kanpur" /// Uttarakhand, uttar pradesh 
/// neighbors with: chandigarh, new delhi, jaipur, bhopal, patna

replace mat_region_id=5 if region=="ahmedabad" /// Gujarat
/// neighbors with: jaipur, bhopal, mumbai

replace mat_region_id=6 if region=="bhopal" /// Madhya pradesh, chhattisgarh
/// neighbors with: ahmedabad, jaipur, kanpur, panta, mumbai, bhubaneshwar, hyderabad

replace mat_region_id=7 if region=="patna" // jharkhand, bihar
/// neighbors with: kanpur, bhopal, bhubaneshwar, kolkata

replace mat_region_id=8 if region=="kolkata" // sikkim, west bengal
/// neighbors with: patna, bhubaneshwar, guwahati

replace mat_region_id=9 if region=="guwahati"  // assam, arunachal pradesh, manipur, mehalaya, mizoram, nagaland, tripura
/// neighbors with: kokata

replace mat_region_id=10 if region=="mumbai" // maharashtra, dadra, daman
/// neighbors with: ahmedabad, bhopal, panaji, bangalore, hyderabad

replace mat_region_id=11 if region=="bubaneshwar" // odisha
/// neighbors with: bhopal, patna, kolkata, hyderabad

replace mat_region_id=12 if region=="panaji" // goa
/// neighbors with: mumbai, bangalore

replace mat_region_id=13 if region=="bangalore" // karnataka
/// neighbors with: panaji, mumbai, hyderabad, kochi, chennai

replace mat_region_id=14 if region=="hyderabad" // andhra pradesh
/// neighbors with: bangalore, mumbai, bhopal, bhubaneshwar, chennai

replace mat_region_id=15 if region=="kochi" // kerala
/// neighbors with: bangalore, chennai

replace mat_region_id=16 if region=="chennai" // tamil nadu, puducherry
/// neighbors with: kochi, bangalore, hyderabad


*** Create Neighbor Matrix following Mat_Region_ID:
mat Cont1=J(16,16,0)

mat Cont1[1,2]=1   // neighbors to chandigarh: jaipur, new delhi, kanpur
mat Cont1[1,3]=1 
mat Cont1[1,4]=1 

mat Cont1[2,1]=1   // neighbors to jaipur: ahmedabad, chandigarh, kanpur, bhopal
mat Cont1[2,4]=1 
mat Cont1[2,5]=1 
mat Cont1[2,6]=1 

mat Cont1[3,1]=1   // neighbors to New Delhi: chandigarh, kanpur
mat Cont1[3,4]=1 

mat Cont1[4,1]=1   // neighbors to Kanpur: chandigarh, new delhi, jaipur, bhopal, patna
mat Cont1[4,2]=1 
mat Cont1[4,3]=1 
mat Cont1[4,6]=1 
mat Cont1[4,7]=1 

mat Cont1[5,2]=1   // neighbors to Ahmedabad: jaipur, bhopal, mumbai
mat Cont1[5,6]=1 
mat Cont1[5,10]=1 

mat Cont1[6,2]=1   // neighbors to Bhopal: ahmedabad, jaipur, kanpur, panta, mumbai, bhubaneshwar, hyderabad
mat Cont1[6,4]=1 
mat Cont1[6,5]=1 
mat Cont1[6,7]=1 
mat Cont1[6,10]=1 
mat Cont1[6,11]=1 
mat Cont1[6,14]=1 

mat Cont1[7,4]=1   // neighbors to Patna: kanpur, bhopal, bhubaneshwar, kolkata
mat Cont1[7,6]=1 
mat Cont1[7,8]=1 
mat Cont1[7,11]=1 

mat Cont1[8,7]=1   // neighbors to Kolkata: patna, bhubaneshwar, guwahati
mat Cont1[8,9]=1 
mat Cont1[8,11]=1 

mat Cont1[9,8]=1   // neighbors to Guwahati: kokata

mat Cont1[10,5]=1   // neighbors to mumbai: ahmedabad, bhopal, panaji, bangalore, hyderabad
mat Cont1[10,6]=1 
mat Cont1[10,12]=1 
mat Cont1[10,13]=1 
mat Cont1[10,14]=1 

mat Cont1[11,6]=1   // neighbors to bhubaneshwar: bhopal, patna, kolkata, hyderabad
mat Cont1[11,7]=1 
mat Cont1[11,8]=1 
mat Cont1[11,14]=1 

mat Cont1[12,10]=1   // neighbors to panaji:  mumbai, bangalore
mat Cont1[12,13]=1 

mat Cont1[13,10]=1   // neighbors to bangalore: panaji, mumbai, hyderabad, kochi, chennai
mat Cont1[13,12]=1 
mat Cont1[13,14]=1 
mat Cont1[13,15]=1 
mat Cont1[13,16]=1 

mat Cont1[14,6]=1   // neighbors to hyderabad: bangalore, mumbai, bhopal, bhubaneshwar, chennai
mat Cont1[14,10]=1 
mat Cont1[14,11]=1 
mat Cont1[14,13]=1 
mat Cont1[14,16]=1 

mat Cont1[15,13]=1   // neighbors to kochi: bangalore, chennai
mat Cont1[15,16]=1 

mat Cont1[16,13]=1   // neighbors to chennai: kochi, bangalore, hyderabad
mat Cont1[16,14]=1 
mat Cont1[16,15]=1 


mata : st_matrix("B", rowsum(st_matrix("Cont1")))

mat list B // max is 7

*Take the rowsum max (which is also column sum max) and divide each element by it: 
mata : C=st_matrix("Cont1")
mata : A=C:/7
mata : st_matrix("n_Cont1", A)
mat list n_Cont1


xtset mat_region_id date




********************************************************************************
******************* Inverse Distance Matrix
********************************************************************************

/** Upload longitude and latitude data by region:
insheet using Data/city_lat_long.csv, comma clear

keep city lat lng
sort city

replace city="ahmedabad" if city=="Ahmedabad"
replace city="bangalore" if city=="Bangalore"
replace city="bhopal" if city=="Bhopāl"
replace city="bubaneshwar" if city=="Bhubaneshwar"
replace city="chandigarh" if city=="Chandīgarh"
replace city="chennai" if city=="Chennai"
replace city="guwahati" if city=="Guwāhāti"
replace city="hyderabad" if city=="Hyderābād"
replace city="jaipur" if city=="Jaipur"
replace city="kanpur" if city=="Lucknow"
replace city="kochi" if city=="Kochi"
replace city="kolkata" if city=="Kolkāta"
replace city="mumbai" if city=="Mumbai"
replace city="new_delhi" if city=="Delhi"
replace city="panaji" if city=="Panaji"
replace city="patna" if city=="Patna"

rename city region
bysort region: gen id=_N
drop if id==2
save Data/city_lat_long, replace

*/

** Merge in City latitude and longitude data:
merge m:1 region using _1data/raw/spatial/city_lat_long
drop if _merge==2
drop _merge


** Create distance variables:
forvalues i=1/16 {
sort mat_region_id
gen lat1=lat if mat_region_id==`i' & date==tm(2005m10)
sort lat1
replace lat1=lat1[1]

gen lon1=lng if mat_region_id==`i' & date==tm(2005m10)
sort lon1
replace lon1=lon1[1]

geodist lat lng lat1 lon1, gen(dist`i')
replace dist`i'=1 if dist`i'<1

gen idist`i'=1/(dist`i')
replace idist`i'=0 if idist`i'==1

drop lat1 lon1 dist`i'

}
sort date mat_region_id

* Create matrix from distance variables:
mkmat idist1-idist16 if date==tm(2006m1), mat(idist)
mat list idist

* Normalize:
mata : st_matrix("r", rowsum(st_matrix("idist")))
mat list r // max is .02122661

*Take the rowsum max (which is also column sum max) and divide each element by it: 
mata : C=st_matrix("idist")
mata : A=C:/.02122661
mata : st_matrix("n_idist", A)
mat list n_idist



** Run regressions:

drop if lag_lgdp==.

xsmle fdi_ihs one two three four five $control, ///
	model(sac)  wmat(n_Cont1) emat(n_Cont1) fe type(both) effects cluster(mat_region_id) tech(bfgs 30 nr 30 )

	
xsmle fdi_ihs one two three four five $control, ///
	model(sac)  wmat(n_idist) emat(n_Cont1) fe type(both) effects cluster(mat_region_id) tech(bfgs 30 nr 30 )
	

	
	
	
	
	
