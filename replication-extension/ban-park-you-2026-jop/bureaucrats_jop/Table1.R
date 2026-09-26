load("script_data_for_replication.Rdata")


# Highest point example
top <- script[!is.na(script$rownumber) & script$ascore==100, c("ascore", "speech")]
top$witness <- "Steven A. Williams, Director of Fish and Wildlife Service, U.S. Dept. of the Interior"

# Median point example
median(script$ascore) # 30.80072
script[script$ascore>=30.80068 & script$ascore < 30.80073,c("rownumber", "ascore")] # Note: Strangely, there is no observations with exactly 30.80072 points. This is the closest number to the median. So, let's go with one of these.
median <- script[!is.na(script$rownumber) & script$rownumber==1220366, c("ascore", "speech")]
median$witness <- "Jane Oates, Assistant Secretary for the Employment and Training Administration, U.S. Dept. of Labor"


# Lowest point example
bottom <- script[!is.na(script$rownumber) & script$ascore==0, c("ascore", "speech")]
bottom$witness <- "Mary Schapiro, Chairman, U.S. Securities and Exchange Commission"

table1 <- rbind(top, median, bottom)
table1
