# Ban, Park, and You (2026, JOP) — Replication Materials

Replication files for Ban, Park, and You (2026), *Journal of Politics*. Paper and appendix PDFs are in this folder.

## Data

Four data files are too large for GitHub (>50 MB) and are not included in this repository:

| File | Size |
|---|---|
| `bureaucrat_pol.dta` | 199 MB |
| `dyad.dta` | 51 MB |
| `dyad_b.dta` | 325 MB |
| `script_data_for_replication.Rdata` | 288 MB |

Download them from Harvard Dataverse and place them in `bureaucrats_jop/`:

https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/RTYPSG

## 1. Overview of the paper

- The paper "Agency Alignment and Information Sharing in Congress: Questioning Networks and Analytical Content" replicates and extends Ban, Park, and You (2026), "Bureaucrats in Congress: The Politics of Interbranch Information Sharing," *Journal of Politics*.
- Ban, Park, and You find that bureaucrats give less analytical information to House members from the party opposite the president. The data cover House hearings from the 105th to the 113th Congress (1997–2014).
- The replication translates the authors' Stata scripts for Tables 2, 3, and 4 and appendix Table B8 to R. It reproduces the published coefficients, standard errors, and sample sizes at reported precision.
- The extension has three parts.
  - It treats questioning as a bipartite network of members and agencies and describes its centrality, closure, and community structure, with the 113th Congress as the focal case.
  - It replaces the median split of agency ideology in Table B8 with continuous measures of agency alignment and agency independence.
  - It specifies a bipartite exponential random graph model (ERGM) for questioning ties. The model is not fitted yet because it needs a verified set of member–agency pairs that could meet.
- The draft is working paper material for PLSC 508 (Political Networks).

## 2. Folder structure

```
ban-park-you-2026-jop/
├── README.md
├── descriptive_ban-et-al-2026_replication_extension_draft2_508_park_261023.Rmd
├── descriptive_ban-et-al-2026_replication_extension_draft2_508_park_261023.pdf
├── plan_ban-et-al-2026_replication_extension_draft1_508_park_260926.Rmd
├── plan_ban-et-al-2026_replication_extension_draft1_508_park_260926.pdf
├── hw1_ban-et-al-2026_508_park_261011.Rmd
├── hw1_ban-et-al-2026_508_park_261011.pdf
├── ban-park-you-2026-jop-bureaucrats-in-congress-interbranch-info-sharing.pdf
├── ban-park-you-2026-jop-appendix-bureaucrats-congress-politics-interbranch-infosharing.pdf
├── references.bib
├── apanodoi.csl
├── bureaucrats_jop/          # original replication archive from Harvard Dataverse
│   ├── 00_ReadMe.docx
│   ├── *.dta, *.Rdata, coef_plots.csv
│   ├── TABLE *.do, FIGURE *.do
│   └── Table1.R, Figure3.R, Figure_A3.R, Figure_A4_A5.R
└── additional-data/          # agency attributes added for the extension
    ├── README.md
    ├── raw/
    │   ├── agency_types_extract.csv
    │   ├── dynamic_estimates.csv
    │   └── rcl_ideal_points_merged.csv
    └── clean/
        ├── clean_agency_attributes.R
        └── agency_attributes.csv
```

## 3. Role of each file

### Papers and drafts

- `descriptive_ban-et-al-2026_replication_extension_draft2_508_park_261023.Rmd`: source of the current draft (draft 2). It reads the replication data and the agency attributes, runs every analysis, and builds every table and figure in the main text and Appendices A–E.
- `descriptive_ban-et-al-2026_replication_extension_draft2_508_park_261023.pdf`: knitted draft 2.
- `plan_ban-et-al-2026_replication_extension_draft1_508_park_260926.Rmd` and `.pdf`: research plan (draft 1).
- `hw1_ban-et-al-2026_508_park_261011.Rmd` and `.pdf`: first network visualization and analysis of the questioning network (homework 1). Draft 2 builds on its network code.
- `ban-park-you-2026-jop-bureaucrats-in-congress-interbranch-info-sharing.pdf`: published article.
- `ban-park-you-2026-jop-appendix-bureaucrats-congress-politics-interbranch-infosharing.pdf`: published online appendix, including Table B8.
- `references.bib`: BibTeX entries for all works cited in the drafts.
- `apanodoi.csl`: citation style file (APA style without DOIs) that the Rmd files use for references.

### Original replication archive (`bureaucrats_jop/`)

