# From the authors Leifeld, P., & Schneider, V. (2012) ---
# Replication files for "Information exchange in policy networks"

Leifeld, P., & Schneider, V. (2012). Information exchange in policy networks. *American Journal of Political Science*, 56(3), 731-744. Data archived at https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/ONDFVJ

The data describe the German toxic chemicals policy domain. Organizations were surveyed in the winter of 1984/1985; 40 of 47 actors responded, and the 30 actors cited as influential by at least one other actor were retained as the influence core. All `.csv` matrices below cover these 30 actors.


## File structure

- `README.md`: the file you are currently reading
- `AJPS.R`: replication script (data import, ERGM estimation, goodness-of-fit)
- `data description.txt`: the authors' index of the data files
- `ChemNetDe.zip`: the original archive as downloaded

- Networks and attributes. Each `.csv` is semicolon-separated with organization names in the `label` column:
    - `pol.csv`: political/strategic information exchange; directed. Respondents named the organizations with which they regularly exchange information, so a tie records a perceived exchange partnership rather than the direction of sending
    - `scifrom.csv`, `scito.csv`: technical/scientific information exchange; sender and receiver reports, combined by the authors into a confirmed network (equation 1)
    - `infrep.csv`: mutual influence attribution; 1 = row actor considers column actor influential
    - `committee.csv`: committee membership; affiliation network
    - `intpos.csv`: policy positions on six core issues; -1 = disagree, 0 = neutral, +1 = agree
    - `ideol.csv`: four policy frames; affiliation network
    - `orgtypes.csv`: type of organization

- `*.dl`: the same matrices in UCINET DL format. `pol47.dl` and `infrep47.dl` cover the extended set of 47 actors

- Documentation:
    - `actors.pdf`: list of actors and committees
    - `survey-en.pdf`, `survey-de.pdf`: the questionnaire in English translation and the German original
    - `leifeld-schenider-2012-ajps-Information Exchange in Policy Networks.pdf`: the published article

## How to use this replication file

Run the script `AJPS.R`. Please make sure to set the working directory to the folder that contains this script, and install the packages `statnet` and `coda` before proceeding. The ERGM and goodness-of-fit sections take some time to run.

---

# Park ---

Method tutorial on reciprocity and transitivity for Bruce's PLSC 508 Political Networks (Week 4). It uses the authors' `pol.csv` and the data-import steps in `AJPS.R` to build the directed political/strategic information-exchange network, then reports a dyad census, raw and density-adjusted reciprocity, and directed transitivity. It does not re-estimate the authors' ERGMs.

- `+park_method_tutorial_leifled-schneider-2012_508_260905.Rmd` : R markdown file for the tutorial
- `+park_method_tutorial_leifled-schneider-2012_508_260905.html` : HTML output of the R markdown file
- `+park_method_tutorial_leifled-schneider-2012_508_260905.Rproj` : RStudio project file

- Extra files for formatting:
  - `apanodoi.csl`
  - `styles.css`
  - `references.bib`

## How to knit

Open the `.Rproj` file so that the working directory is this folder, then knit the `.Rmd`. Output is `bookdown::html_document2`, which supplies the numbered table and figure cross-references. Required packages: `network`, `sna`, `magrittr`, `knitr`, `kableExtra`, `here`, and `bookdown`.
