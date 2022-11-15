********************************************************************************
* Figure 2: Raw FDI inflows by disaster-affected regions

********************************************************************************

use _1data/clean/clean_data, clear
set scheme plotplain


gen log_fdi = asinh(fdi)
* Graph of the raw data differentiating between unaffected and each of the five disasters:
keep if date >= ym(2006,2)
gen affected=0
replace affected=1 if one_affected==1 
replace affected=2 if two_affected==1 
replace affected=3 if three_affected==1 
replace affected=4 if four_affected==1 
replace affected=5 if five_affected==1
*replace affected = 77 if one_affected==1 & two_affected==1
bysort affected date (region): egen avg_fdi_each=mean(fdi)

tssmooth ma avg_fdi=avg_fdi_each, window(2 1 0)

* FIGURE 2A:
graph twoway (line avg_fdi date if affected==2, lp(solid) lw(medthick) lcolor(gold)) ///
	(line avg_fdi date if affected==3, lw(medthick) lcolor(maroon) lp(solid) ) ///
	(line avg_fdi date if affected==4, lw(medthick) lcolor(ltblue) lp(solid) ) ///
	(line avg_fdi date if affected==5, lw(medthick) lcolor(dkgreen) lp(solid) ) ///
	(line avg_fdi date if affected==0, lw(medthick) lcolor(navy) lp(solid)  xaxis(1 2) xla(569 "ND 1" 601 "ND 2" ///
	639 "ND 3" 668 "ND 4" 701 "ND 5", axis(1) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) xtitle("", axis(2))), ///
	legend(position(6) label(1 "Affected ND 1 & 2") label(2 "Affected ND 3") ///
	label(3 "Affected ND 4") label(4 "Affected ND 5") ///
	label(5 "Unaffected")) ylabel(,labsize(medium)) xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020",axis(2) labsize(medium)) ///
	ytitle(Monthly FDI Inflows ($ mil.)) legend(on region(lwidth(none)) size(med) symysize(*1) col(3) ) xscale(noline)


graph export _3results/figures/figure2a.pdf, replace

	
** Change and focus on regions only affected by disaster 2:
drop affected avg_fdi_each avg_fdi
gen affected=0
replace affected=1 if one_affected==1 
replace affected=2 if two_affected==1 & one_affected==0
replace affected=3 if three_affected==1 
replace affected=4 if four_affected==1 
replace affected=5 if five_affected==1
bysort affected date (region): egen avg_fdi_each=mean(fdi)

tssmooth ma avg_fdi=avg_fdi_each, window(2 1 0)


* FIGURE 2b:
graph twoway (line avg_fdi date if affected==1, lp(solid) lw(medthick) lc(edkblue) ///
	xaxis(1 2) xla(569 "ND 1" 601 "ND 2" 639 "ND 3" 668 "ND 4" 701 "ND 5", axis(2) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) ///
	xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020", axis(1) nogrid labsize(medium)) ytitle(Monthly FDI Inflows ($ mil.)) ylabel(,labsize(medium)) xscale(noline axis(2))) 


graph export _3results/figures/figure2b.pdf, replace	
	

* FIGURE 2c:
graph twoway (line avg_fdi date if affected==2, lp(solid) lw(medthick) lc(edkblue) ///
	xaxis(1 2) xla(569 "ND 1" 601 "ND 2" 639 "ND 3" 668 "ND 4" 701 "ND 5", axis(2) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) ///
	xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020", axis(1) nogrid labsize(medium)) ytitle(Monthly FDI Inflows ($ mil.)) ylabel(,labsize(medium)) xscale(noline axis(2))) 


graph export _3results/figures/figure2c.pdf, replace		
	
* FIGURE 2d:
graph twoway (line avg_fdi date if affected==3, lp(solid) lw(medthick) lc(edkblue) ///
	xaxis(1 2) xla(569 "ND 1" 601 "ND 2" 639 "ND 3" 668 "ND 4" 701 "ND 5", axis(2) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) ///
	xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020", axis(1) nogrid labsize(medium)) ytitle(Monthly FDI Inflows ($ mil.)) ylabel(,labsize(medium)) xscale(noline axis(2)) ) 


graph export _3results/figures/figure2d.pdf, replace	

* FIGURE 2e:
graph twoway (line avg_fdi date if affected==4, lp(solid) lw(medthick) lc(edkblue) ///
	xaxis(1 2) xla(569 "ND 1" 601 "ND 2" 639 "ND 3" 668 "ND 4" 701 "ND 5", axis(2) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) ///
	xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020", axis(1) nogrid labsize(medium)) ytitle(Monthly FDI Inflows ($ mil.)) ylabel(,labsize(medium)) xscale(noline axis(2)) ) 


graph export _3results/figures/figure2e.pdf, replace	

* FIGURE 2f:
graph twoway (line avg_fdi date if affected==5, lp(solid) lw(medthick) lc(edkblue) ///
	xaxis(1 2) xla(569 "ND 1" 601 "ND 2" 639 "ND 3" 668 "ND 4" 701 "ND 5", axis(2) grid glcolor(black) glpattern(dash) glwidth(medthin) tlength(0)) ///
	xtitle("", axis(2)) xtitle("", axis(1)) xlabel(552 "2006" 576 "2008" 600  "2010" 624 "2012" 648 "2014" 672 "2016" 696 "2018" 720 "2020", axis(1) nogrid labsize(medium)) ytitle(Monthly FDI Inflows ($ mil.)) ylabel(,labsize(medium)) xscale(noline axis(2)) ) 


graph export _3results/figures/figure2f.pdf, replace	
	









