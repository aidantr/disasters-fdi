/*******************************************************************************
Create disaster risk by region based on past disasters


********************************************************************************/

use _1data/xwalks/regions_list.dta, clear

*past 10 years
generate damages_cum_past10=0
generate number_major1_past10=0
generate number_major2_past10=0
generate number_any_past10=0
generate number_flood_past10=0


replace damages_cum_past10 = 5853100 if region == "ahmedabad"
replace damages_cum_past10 = 1500300 if region == "bangalore"
replace damages_cum_past10 = 90400 if region == "bhopal"
replace damages_cum_past10 = 3322800 if region == "bubaneshwar"
replace damages_cum_past10 = 116924 if region == "chandigarh"
replace damages_cum_past10 = 4214300 if region == "chennai"
replace damages_cum_past10 = 2623000 if region == "guwahati"
replace damages_cum_past10 = 7051000 if region == "hyderabad"
replace damages_cum_past10 =158000 if region == "jaipur"
replace damages_cum_past10 = 276000 if region == "kanpur"
replace damages_cum_past10 = 13138240 if region == "kochi"
replace damages_cum_past10 = 1022930 if region == "kolkata"
replace damages_cum_past10 = 2300000 if region == "mumbai"
replace damages_cum_past10 = 7830 if region == "new_delhi"
replace damages_cum_past10 = 1585300 if region == "panaji"
replace damages_cum_past10 = 691500 if region == "patna"

replace number_major1_past10 = 3 if region == "ahmedabad"
replace number_major1_past10  = 1 if region == "bangalore"
replace number_major1_past10  = 0 if region == "bhopal"
replace number_major1_past10  = 2 if region == "bubaneshwar"
replace number_major1_past10  = 0 if region == "chandigarh"
replace number_major1_past10  = 4 if region == "chennai"
replace number_major1_past10  = 1 if region == "guwahati"
replace number_major1_past10  = 5 if region == "hyderabad"
replace number_major1_past10  = 0 if region == "jaipur"
replace number_major1_past10  = 0 if region == "kanpur"
replace number_major1_past10  = 7 if region == "kochi"
replace number_major1_past10  = 1 if region == "kolkata"
replace number_major1_past10  = 1 if region == "mumbai"
replace number_major1_past10  = 0 if region == "new_delhi"
replace number_major1_past10  = 1 if region == "panaji"
replace number_major1_past10  = 1 if region == "patna"

replace number_major2_past10 = 1 if region == "ahmedabad"
replace number_major2_past10  = 0 if region == "bangalore"
replace number_major2_past10  = 0 if region == "bhopal"
replace number_major2_past10  = 1 if region == "bubaneshwar"
replace number_major2_past10  = 0 if region == "chandigarh"
replace number_major2_past10  = 1 if region == "chennai"
replace number_major2_past10  = 1 if region == "guwahati"
replace number_major2_past10  = 2 if region == "hyderabad"
replace number_major2_past10  = 0 if region == "jaipur"
replace number_major2_past10  = 0 if region == "kanpur"
replace number_major2_past10  = 2 if region == "kochi"
replace number_major2_past10  = 0 if region == "kolkata"
replace number_major2_past10  = 1 if region == "mumbai"
replace number_major2_past10  = 0 if region == "new_delhi"
replace number_major2_past10  = 0 if region == "panaji"
replace number_major2_past10  = 0 if region == "patna"

replace number_any_past10 = 23 if region == "ahmedabad"
replace number_any_past10  = 39 if region == "bangalore"
replace number_any_past10  = 33 if region == "bhopal"
replace number_any_past10  = 23 if region == "bubaneshwar"
replace number_any_past10  = 30 if region == "chandigarh"
replace number_any_past10  = 40 if region == "chennai"
replace number_any_past10  = 34 if region == "guwahati"
replace number_any_past10  =18 if region == "hyderabad"
replace number_any_past10  = 34 if region == "jaipur"
replace number_any_past10  = 7 if region == "kanpur"
replace number_any_past10  = 35 if region == "kochi"
replace number_any_past10  = 20 if region == "kolkata"
replace number_any_past10  = 31 if region == "mumbai"
replace number_any_past10  = 38 if region == "new_delhi"
replace number_any_past10  = 46 if region == "panaji"
replace number_any_past10  = 20 if region == "patna"

