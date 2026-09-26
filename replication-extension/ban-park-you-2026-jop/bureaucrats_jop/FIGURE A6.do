*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE A6: HETEROGENEOUS EFFECT OF "PRESIDENT OUT-PATISAN" BY ISSUE POLARIZATION
********************************************************************************
* regression to generate the coefficients/confidence intervals for the figure 
clear
use dyad_b.dta 
* committee ID 
bys chamber cmt_govtrack: gen comid = 1 if _n ==1
replace comid = sum(comid)                                
* president ID                         
bys pres: gen presid = 1 if _n ==1
replace presid = sum(presid)
* agency ID 
bys agencycode: gen agencyid = 1 if _n ==1
replace agencyid = sum(agencyid)
* hearing ID
egen hid = group(hearingid)
* outcome measures 
sum ascore, detail 
replace num_word = ln(num_word +1)
gen pres_outparty = .
replace pres_outparty = 1 if pres_party == 0
replace pres_outparty = 0 if pres_party == 1 
* define variables 
gen mc_extreme = abs(party_median_ideo - dwnom1)
macro define inst1 "pres_outparty majority chairspeech rankmemspeech mc_extreme les" 
macro define committee1 "dyad_order_h"	
macro define pol_question "gscore_ask posi_ask nega_ask acount_ask word_count_ask"
drop if mc_extreme ==. | chairspeech ==.
replace word_count_ask = ln(word_count_ask+1)
ssc inst egenmore
* by issue polarization 
bys congress: egen polarrank = xtile(polar), nq(3)

eststo clear
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==1 & polarrank ==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==1 & polarrank ==2, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==1 & polarrank ==3, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==0 & polarrank ==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==0 & polarrank ==2, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative==0 & polarrank ==3, a(witness_id) cluster(hid)
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons*) se ar2	
esttab using figure_a6.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons*) se ar2 replace

* FIGURE A6
clear
insheet using "coef_plots.csv"
keep if variable =="polar"
    gen id = _n 
	gen index = _n
	collapse b se, by(index)
	gen ub = b + 1.96*se
	gen lb = b - 1.96*se


   grstyle init
   grstyle set plain, nogrid 
    		
	#delimit;

	gr tw
		(sc b index, col(black) msize(large))
		(rspike ub lb index, col(black))
		,
			legend(off)
			graphregion(color(white))
			xlab(1 "Bottom" 2 "Middle" 3 "Top" 4 "Bottom" 5 "Middle" 6 "Top", angle(0))
			//xlab(1 "Presti" 2 "Policy" 3 "Consti." 4 "Presti." 5 "Policy" 6 "Consti.", angle(0))
			ylab(-3(1)0, angle(horiz) format(%20.02fc) nogrid)
			yline(0, lpat(solid) lcol(gray))
			xtitle("")
			yscale(r(-3 1))
			ytitle("Coefficient") 
			xtitle("Issue Polarization Tercile")
			 //xtitle ("Committee Type")
			name(g1, replace)
			text(0.5 2.2 "Legislative" -0.2 5, box size(medlarge) bcolor("lavender*0.4") height(huge))
			text(0.5 4.8 "Oversight", box size(medlarge) bcolor("sandb*0.4") height(huge))
		    xline(3.5, lpat(dash) lcol(black))
			;

	#delimit cr

