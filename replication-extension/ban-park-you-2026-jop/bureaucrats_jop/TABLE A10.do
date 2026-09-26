*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------
	
********************************************************************************
* TABLE A10: NUMBER OF QUESTION-ANSWER PAIRS AT THE AGGREGATE-LEVEL   
********************************************************************************   
clear
use aggregate.dta 
gen tot_q_b = q_b_co + q_b_out
gen tot_q_nb = q_nb_co + q_nb_out 
gen tot_q = tot_q_b + tot_q_nb 
gen tot_a_b = a_b_co + a_b_out 
gen tot_a_nb = a_nb_co + a_nb_out 
gen tot_a = tot_a_b + tot_a_nb 
gen tot_w_b = w_b_co + w_b_out 
gen tot_w_nb = w_nb_co + w_nb_out 
gen tot_w = tot_w_b + tot_w_nb 
replace tot_w_b = ln(tot_w_b +1)
replace tot_w_nb = ln(tot_w_nb + 1)
replace tot_w = ln(tot_w + 1)
gen ln_tot_a = ln(tot_a +1)
gen tot_q_co = q_b_co + q_nb_co 
gen tot_q_out = q_b_out + q_nb_out 

* define variables 
macro define inst1 "divided_house" 
macro define committee1 "subcommittee bill numwitness oversight"	

eststo clear
eststo: quietly areg tot_q_b  $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
eststo: quietly areg q_b_co   $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
eststo: quietly areg q_b_out  $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
eststo: quietly areg tot_q_nb $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
eststo: quietly areg q_nb_co  $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
eststo: quietly areg q_nb_out $inst1 $committee1 i.presid i.majortopic, a(comid) cluster(comid)
esttab, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *presid*) se ar2	
esttab using table_a10.tex, star(* 0.05 ** 0.01 *** 0.001) drop(*_cons* *majortopic* *presid*) se ar2 replace
sum tot_q_b q_b_co q_b_out tot_q_nb q_nb_co q_nb_out 
