*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------
		
********************************************************************************
* TABLE A6: EXECUTIVE DEPARTMENTS VS. OTHER 
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
* separating political appointees into senate confirmed vs. non senate confirmed 
gen polappt2 = 0
replace polappt2 = 1 if polappt_type =="PAS"
replace polappt2 =. if agencycode =="DD"
replace polappt2 = dod_pol if dod_pol!=. 
bys agencycode: gen tt = _n ==1 
gen pres_outparty = .
replace pres_outparty = 1 if pres_party == 0
replace pres_outparty = 0 if pres_party == 1 
* define variables 
gen polappt_presoutparty = polappt2*pres_outparty
gen mc_extreme = abs(party_median_ideo - dwnom1)
macro define inst1 "pres_outparty polappt_presoutparty chairspeech rankmemspeech mc_extreme les dyad_order_h" 
macro define pol_question "gscore_ask posi_ask nega_ask acount_ask word_count_ask"
replace word_count_ask = ln(word_count_ask+1)
replace word_count = ln(word_count +1)

eststo clear
eststo: quietly areg ascore $inst1 $pol_question i.presid i.majortopic i.comid if department ==1 & oversight ==0, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question i.presid i.majortopic i.comid if department ==1 & oversight ==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question i.presid i.majortopic i.comid if department ==0 & oversight ==0, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $pol_question i.presid i.majortopic i.comid if department ==0 & oversight ==1, a(witness_id) cluster(hid)
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *comid* *presid*) se ar2	
esttab using table_a6.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *comid* *presid*) se ar2 replace
sum ascore if oversight == 0 & department ==1 
sum ascore if oversight == 1 & department ==1 
sum ascore if oversight == 0 & department ==0 
sum ascore if oversight == 1 & department ==0 
