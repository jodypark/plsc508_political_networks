*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE 2: CAREER vs. POLITICAL APPOINTEES AMONG BUREAUCRATIC WITNESSES, 1977-2014
********************************************************************************	
clear
use bureaucrat_pol.dta
replace polappt = dod_pol if acr =="DOD"
grstyle init
bys hearingid: egen numpol = sum(polappt)
gen polappear = .
replace polappear = 0 if numpol ==0 
replace polappear =1 if numpol > 0	 
bys hearingid: egen polappear2 = max(polappear)  
bys hearingid: egen numbureau = count(congress)
bys hearingid: egen meanwitness = mean(numwitness_identified)
bys hearingid: egen numbureau_dept = sum(department)
bys hearingid: egen numbureau_ind = sum(independent)
bys hearingid agencycode: gen aa = _n ==1
bys hearingid: egen numagency = sum(aa)
gen polshare = numpol/numbureau 

			
* calculating the share of political appointees 
bys agencycode: gen dd = _n ==1 
bys agencycode: egen allbureau = count(congress)
bys agencycode: egen polbureau = sum(polappt)
gen nonpol = allbureau - polbureau 
gen polratio = polbureau/allbureau 
gsort dd department - polratio
 				
******************************************
* FIGURE 2-Panel (a): Executive Department 
******************************************
graph hbar nonpol polbureau if dd==1 & department ==1, over(acr, ///
      sort(allbureau) label(labsize(small))) ///
      stack graphregion(color(white)) /// 
      legend(cols(1) order (1 "Career" 2 "Political Appointee") ///
	  size(small) position(1) ring(0)) ///
	  ytitle("Number of Witnesses") ysize(6) ///
	  bar(1, fcolor(gs10) lcolor(gs10)) bar(2, fcolor(gs3) lcolor(gs3)) 


************************************
* FIGURE 2-Panel (b): Other Agencies
************************************
* no OPM information on political appointees for following agencies:
drop if opm_agencyname =="FEDERAL RESERVE SYSTEM"
drop if opm_agencyname =="U.S. POSTAL SERVICE"
drop if opm_agencyname =="CENTRAL INTELLIGENCE AGENCY"
drop if opm_agencyname =="TENNESSEE VALLEY AUTHORITY"
drop if opm_agencyname =="POSTAL REGULATORY COMMISSION"
drop if acr =="FED"
drop if acr =="USPS"
graph hbar nonpol polbureau if dd==1 & agencycode!="" & department ==0 &allbureau > 240, ///
      over(acr, sort(allbureau) label(labsize(small))) stack graphregion(color(white)) /// 
      legend(cols(1) order (1 "Career" 2 "Political Appointee") size(small) position(1) ring(0)) ///
	  ytitle("Number of Witnesses") ysize(6) ///
	  bar(1, fcolor(gs10) lcolor(gs10)) bar(2, fcolor(gs3) lcolor(gs3)) 

