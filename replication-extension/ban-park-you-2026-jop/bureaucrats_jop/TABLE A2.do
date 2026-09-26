*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* TABLE A2: SUMMARY STATISTICS OF THE VARIABLES AT THE PAIR LEVEL 
********************************************************************************
* PANEL A: BUREAUCRATIC WITNESS ANALYSIS 
clear
use dyad_b.dta 
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
gen mc_extreme = abs(party_median_ideo - dwnom1)
macro define inst1        "polappt2 pres_outparty majority chairspeech rankmemspeech mc_extreme les" 
macro define committee1   "subcommittee bill numwitness"	
macro define pol_question "gscore_ask posi_ask neut_ask nega_ask acount_ask word_count_ask"

* summary stats
tabstat ascore word_count $inst1 dyad_order_h dyad_order_hw ///
        $pol_question $committee1 , stat(N mean sd min max) col(stat) format(%9.2f)

			
* PANEL B: NON-BUREAUCRATIC WITNESS ANALYSIS		
clear
use dyad.dta
bys hearingid: egen bureauappear = max(bureaucrat)
drop if bureaucrat == 1 // drop bureaucratic witnesses from the data 
gen pres_outparty = .
replace pres_outparty = 1 if pres_party == 0
replace pres_outparty = 0 if pres_party == 1 
gen mc_extreme = abs(party_median_ideo-dwnom1)
* define variables 
macro define inst1        "pres_outparty majority chairspeech rankmemspeech mc_extreme les " 
macro define committee1   "subcommittee bill numwitness"	
macro define pol_question "gscore_ask posi_ask neut_ask nega_ask acount_ask word_count_ask"
* summary stats
tabstat ascore word_count $inst1 dyad_order_h dyad_order_hw ///
        $pol_question $committee1 , stat(N mean sd min max) col(stat) format(%9.2f)
