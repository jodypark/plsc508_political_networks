*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE A2: SHARE OF POLITICAL APOINTEES OVER TIME 
********************************************************************************
clear
use bureaucrat_pol.dta
bys chamber year: gen cc = _n ==1 
grstyle init
replace polappt = dod_pol if acr =="DOD"
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

gen career = 1 if polappt == 0
bys year: egen totcar = sum(career)	  
bys year: egen totpol = sum(polappt)
bys year: gen ww = _n ==1
gen totpolratio = totpol/(totcar + totpol)

line totpolratio year if ww ==1, lwidth(thick) ///
     xtitle("Year") ytitle("Share of Political Appointees")  ///
	 xlabel(1977 (4) 2014) lcol(gs3)