- The folder holds the authors' replication archive from Harvard Dataverse. No file in it has been changed.
- `00_ReadMe.docx`: the authors' readme. They use Stata MP 18. The datasets carry variable labels in place of a codebook.
- `dyad_b.dta`: one row for each pair of a bureaucratic witness and a member who questioned that witness in a House hearing. It is the main input for the network, the Table 2 and B8 replications, and the extension models. Not on GitHub.
- `dyad.dta`: witness–member pairs for all witnesses. The Table 3 replication uses its nonbureaucratic witnesses. Not on GitHub.
- `bureaucrat_pol.dta`: one row for each appearance of a bureaucratic witness in a House hearing from 1977 to 2014, with hearing, committee, agency, and appointment information. The authors' Figures 1, 2, A1, and A2 use it. Draft 2 loads it, but no current table uses it. Not on GitHub.
- `aggregate.dta`: one row for each hearing with question and answer totals. The Table 4 replication uses it.
- `script_data_for_replication.Rdata`: input to the authors' `Table1.R` and `Figure3.R`. Not on GitHub.
- `labels_for_test_set.Rdata`: input to the authors' `Figure_A3.R`.
- `coef_plots.csv`: input to the authors' `FIGURE A6.do` and `FIGURE A7.do`.
- `order.Rdata`: part of the archive. No script in the archive loads it.
- Draft 2 does not use the four files above.
- `TABLE *.do` and `FIGURE *.do`: the authors' Stata scripts for each table and figure. Draft 2 translates `TABLE 2.do`, `TABLE 3.do`, `TABLE 4.do`, and `TABLE A8.do` (appendix Table B8) to R.
- `Table1.R`, `Figure3.R`, `Figure_A3.R`, and `Figure_A4_A5.R`: the authors' R scripts.

### Additional agency data (`additional-data/`)

- `clean/clean_agency_attributes.R`: the only cleaning script. It reads the three raw files and `bureaucrats_jop/dyad_b.dta` and writes `clean/agency_attributes.csv`.
- `clean/agency_attributes.csv`: one row for each of the 64 agency codes in `dyad_b.dta`. Draft 2 reads it.
- `raw/`: source extracts for the leadership category, the regulatory indicator, and the Acs ideal points.
- `additional-data/README.md` describes each file, its source, its variables, and its coverage.

## 4. How to reproduce

1. Download the four large files listed under Data from Harvard Dataverse. Place them in `bureaucrats_jop/` without renaming them.
2. Install R and a LaTeX distribution with `pdflatex`. The draft was tested with R 4.6.1.
3. Install the R packages. The tested versions are listed below. The community results depend on igraph 2.3.3, and the replication was tested with fixest 0.14.2.

   | Package | Version |
   |---|---|
   | `igraph` | 2.3.3 |
   | `fixest` | 0.14.2 |
   | `rmarkdown` | 2.31 |
   | `bookdown` | 0.48 |
   | `knitr` | 1.51 |
   | `kableExtra` | 1.4.1 |
   | `dplyr` | 1.2.1 |
   | `ggplot2` | 4.0.3 |
   | `patchwork` | 1.3.2 |
   | `conflicted` | 1.2.0 |
   | `haven` | 2.5.5 |
   | `readr` | 2.2.0 |
   | `stringr` | 1.6.0 |
   | `tibble` | 3.3.1 |

   The ERGM chunk does not run yet (`eval=FALSE`), so `ergm`, `network`, and `btergm` are not needed to knit.

4. Optional: rebuild the agency attributes from this folder. The command overwrites `additional-data/clean/agency_attributes.csv` with the same content.

   ```sh
   Rscript additional-data/clean/clean_agency_attributes.R
   ```

5. Knit draft 2 from this folder.

   ```r
   rmarkdown::render("descriptive_ban-et-al-2026_replication_extension_draft2_508_park_261023.Rmd")
   ```

- The Rmd downloads nothing when it knits. It reads only `bureaucrats_jop/` and `additional-data/clean/agency_attributes.csv`.
- Seed 508 fixes the Louvain partition, the network layout, and the closure reference draws.
- A full knit fits all replication and extension models and takes a few minutes.

## 5. Data sources

