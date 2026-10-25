# run from the ban project directory
# keep the four-level agency types from the fazekas et al. (2023) contract data, which follow dahlström et al. (2021)
# keep the earlier regulatory coding unchanged
library(dplyr)
library(readr)
library(stringr)
clean_name <- function(x) {
  x %>% str_to_lower() %>% str_replace_all("&", " and ") %>%
    str_replace_all("\\badmin\\.?\\b", "administration") %>%
    str_replace_all("[^a-z0-9]+", " ") %>% str_squish()
}
canonical_name <- function(x) {
  clean_name(x) %>% str_replace_all("\\bu s\\b|\\bus\\b", "united states")
}
source <- read_csv("additional-data/raw/agency_types_extract.csv", show_col_types = FALSE) %>%
  mutate(agency_key = canonical_name(agency_name))
ban <- haven::read_dta("bureaucrats_jop/dyad_b.dta")
units <- ban %>% distinct(agencycode, opm_agencyname) %>%
  mutate(agency_key = canonical_name(opm_agencyname))
# require one nonmissing category across every source tuple and opm unit
unique_text <- function(x) if (anyNA(x) || n_distinct(x) != 1) NA_character_ else as.character(x[1])
matched <- units %>% left_join(source, by = "agency_key", relationship = "many-to-many")
attrs <- matched %>% group_by(agencycode) %>% summarise(
  opm_names = paste(sort(unique(opm_agencyname)), collapse = " | "),
  l1_four_level = unique_text(agency_cat2),
  regulatory = as.integer(unique_text(regulatory_finalmatch)),
  matched_opm_units = n_distinct(opm_agencyname[!is.na(agency_name)]),
  opm_units = n_distinct(opm_agencyname), .groups = "drop") %>%
  mutate(science_flag = as.integer(agencycode %in% c("EP", "NN", "NF", "DN", "NU")),
    independence_binary = case_when(l1_four_level == "indep. commission & IRC" ~ 1L,
      l1_four_level %in% c("cabinet/exec. dep. (not bureau)", "cabinet/exec. dep. and bureau") ~ 0L,
      TRUE ~ NA_integer_))
# direct acs parent matches: no bureau averaging or richardson-name substitution
acs_keys <- tibble::tribble(~agencycode, ~acs_agency_id,
  "AM", "AID", "BG", "DOL-PBGC", "CU", "NCUA", "GS", "GSA", "NN", "NASA",
  "NQ", "NARA", "OM", "OPM", "SB", "SBA", "ST", "STATE", "SZ", "SSA", "VA", "VA")
acs <- read_csv("additional-data/raw/dynamic_estimates.csv", show_col_types = FALSE)
stopifnot(all(acs_keys$acs_agency_id %in% acs$agency.id), !anyDuplicated(acs[c("agency.id", "admin")]))
attrs <- attrs %>% left_join(acs_keys, by = "agencycode") %>% mutate(
  acs_admin_key = if_else(!is.na(acs_agency_id), "Clinton|Bush|Obama; match actual president", NA_character_),
  coverage_notes = paste0(
    if_else(is.na(l1_four_level), "L1 unmatched, missing, or conflicting; ", "L1 from Fazekas et al. (2023) agency types; "),
    if_else(is.na(regulatory), "Regulatory unresolved; ", "Regulatory inherited unaudited exact/rule-issuer/fuzzy source; "),
    if_else(is.na(acs_agency_id), "No direct Acs parent match; ", "Direct Acs key; verify appearance identity; "),
    "Static attributes: historical applicability unverified; science flag exploratory"))
stopifnot(nrow(attrs) == n_distinct(ban$agencycode), !anyDuplicated(attrs$agencycode),
  all(attrs$regulatory %in% c(0L, 1L, NA_integer_)))
write_csv(attrs, "additional-data/clean/agency_attributes.csv", na = "")
print(attrs %>% summarise(codes = n(), l1 = sum(!is.na(l1_four_level)),
  regulatory = sum(!is.na(regulatory)), science = sum(science_flag), acs = sum(!is.na(acs_agency_id))))
