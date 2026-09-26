*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------
		
********************************************************************************
* TABLE A3: INCLUDING ALL POLITICAL APPOINTEES
********************************************************************************
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
replace num_word = ln(num_word +1)
* all political appiontees 
gen polappt2 = 0
replace polappt2 = 1 if polappt_type =="PAS"
replace polappt2 = 1 if polappt_type =="PA"
replace polappt2 = 1 if polappt_type =="C"
replace polappt2 =. if agencycode =="DD"
replace polappt2 = dod_pol if dod_pol!=. 
bys agencycode: gen tt = _n ==1 
gen pres_outparty = .
replace pres_outparty = 1 if pres_party == 0
replace pres_outparty = 0 if pres_party == 1 
gen mc_extreme = abs(party_median_ideo - dwnom1)
gen polappt_presoutparty = polappt2*pres_outparty
* define variables 
macro define inst1 "pres_outparty polappt2 polappt_presoutparty majority chairspeech rankmemspeech mc_extreme les" 
macro define committee1 "subcommittee bill numwitness dyad_order_h"	
macro define pol_question "gscore_ask posi_ask nega_ask acount_ask word_count_ask"
replace word_count_ask = ln(word_count_ask+1)


eststo clear
eststo: quietly areg ascore $inst1 $committee1               i.presid i.majortopic i.comid if oversight ==0, a(agencyid) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question $committee1 i.presid i.majortopic i.comid if oversight ==0, a(agencyid) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question $committee1 i.presid i.majortopic if oversight ==0, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1               i.presid i.majortopic i.comid if oversight ==1, a(agencyid) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question $committee1 i.presid i.majortopic i.comid if oversight ==1, a(agencyid) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question $committee1 i.presid i.majortopic if oversight ==1, a(witness_id) cluster(hid)
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *comid* *presid*) se ar2	
esttab using table_a3.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *comid* *presid*) se ar2 replace
sum ascore if oversight ==0
sum ascore if oversight ==1