replace number_flood_past10 = 13 if region == "ahmedabad"
replace number_flood_past10  = 25 if region == "bangalore"
replace number_flood_past10  = 20 if region == "bhopal"
replace number_flood_past10  = 13 if region == "bubaneshwar"
replace number_flood_past10  = 18 if region == "chandigarh"
replace number_flood_past10  = 26 if region == "chennai"
replace number_flood_past10  = 21 if region == "guwahati"
replace number_flood_past10  = 10 if region == "hyderabad"
replace number_flood_past10  = 21 if region == "jaipur"
replace number_flood_past10  = 3 if region == "kanpur"
replace number_flood_past10  = 21 if region == "kochi"
replace number_flood_past10  = 12 if region == "kolkata"
replace number_flood_past10  = 19 if region == "mumbai"
replace number_flood_past10  = 24 if region == "new_delhi"
replace number_flood_past10  = 30 if region == "panaji"
replace number_flood_past10  = 12 if region == "patna"


*past 20

generate damages_cum_past20=0
generate number_major1_past20=0
generate number_major2_past20=0
generate number_any_past20=0
generate number_flood_past20=0

replace damages_cum_past20 = 5853100+10750100 if region == "ahmedabad"
replace damages_cum_past20 = 1500300+1189420 if region == "bangalore"
replace damages_cum_past20 = 90400+32900 if region == "bhopal"
replace damages_cum_past20 = 3322800+1090500 if region == "bubaneshwar"
replace damages_cum_past20 = 116924+47842 if region == "chandigarh"
replace damages_cum_past20 = 4214300+3884000  if region == "chennai"
replace damages_cum_past20 = 2623000+1840000 if region == "guwahati"
replace damages_cum_past20 = 7051000+4013100 if region == "hyderabad"
replace damages_cum_past20 =158000+90000 if region == "jaipur"
replace damages_cum_past20 = 276000+119700 if region == "kanpur"
replace damages_cum_past20 = 13138240+9138240 if region == "kochi"
replace damages_cum_past20 = 1022930+610120 if region == "kolkata"
replace damages_cum_past20 = 2300000+189670 if region == "mumbai"
replace damages_cum_past20 = 7830+3450 if region == "new_delhi"
replace damages_cum_past20 = 1585300+670300 if region == "panaji"
replace damages_cum_past20 = 691500+23980 if region == "patna"


replace number_major1_past20 = 3+2 if region == "ahmedabad"
replace number_major1_past20  = 1 if region == "bangalore"
replace number_major1_past20  = 0 if region == "bhopal"
replace number_major1_past20  = 2+1 if region == "bubaneshwar"
replace number_major1_past20  = 0 if region == "chandigarh"
replace number_major1_past20  = 4+2 if region == "chennai"
replace number_major1_past20  = 1+1 if region == "guwahati"
replace number_major1_past20  = 5+2 if region == "hyderabad"
replace number_major1_past20  = 0+1 if region == "jaipur"
replace number_major1_past20  = 0 if region == "kanpur"
replace number_major1_past20  = 7+4 if region == "kochi"
replace number_major1_past20  = 1 if region == "kolkata"
replace number_major1_past20  = 1 if region == "mumbai"
replace number_major1_past20  = 0 if region == "new_delhi"
replace number_major1_past20  = 1 if region == "panaji"
replace number_major1_past20  = 1 if region == "patna"

replace number_major2_past20 = 1+1 if region == "ahmedabad"
replace number_major2_past20  = 0 if region == "bangalore"
replace number_major2_past20  = 0 if region == "bhopal"
replace number_major2_past20  = 2 if region == "bubaneshwar"
replace number_major2_past20  = 0 if region == "chandigarh"
replace number_major2_past20  = 2 if region == "chennai"
replace number_major2_past20  = 1 if region == "guwahati"
replace number_major2_past20  = 3 if region == "hyderabad"
replace number_major2_past20  = 0 if region == "jaipur"
replace number_major2_past20  = 0 if region == "kanpur"
replace number_major2_past20  = 3 if region == "kochi"
replace number_major2_past20  = 0 if region == "kolkata"
replace number_major2_past20  = 2 if region == "mumbai"
replace number_major2_past20  = 0 if region == "new_delhi"
replace number_major2_past20  = 0 if region == "panaji"
replace number_major2_past20  = 0 if region == "patna"

