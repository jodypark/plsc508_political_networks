*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* TABLE A1: SUMMARY STATISTICS OF THE MEMBERS' QUESTIONING STYLES
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
gen mc_extreme = abs(party_median_ideo - dwnom1)
macro define inst1 "divided_house pres_outparty polappt2 majority chairspeech rankmemspeech mc_extreme les" 
macro define committee1 "subcommittee bill numwitness"	
macro define pol_question "gscore_ask posi_ask nega_ask acount_ask word_count_ask"

* hearing-level summary stats
egen memid = group(asker congress)
bys hearingid witness_id asker: gen ss = _n ==1 // unit of observations 
bys hearingid: egen numpair = sum(ss)
bys hearingid: gen hh = _n == 1
sum numpair if hh ==1
sum numpair if hh ==1 & divided_house ==1 
sum numpair if hh ==1 & divided_house ==0
sum pres_outparty if divided_house ==1
sum pres_outparty if divided_house ==0
bys hearingid asker: egen num_q_witness = count(congress)
sum num_q_witness if hh ==1 

drop ss
bys hearingid asker: gen ss = _n ==1
bys hearingid: egen question_mem = sum(ss) // number of members who asked questions 
sum question_mem if hh==1 
drop ss
bys witness_id: egen numqmem = count(asker)
bys witness_id: gen ss = _n ==1
sum numqmem if ss ==1 
bys hearingid: egen numbureau = sum(ss)
sum numpair question_mem numbureau if hh ==1 
sort congress witness_id 
bys congress: egen numbureautotal = sum(ss)
bys congress: gen cc = _n ==1
sum numbureautotal if cc ==1 
drop ss hh cc numbureautotal numpair question_mem numbureau

macro define pol_question "gscore_ask posi_ask neut_ask nega_ask acount_ask word_count_ask"
tabstat $pol_question if divided_house ==1 & pres_outparty ==0, stat(N mean) col(stat)format(%9.2f)
tabstat $pol_question if divided_house ==1 & pres_outparty ==1, stat(N mean) col(stat)format(%9.2f)
tabstat $pol_question if divided_house ==0 & pres_outparty ==0, stat(N mean) col(stat)format(%9.2f)
tabstat $pol_question if divided_house ==0 & pres_outparty ==1, stat(N mean) col(stat)format(%9.2f)
