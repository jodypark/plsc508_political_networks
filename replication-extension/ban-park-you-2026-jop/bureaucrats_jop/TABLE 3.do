*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* TABLE 3: NON-BUREAUCRATIC WITNESSES' PROVISION OF ANALYTICAL INFORMATION 
********************************************************************************
clear
use dyad.dta
bys hearingid: egen bureauappear = max(bureaucrat)
drop if bureaucrat == 1 // drop bureaucratic witnesses from the data 
rename committee_code2 cmt_govtrack
* committee ID 
bys cmt_govtrack: gen comid = 1 if _n ==1
replace comid = sum(comid)                                
* president ID                         
bys pres: gen presid = 1 if _n ==1
replace presid = sum(presid)
* creating hearing ID 		
egen hid = group(hearingid)
* type ID
bys type: gen typeid = 1 if _n ==1
replace typeid = sum(typeid)
gen pres_outparty = .
replace pres_outparty = 1 if pres_party == 0
replace pres_outparty = 0 if pres_party == 1 
gen mc_extreme = abs(party_median_ideo-dwnom1)
* define variables 
macro define inst1        "pres_outparty majority chairspeech rankmemspeech mc_extreme les " 
macro define committee1   "subcommittee bill numwitness dyad_order_h"	
macro define pol_question "gscore_ask posi_ask nega_ask acount_ask word_count_ask"

eststo clear
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic i.typeid if oversight ==0, a(comid) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic if oversight ==0, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic if oversight ==0 & bureauappear ==1, a(witness_id) cluster(hid)  
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic i.typeid if oversight ==1, a(comid) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic if oversight ==1, a(witness_id) cluster(hid)
eststo: quietly areg ascore $inst1 $committee1 $pol_question i.presid i.majortopic if oversight ==1 & bureauappear ==1, a(witness_id) cluster(hid) 
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *typeid* *presid*) se ar2	
esttab using table3.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *typeid* *presid*) se ar2 replace
sum ascore if oversight ==0
sum ascore if oversight ==0 & bureauappear ==1
sum ascore if oversight ==1
sum ascore if oversight ==1 & bureauappear ==1