*done
replace number_any_past20 = 23+30 if region == "ahmedabad"
replace number_any_past20  = 39+28 if region == "bangalore"
replace number_any_past20  = 33+29 if region == "bhopal"
replace number_any_past20  = 23+18 if region == "bubaneshwar"
replace number_any_past20  = 30+28 if region == "chandigarh"
replace number_any_past20  = 40+28 if region == "chennai"
replace number_any_past20  = 34+18 if region == "guwahati"
replace number_any_past20  =18+25 if region == "hyderabad"
replace number_any_past20  = 34+30 if region == "jaipur"
replace number_any_past20  = 7+11 if region == "kanpur"
replace number_any_past20  = 35+30 if region == "kochi"
replace number_any_past20  = 20+18 if region == "kolkata"
replace number_any_past20  = 31+15 if region == "mumbai"
replace number_any_past20  = 38+9 if region == "new_delhi"
replace number_any_past20  = 46+27 if region == "panaji"
replace number_any_past20  = 20+18 if region == "patna"

*done
replace number_flood_past20 = 13+10 if region == "ahmedabad"
replace number_flood_past20  = 25+37 if region == "bangalore"
replace number_flood_past20  = 20+19 if region == "bhopal"
replace number_flood_past20  = 13+17 if region == "bubaneshwar"
replace number_flood_past20  = 18+25 if region == "chandigarh"
replace number_flood_past20  = 26+32 if region == "chennai"
replace number_flood_past20  = 21+33 if region == "guwahati"
replace number_flood_past20  = 10+6 if region == "hyderabad"
replace number_flood_past20  = 21+16 if region == "jaipur"
replace number_flood_past20  = 3+6 if region == "kanpur"
replace number_flood_past20  = 21+15 if region == "kochi"
replace number_flood_past20  = 12+8 if region == "kolkata"
replace number_flood_past20  = 19+17 if region == "mumbai"
replace number_flood_past20  = 24+18 if region == "new_delhi"
replace number_flood_past20  = 30+22 if region == "panaji"
replace number_flood_past20  = 12+8 if region == "patna"



*past 30 years

generate damages_cum_past30=0
generate number_major1_past30=0
generate number_major2_past30=0
generate number_any_past30=0
generate number_flood_past30=0


replace damages_cum_past30 = 5853100+10750100 if region == "ahmedabad"
replace damages_cum_past30 = 1500300+1189420 if region == "bangalore"
replace damages_cum_past30 = 90400+32900 if region == "bhopal"
replace damages_cum_past30 = 3322800+1090500 if region == "bubaneshwar"
replace damages_cum_past30 = 116924+47842 if region == "chandigarh"
replace damages_cum_past30 = 4214300+3884000  if region == "chennai"
replace damages_cum_past30 = 2623000+1840000 if region == "guwahati"
replace damages_cum_past30 = 7051000+4013100 if region == "hyderabad"
replace damages_cum_past30 =158000+90000 if region == "jaipur"
replace damages_cum_past30 = 276000+119700 if region == "kanpur"
replace damages_cum_past30 = 13138240+9138240 if region == "kochi"
replace damages_cum_past30 = 1022930+610120 if region == "kolkata"
replace damages_cum_past30 = 2300000+189670 if region == "mumbai"
replace damages_cum_past30 = 7830+3450 if region == "new_delhi"
replace damages_cum_past30 = 1585300+670300 if region == "panaji"
replace damages_cum_past30 = 691500+23980 if region == "patna"


