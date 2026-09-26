*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE A7: HETEROGENEOUS EFFECTS OF "PRESIDENT OUT-PARTISAN" BY COMMITTEE TYPE
********************************************************************************
* regression to generate the coefficient/confidence interval for the figure 
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
* types of committee: 
gen pres_comm = 0
replace pres_comm = 1 if cmt_govtrack == "HSAP"  // appropriations
replace pres_comm = 1 if cmt_govtrack =="HSBU"  // budget
replace pres_comm = 1 if cmt_govtrack =="HSRU" // rules
replace pres_comm = 1 if cmt_govtrack =="HSWM" // ways and means
gen policy_comm = 0
replace policy_comm = 1 if cmt_govtrack =="HSBA" // banking
replace policy_comm = 1 if cmt_govtrack =="HSED" // education and labor
replace policy_comm = 1 if cmt_govtrack =="HSIF" // energy and commerce 
replace policy_comm = 1 if cmt_govtrack =="HSFA" // foreign affairs 
replace policy_comm = 1 if cmt_govtrack =="HSJU" // judiciary 
replace policy_comm = 1 if cmt_govtrack =="HSHM" // government operations
gen const_comm = 0
replace const_comm = 1 if cmt_govtrack =="HSAG" // agriculture
replace const_comm = 1 if cmt_govtrack =="HSAS" // armed services
replace const_comm = 1 if cmt_govtrack =="HSII" // interior
replace const_comm = 1 if cmt_govtrack =="HSSY" // science
replace const_comm = 1 if cmt_govtrack =="HSSM" // small business
replace const_comm = 1 if cmt_govtrack =="HSVR" // veterans

eststo clear
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==1 & pres_comm==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==1 & policy_comm==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==1 & const_comm==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==0 & pres_comm==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==0 & policy_comm==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question if legislative ==0 & const_comm==1, a(witness_id) cluster(hid)
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons*) se ar2
esttab using figure_a7.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons*) se ar2 replace

* FIGURE A7
clear
insheet using "coef_plots.csv"
keep if variable =="comm"
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
			xlab(1 "Prestigious" 2 "Policy" 3 "Constituent" 4 "Prestigious" 5 "Policy" 6 "Constituent", angle(45))
			ylab(-3(1)0, angle(horiz) format(%20.02fc) nogrid)
			yline(0, lpat(solid) lcol(gray))
			xtitle("")
			yscale(r(-3 1))
			ytitle("Coefficient") 
			name(g1, replace)
			text(0.5 2.2 "Legislative" -0.2 5, box size(medlarge) bcolor("lavender*0.4") height(huge))
			text(0.5 4.8 "Oversight", box size(medlarge) bcolor("sandb*0.4") height(huge))
		    xline(3.5, lpat(dash) lcol(black))
			;

	#delimit cr