- **Questioning data.** All hearing, witness, member, and analytical-score data come from the replication archive of Ban, Park, and You (2026) on Harvard Dataverse (doi:10.7910/DVN/RTYPSG).
- **Agency ideology.** The Richardson score (`agency_ideo` in `dyad_b.dta`) is already in the Ban, Park, and You data. It comes from Richardson, Clinton, and Lewis (2018), "Elite Perceptions of Agency Ideology and Workforce Skill," *Journal of Politics*. Federal executives rated agency ideology in a 2014 survey. Negative scores are liberal and positive scores conservative.
- **Agency independence.** The two Selin scores (`selin_ind1` and `selin_ind2` in `dyad_b.dta`) are also in the Ban, Park, and You data. They come from Selin (2015), "What Makes an Agency Independent?," *American Journal of Political Science*. Selin codes 50 structural features of 321 agencies and estimates the independence of decision makers and of policy decisions.
- **Agency names.** The Ban, Park, and You data name each agency with its name in the records of the Office of Personnel Management (OPM) (`opm_agencyname`). The cleaning script matches agencies on these names.
- **Leadership category.** The four-level category comes from the federal contract data of Fazekas, Ferrali, and Wachs (2023), "Agency Independence, Campaign Contributions, and Favoritism in US Federal Government Contracting," *Journal of Public Administration Research and Theory*. Their variable `agency_cat2` follows the agency types of Dahlström, Fazekas, and Lewis (2021), "Partisan Procurement," *American Journal of Political Science*.
- **Regulatory indicator.** The indicator comes from an earlier matched file that linked the Fazekas, Ferrali, and Wachs agencies to the Acs (2025) agencies. It combines exact name matches to Acs agencies and matches to agencies that issued final rules in the *Federal Register* from 2004 to 2015 with fuzzy name matches. Nobody has audited it yet.
- **Dynamic agency ideal points.** The Acs files come from the replication materials of Acs (2025), "Mapping the Political Contours of the Regulatory State: Dynamic Estimates of Agency Ideal Points," *American Political Science Review*. Acs estimates an ideal point for each agency and administration from presidential review of planned regulations by the Office of Information and Regulatory Affairs (OIRA).
- **Science agencies.** The science flag is my own exploratory grouping of five agencies. It is not a published classification.
- **Committee assignments (planned).** The ERGM opportunity set will use the House committee assignment data of Charles Stewart III and Jonathan Woon. These data are not in the folder yet.

## 6. Agency attribute coding

- **Unit.** The unit is the agency code (`agencycode`) in `dyad_b.dta`. The clean file has 64 rows, one for each code.
- **Name matching.** The script lowercases each OPM name and spells out "&" and "admin." It removes punctuation and writes "U.S." as "united states." It then joins the OPM names to the source agency names by exact match on these keys. It uses no fuzzy matching.
- **Raw extract.** The extract holds 180 distinct, unaltered tuples of agency name, `agency_cat2`, and `regulatory_finalmatch`. It was drawn on 2026-10-24 from the Fazekas, Ferrali, and Wachs contract file (`contracts.csv`) and the earlier matched file (`df_extension_finalmatch_fazekas-acs.csv`). Before the extraction, all 475,459 contract row IDs agreed across the two files. The extract adds no new classification.
- **One value per code.** A code receives a category only when every matched source row and every OPM unit under that code agree on one nonmissing value. Missing or conflicting source values stay missing. Codes with an unmatched constituent OPM unit also stay missing.
- **`l1_four_level`.** This variable keeps the source `agency_cat2` labels. It is not a binning of the Selin scores. It covers 33 codes.
- **`independence_binary`.** This variable keeps an earlier binary rule. Independent commissions equal 1, the two executive department categories equal 0, and other categories are missing. Draft 2 does not use it.
- **`regulatory`.** This variable keeps `regulatory_finalmatch` unchanged and covers 39 codes. It records a function, not statutory authority. It is not the complement of service provision. Draft 2 uses it only in a descriptive appendix table.
- **`science_flag`.** The Environmental Protection Agency (EP), the National Aeronautics and Space Administration (NN), the National Science Foundation (NF), the Department of Energy (DN), and the Nuclear Regulatory Commission (NU) equal 1. All other codes equal 0.
- **`acs_agency_id`.** The script assigns 11 direct parent-level Acs keys by hand after an identity audit. It does not average bureau scores into a parent score. Join the Acs estimates by the actual president (Clinton, Bush, or Obama) and not by Congress alone. Agency–administration cells without an estimate stay missing.
- **Department of Defense.** The code DD pools the Department of Defense with the Departments of the Air Force, the Army, and the Navy. Their categories and scores do not agree, so DD stays one graph code with missing attributes. The script imputes nothing for it.
- **Static attributes.** All attributes are static. Nobody has verified that each category applies to every hearing year from 1997 to 2014.
- **Replication files.** The cleaning script does not change any file in `bureaucrats_jop/`. It downloads nothing.