replace number_major1_past30 = 3+2+1 if region == "ahmedabad"
replace number_major1_past30  = 1 if region == "bangalore"
replace number_major1_past30  = 0 if region == "bhopal"
replace number_major1_past30  = 2+1+1 if region == "bubaneshwar"
replace number_major1_past30  = 1 if region == "chandigarh"
replace number_major1_past30  = 4+2+1 if region == "chennai"
replace number_major1_past30  = 1+1 if region == "guwahati"
replace number_major1_past30  = 5+2+1 if region == "hyderabad"
replace number_major1_past30  = 0+1 if region == "jaipur"
replace number_major1_past30  = 0 if region == "kanpur"
replace number_major1_past30  = 7+4+3 if region == "kochi"
replace number_major1_past30  = 1 if region == "kolkata"
replace number_major1_past30  = 1 if region == "mumbai"
replace number_major1_past30  = 0 if region == "new_delhi"
replace number_major1_past30  = 1 if region == "panaji"
replace number_major1_past30  = 1 if region == "patna"

replace number_major2_past30 = 1+1 if region == "ahmedabad"
replace number_major2_past30  = 0 if region == "bangalore"
replace number_major2_past30  = 0 if region == "bhopal"
replace number_major2_past30  = 2+1 if region == "bubaneshwar"
replace number_major2_past30  = 0 if region == "chandigarh"
replace number_major2_past30  = 2+1 if region == "chennai"
replace number_major2_past30  = 1+1 if region == "guwahati"
replace number_major2_past30  = 3 if region == "hyderabad"
replace number_major2_past30  = 0 if region == "jaipur"
replace number_major2_past30  = 0 if region == "kanpur"
replace number_major2_past30  = 3+1 if region == "kochi"
replace number_major2_past30  = 0 if region == "kolkata"
replace number_major2_past30  = 2 if region == "mumbai"
replace number_major2_past30  = 0 if region == "new_delhi"
replace number_major2_past30  = 0 if region == "panaji"
replace number_major2_past30  = 0 if region == "patna"

*done
replace number_any_past30 = 23+30+18 if region == "ahmedabad"
replace number_any_past30  = 39+28+40 if region == "bangalore"
replace number_any_past30  = 33+29+20 if region == "bhopal"
replace number_any_past30  = 23+18+27 if region == "bubaneshwar"
replace number_any_past30  = 30+28+27 if region == "chandigarh"
replace number_any_past30  = 40+28+46 if region == "chennai"
replace number_any_past30  = 34+18+38 if region == "guwahati"
replace number_any_past30  =18+25+23 if region == "hyderabad"
replace number_any_past30  = 34+30+37 if region == "jaipur"
replace number_any_past30  = 7+11+6 if region == "kanpur"
replace number_any_past30  = 35+30+42 if region == "kochi"
replace number_any_past30  = 20+18+17 if region == "kolkata"
replace number_any_past30  = 31+15+42 if region == "mumbai"
replace number_any_past30  = 38+9+20 if region == "new_delhi"
replace number_any_past30  = 46+27+35 if region == "panaji"
replace number_any_past30  = 20+18+16 if region == "patna"

*done
replace number_flood_past30 = 13+10+16 if region == "ahmedabad"
replace number_flood_past30  = 25+37+35 if region == "bangalore"
replace number_flood_past30  = 20+19+16 if region == "bhopal"
replace number_flood_past30  = 13+17+22 if region == "bubaneshwar"
replace number_flood_past30  = 18+25+23 if region == "chandigarh"
replace number_flood_past30  = 26+32+39 if region == "chennai"
replace number_flood_past30  = 21+33+30 if region == "guwahati"
replace number_flood_past30  = 10+6+14 if region == "hyderabad"
replace number_flood_past30  = 21+16+27 if region == "jaipur"
replace number_flood_past30  = 3+6+4 if region == "kanpur"
replace number_flood_past30  = 21+15+32 if region == "kochi"
replace number_flood_past30  = 12+8+13 if region == "kolkata"
replace number_flood_past30  = 19+17+26 if region == "mumbai"
replace number_flood_past30  = 24+18+16 if region == "new_delhi"
replace number_flood_past30  = 30+22+30 if region == "panaji"
replace number_flood_past30  = 12+8+12 if region == "patna"



generate damages_avg_past10=damages_cum_past10/number_any_past10
generate damages_avg_past20=damages_cum_past10/number_any_past20
generate damages_avg_past30=damages_cum_past10/number_any_past30


generate dif_any_past10=0

