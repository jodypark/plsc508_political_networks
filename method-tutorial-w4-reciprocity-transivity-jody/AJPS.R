# This is a script for the statistical programming environment R.
# R can be obtained from: http://www.r-project.org
# Please install the packages `statnet' and `coda' before proceeding!


########## PREPARATORY STEPS ##########

# set random seed (for replication)
set.seed(12345)

# load R packages
library(statnet)
require(coda)


########## LOAD DATA ##########

# committee affiliation data
# 1 = affiliation; 0 = no affiliation
# committee names are in the row labels; actors in the column labels
comm <- read.table(file="committee.csv", header=T, row.names="label", sep=";")

# influence reputation data
# square matrix with mutual influence attribution
# 1 = influential; 0 = not influential
# cells contain the ratings of row actors about column actors
infrep <- read.table(file="infrep.csv", header=T, row.names="label", sep=";")

# political/strategic information exchange data
# directed network
pol <- read.table(file="pol.csv", header=T, row.names="label", sep=";")

# scientific sender matrix
# row actor sends scientific/technical information to column actor
scifrom <- read.table(file="scifrom.csv", header=T, row.names="label", sep=";")

# scientific receiver matrix
# row actor receives scientific/technical information from column actor
scito <- read.table(file="scito.csv", header=T, row.names="label", sep=";")

# issue positions/preferences on six key issues
# -1 = do not agree, 0 = neutral, +1 = agree
intpos <- read.table(file="intpos.csv", header=T, row.names="label", sep=";")

# type of organization
types <- read.table(file="orgtypes.csv", header=T, row.names="label", sep=";")


########## PREPARE RAW DATA FOR THE ANALYSIS ##########

# apply some changes to the data to make them network-compatible
sci <- as.matrix(scito) * t(as.matrix(scifrom)) # equation 1 in the paper
prefsim <- dist(intpos, method="euclidean", diag=F, upper=T) # equation 2
prefsim <- max(prefsim) - prefsim # equation 3
prefsim <- as.matrix(prefsim)
committee <- crossprod(as.matrix(comm),as.matrix(comm)) # equation 4
diag(committee) <- 0 # the diagonal has no meaning
types <- as.character(types[,1]) # convert to character vector
pol <- as.matrix(pol) # convert to matrix object
infrep <- as.matrix(infrep) # convert to matrix object

# convert matrices to networks and attach attributes to them
nw.infrep <- network(infrep) # mutual influence attribution
set.vertex.attribute(nw.infrep, "orgtype", types)

nw.pol <- network(pol) # political/stratgic information exchange
set.vertex.attribute(nw.pol, "orgtype", types)
set.vertex.attribute(nw.pol, "betweenness", betweenness(nw.pol)) # centrality

nw.sci <- network(sci) # confirmed and directed technical information exchange
set.vertex.attribute(nw.sci, "orgtype", types)
set.vertex.attribute(nw.sci, "betweenness", betweenness(nw.sci)) # centrality

nw.committee <- network(committee, directed=FALSE) # no. of common committees
set.vertex.attribute(nw.committee, "orgtype", types)
set.edge.value(nw.committee, "weight", committee)

nw.intpos <- network(prefsim, directed=FALSE) # similarity in interest positions
set.vertex.attribute(nw.intpos, "orgtype", types)
set.edge.value(nw.intpos, "weight", prefsim)


########## ESTIMATION OF ERGMS ##########

# ERGM: political/strategic information exchange; only preference similarity
model1 <- ergm(nw.pol ~ edges + edgecov(nw.intpos, "weight"),
  eval.loglik=TRUE, check.degeneracy=TRUE, seed=12345)
sink(file="model1.txt") # this output file contains coefficients
print(summary(model1))
print(model1$mle.lik) # also print the log likelihood
sink()

# ERGM: political/strategic information exchange; complete model
model2 <- ergm(nw.pol ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.sci) + edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE), eval.loglik=TRUE, check.degeneracy=TRUE,
  seed=12345)
sink(file="model2.txt") # this output file contains coefficients
print(summary(model2))
print(model2$mle.lik) # also print the log likelihood
sink()

# ERGM: technical/scientific information exchange; only preference similarity
model3 <- ergm(nw.sci ~ edges + edgecov(nw.intpos, "weight"),
  eval.loglik=TRUE, check.degeneracy=TRUE, seed=12345)
sink(file="model3.txt") # this output file contains coefficients
print(summary(model3))
print(model3$mle.lik) # also print the log likelihood
sink()

# ERGM: technical/scientific information exchange; complete model
model4 <- ergm(nw.sci ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.pol) + edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE), eval.loglik=TRUE, check.degeneracy=TRUE,
  seed=12345)
sink(file="model4.txt") # this output file contains coefficients
print(summary(model4))
print(model4$mle.lik) # also print the log likelihood
sink()

# ERGM: like model 2, but without the other communication (validity check)
model5 <- ergm(nw.pol ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE), eval.loglik=TRUE, check.degeneracy=TRUE,
  seed=12345)
sink(file="model5.txt") # this output file contains coefficients
print(summary(model5))
print(model5$mle.lik) # also print the log likelihood
sink()

# ERGM: like model 2, but with betwenness centrality as covariate of alter
model6 <- ergm(nw.pol ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.sci) + edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE) + nodeicov("betweenness"), eval.loglik=TRUE,
  check.degeneracy=TRUE, seed=12345)
sink(file="model6.txt") # this output file contains coefficients
print(summary(model6))
print(model6$mle.lik) # also print the log likelihood
sink()

# ERGM: like model 4, but without the other communication (validity check)
model7 <- ergm(nw.sci ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE), eval.loglik=TRUE, check.degeneracy=TRUE,
  seed=12345)
sink(file="model7.txt") # this output file contains coefficients
print(summary(model7))
print(model7$mle.lik) # also print the log likelihood
sink()

# ERGM: like model 4, but with betwenness centrality as covariate of alter
model8 <- ergm(nw.sci ~ edges + edgecov(nw.intpos, "weight") + mutual +
  nodemix("orgtype", base = -7) + nodeifactor("orgtype", base = -1) +
  nodeofactor("orgtype", base = -5) + edgecov(nw.committee, "weight") +
  edgecov(nw.pol) + edgecov(nw.infrep) + gwesp(0.1, fixed = TRUE) +
  gwdsp(0.1, fixed = TRUE) + nodeicov("betweenness"), eval.loglik=TRUE,
  check.degeneracy=TRUE, seed=12345)
sink(file="model8.txt") # this output file contains coefficients
print(summary(model8))
print(model8$mle.lik) # also print the log likelihood
sink()


########## GOODNESS-OF-FIT AND MCMC DIAGNOSTICS ##########

# goodness-of-fit assessment as shown in figure 1
gof2 <- gof(model2 ~ idegree + espartners + distance, verbose = FALSE,
  burnin = 1e+5, interval = 1e+5)
gof4 <- gof(model4 ~ idegree + espartners + distance, verbose = FALSE,
  burnin = 1e+5, interval = 1e+5)

pdf("gof.pdf")
par(mfrow = c(2, 3))
plot(gof2)
plot(gof4)
dev.off()

# print MCMC diagnostics to make sure the models are not degenerate
pdf("diagnostics2.pdf")
mcmc.diagnostics(model2)
dev.off()

pdf("diagnostics4.pdf")
mcmc.diagnostics(model4)
dev.off()
