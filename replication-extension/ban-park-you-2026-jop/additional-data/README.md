# Additional agency data: codebook

- Clean data file: `clean/agency_attributes.csv`
- Cleaning script: `clean/clean_agency_attributes.R`
- Unit of observation: agency code (`agencycode`) in the Ban, Park, and You (2026) file `dyad_b.dta`
- Intended use: agency attributes for the network displays, the extension models, and the descriptive appendix of the draft 2 paper
- The coding steps and the instructions for rebuilding the file are in the project `README.md` one level up.

## 1. Overview

- The clean file has 64 rows, one for each agency code in `dyad_b.dta`.
- It adds a four-level leadership category, a regulatory indicator, an exploratory science flag, and direct keys to the Acs (2025) agency ideal points.
- The Richardson ideology score and the two Selin independence scores are not in this folder. They are already in `dyad_b.dta`.
- All attributes are static. They have not been verified for every hearing year from 1997 to 2014.
- Missing or conflicting source values stay missing.

### Coverage of the clean file

- `l1_four_level`: 33 of 64 codes. Five are executive departments without separate bureaus, 1 is an executive department with distinct bureaus, 10 are independent agencies, and 17 are independent commissions or independent regulatory commissions.
- `regulatory`: 39 of 64 codes. 31 equal 1 and 8 equal 0.
- `independence_binary`: 23 of 64 codes. 17 equal 1 and 6 equal 0.
- `science_flag`: all 64 codes. Five equal 1.
- `acs_agency_id`: 11 of 64 codes.

## 2. Files

### Raw files

- `raw/agency_types_extract.csv`
  - Source: the federal contract data of Fazekas, Ferrali, and Wachs (2023), *Journal of Public Administration Research and Theory*, and an earlier file that matched those agencies to the Acs (2025) agencies.
  - Content: 180 distinct, unaltered combinations of agency name, agency category, and regulatory indicator. It is a small extract of source columns and not a new classification.
  - Variables:
    - `agency_name`: agency name in the contract data. Some rows are blank.
    - `agency_cat2`: agency category of Fazekas, Ferrali, and Wachs (2023), who follow the agency types of Dahlström, Fazekas, and Lewis (2021). The four labels are `cabinet/exec. dep. (not bureau)`, `cabinet/exec. dep. and bureau`, `indep. agency`, and `indep. commission & IRC` (independent regulatory commission). Some rows are missing.
    - `regulatory_finalmatch`: 1 if the agency issues federal rules and 0 otherwise. It combines exact name matches to Acs agencies and matches to agencies that issued final rules in the *Federal Register* from 2004 to 2015 with fuzzy name matches. It is unaudited.
- `raw/dynamic_estimates.csv`
  - Source: replication materials of Acs (2025), *American Political Science Review*. Exact copy.
  - Content: agency ideal points for each administration, estimated from presidential review of planned regulations by the Office of Information and Regulatory Affairs (OIRA). 280 rows cover 70 agencies under 4 administrations (Clinton, Bush, Obama, and Trump).
  - Variables: `agency.digit` (numeric agency index), `est` (ideal point estimate), `se` (standard error), `lower` and `upper` (interval bounds), `time.period` (administration index), `agency.id` (department–agency key, such as `AG-AMS`), `admin` (president), `dept` (department abbreviation), and `agency` (agency abbreviation).
- `raw/rcl_ideal_points_merged.csv`
  - Source: replication materials of Acs (2025). Exact copy.
  - Content: 69 Acs agencies with their original names, merged with the agency ideology ratings of Richardson, Clinton, and Lewis (2018). The cleaning script does not read it. It keeps the original Acs bureau names for auditing the 11 direct keys.
  - Variables: `cleaned_agency` (lowercase agency name), Acs estimate columns (`agency.digit`, `est`, `se`, `lower`, `upper`, `agency.id`), Acs and Richardson name columns (`dept.x`, `agency.x`, `agency.y`, `dept.y`, `acr`), and Richardson rating columns (`ideo_rating`, `ideo_sd`, `ideo_lb`, `ideo_ub`, `base_ideo_rating`, `base_ideo_sd`, `base_ideo_lb`, `base_ideo_ub`).

### Clean files

- `clean/clean_agency_attributes.R`: reads the raw extract, `raw/dynamic_estimates.csv`, and `../bureaucrats_jop/dyad_b.dta`. It writes `clean/agency_attributes.csv`.
- `clean/agency_attributes.csv`: one row for each agency code.

## 3. Variable descriptions (`clean/agency_attributes.csv`)

- `agencycode`: agency code in `dyad_b.dta`. Unique in the file.
- `opm_names`: Office of Personnel Management (OPM) agency names under the code, separated by " | ". The code `DD` lists four names: the Department of Defense and the Departments of the Air Force, the Army, and the Navy.
- `l1_four_level`: four-level leadership category from `agency_cat2`. Missing when no OPM unit matches, when a source value is missing, or when matched values conflict.
- `regulatory`: regulatory indicator from `regulatory_finalmatch`. 1 = coded as issuing federal rules; 0 = not coded as a rule issuer. Missing when unresolved. It records a function and not statutory authority.
- `matched_opm_units`: number of OPM names under the code that matched a source agency name.
- `opm_units`: number of OPM names under the code.
- `science_flag`: 1 for the Department of Energy (`DN`), the Environmental Protection Agency (`EP`), the National Aeronautics and Space Administration (`NN`), the National Science Foundation (`NF`), and the Nuclear Regulatory Commission (`NU`); 0 otherwise. An exploratory grouping and not a published classification.
- `independence_binary`: 1 for independent commissions; 0 for the two executive department categories; missing otherwise. The draft 2 paper does not use it.
- `acs_agency_id`: direct parent-level key to `agency.id` in `raw/dynamic_estimates.csv`. Missing for 53 codes.
- `acs_admin_key`: states that Acs estimates must be joined by the actual president (Clinton, Bush, or Obama). It is not an annual estimate.
- `coverage_notes`: text notes on the match status of each attribute and on the static coverage limits.