replace dif_any_past10 = . if region == "ahmedabad"
replace dif_any_past10  = . if region == "bangalore"
replace dif_any_past10  = . if region == "bhopal"
replace dif_any_past10  = 1300000-damages_avg_past10 if region == "bubaneshwar"
replace dif_any_past10 = 11000000-damages_avg_past10 if region == "chandigarh"
replace dif_any_past10  = 12000000-damages_avg_past10 if region == "chennai"
replace dif_any_past10  = 1300000-damages_avg_past10 if region == "guwahati"
replace dif_any_past10  = 12000000-damages_avg_past10 if region == "hyderabad"
replace dif_any_past10  = . if region == "jaipur"
replace dif_any_past10  = 11000000-damages_avg_past10 if region == "kanpur"
replace dif_any_past10  = 9500248-damages_avg_past10 if region == "kochi"
replace dif_any_past10  = 1300000-damages_avg_past10 if region == "kolkata"
replace dif_any_past10  = . if region == "mumbai"
replace dif_any_past10  = 11000000-damages_avg_past10 if region == "new_delhi"
replace dif_any_past10  = . if region == "panaji"
replace dif_any_past10  = 1300000-damages_avg_past10 if region == "patna"

generate dif_any_past20=0

replace dif_any_past20 = . if region == "ahmedabad"
replace dif_any_past20  = . if region == "bangalore"
replace dif_any_past20  = . if region == "bhopal"
replace dif_any_past20  = 1300000-damages_avg_past20 if region == "bubaneshwar"
replace dif_any_past20 = 11000000-damages_avg_past20 if region == "chandigarh"
replace dif_any_past20  = 12000000-damages_avg_past20 if region == "chennai"
replace dif_any_past20  = 1300000-damages_avg_past20 if region == "guwahati"
replace dif_any_past20  = 12000000-damages_avg_past20 if region == "hyderabad"
replace dif_any_past20  = . if region == "jaipur"
replace dif_any_past20  = 11000000-damages_avg_past20 if region == "kanpur"
replace dif_any_past20  = 9500248-damages_avg_past20 if region == "kochi"
replace dif_any_past20  = 1300000-damages_avg_past20 if region == "kolkata"
replace dif_any_past20  = . if region == "mumbai"
replace dif_any_past20  = 11000000-damages_avg_past20 if region == "new_delhi"
replace dif_any_past20  = . if region == "panaji"
replace dif_any_past20  = 1300000-damages_avg_past20 if region == "patna"

generate dif_any_past30=0

replace dif_any_past30 = . if region == "ahmedabad"
replace dif_any_past30  = . if region == "bangalore"
replace dif_any_past30  = . if region == "bhopal"
replace dif_any_past30  = 1300000-damages_avg_past30 if region == "bubaneshwar"
replace dif_any_past30 = 11000000-damages_avg_past30 if region == "chandigarh"
replace dif_any_past30  = 12000000-damages_avg_past30 if region == "chennai"
replace dif_any_past30  = 1300000-damages_avg_past30 if region == "guwahati"
replace dif_any_past30  = 12000000-damages_avg_past30 if region == "hyderabad"
replace dif_any_past30  = . if region == "jaipur"
replace dif_any_past30  = 11000000-damages_avg_past30 if region == "kanpur"
replace dif_any_past30  = 9500248-damages_avg_past30 if region == "kochi"
replace dif_any_past30  = 1300000-damages_avg_past30 if region == "kolkata"
replace dif_any_past30  = . if region == "mumbai"
replace dif_any_past30  = 11000000-damages_avg_past30 if region == "new_delhi"
replace dif_any_past30  = . if region == "panaji"
replace dif_any_past30  = 1300000-damages_avg_past30 if region == "patna"


generate dif_largest_past10=0
generate dif_largest_past20=0
generate dif_largest_past30=0

replace dif_largest_past10 = . if region == "ahmedabad"
replace dif_largest_past10  = . if region == "bangalore"
replace dif_largest_past10  = . if region == "bhopal"
replace dif_largest_past10  = 1300000-2500000 if region == "bubaneshwar"
replace dif_largest_past10 = 11000000-906000 if region == "chandigarh"
replace dif_largest_past10  = 12000000-2150000 if region == "chennai"
replace dif_largest_past10  = 1300000-633471 if region == "guwahati"
replace dif_largest_past10  = 12000000-2150000 if region == "hyderabad"
replace dif_largest_past10  = . if region == "jaipur"
replace dif_largest_past10  = 11000000-775000  if region == "kanpur"
replace dif_largest_past10  = 9500248-8000000 if region == "kochi"
replace dif_largest_past10  = 1300000-1500300 if region == "kolkata"
replace dif_largest_past10  = . if region == "mumbai"
replace dif_largest_past10 = 11000000-906000  if region == "new_delhi"
replace dif_largest_past10 = . if region == "panaji"
replace dif_largest_past10 = 1300000-1022800 if region == "patna"

replace dif_largest_past20 = . if region == "ahmedabad"
replace dif_largest_past20  = . if region == "bangalore"
replace dif_largest_past20  = . if region == "bhopal"
replace dif_largest_past20  = 1300000-2844000 if region == "bubaneshwar"
replace dif_largest_past20 = 11000000-1060000 if region == "chandigarh"
replace dif_largest_past20  = 12000000-2150000 if region == "chennai"
replace dif_largest_past20  = 1300000-633471 if region == "guwahati"
replace dif_largest_past20  = 12000000-2150000 if region == "hyderabad"
replace dif_largest_past20  = . if region == "jaipur"
replace dif_largest_past20  = 11000000-775000  if region == "kanpur"
replace dif_largest_past20  = 9500248-8000000 if region == "kochi"
replace dif_largest_past20  = 1300000-1500300 if region == "kolkata"
replace dif_largest_past20  = . if region == "mumbai"
replace dif_largest_past20 = 11000000-906000  if region == "new_delhi"
replace dif_largest_past20 = . if region == "panaji"
replace dif_largest_past20 = 1300000-1022800 if region == "patna"

replace dif_largest_past30 = . if region == "ahmedabad"
replace dif_largest_past30  = . if region == "bangalore"
replace dif_largest_past30  = . if region == "bhopal"
replace dif_largest_past30  = 1300000-2844000 if region == "bubaneshwar"
replace dif_largest_past30 = 11000000-1060000 if region == "chandigarh"
replace dif_largest_past30  = 12000000-2150000 if region == "chennai"
replace dif_largest_past30  = 1300000-633471 if region == "guwahati"
replace dif_largest_past30  = 12000000-2150000 if region == "hyderabad"
replace dif_largest_past30  = . if region == "jaipur"
replace dif_largest_past30  = 11000000-775000  if region == "kanpur"
replace dif_largest_past30  = 9500248-8000000 if region == "kochi"
replace dif_largest_past30  = 1300000-1500300 if region == "kolkata"
replace dif_largest_past30  = . if region == "mumbai"
replace dif_largest_past30 = 11000000-906000  if region == "new_delhi"
replace dif_largest_past30 = . if region == "panaji"
replace dif_largest_past30 = 1300000-1022800 if region == "patna"


rename dif_any_past30 dif_avg_past30
rename dif_any_past20 dif_avg_past20
rename dif_any_past10 dif_avg_past10


keep region number_any_past10 number_major1_past10 number_major2_past10 number_flood_past10 damages_cum_past10 dif_avg_past10 dif_largest_past10 number_any_past20 number_major1_past20 number_major2_past20 number_flood_past20 damages_cum_past20 dif_avg_past20 dif_largest_past20  number_any_past30 number_major1_past30 number_major2_past30 number_flood_past30 damages_cum_past30 dif_avg_past30 dif_largest_past30 

order region number_any_past10 number_major1_past10 number_major2_past10 number_flood_past10 damages_cum_past10 dif_avg_past10 dif_largest_past10 number_any_past20 number_major1_past20 number_major2_past20 number_flood_past20 damages_cum_past20 dif_avg_past20 dif_largest_past20  number_any_past30 number_major1_past30 number_major2_past30 number_flood_past30 damages_cum_past30 dif_avg_past30 dif_largest_past30 

save _1data/raw/disasters/disaster_risk.dta, replace
