# calculate ACSN maps enrichment for frequently mutated GBM genes

# load library
library(ACSNMineR)

# read gbm data
read.table('gbm.txt', header=T) -> gbm

# create a list from GBM genes and calculate enrichment statistics
gbm_list <- as.character(gbm$gbm)
results <- enrichment(gbm_list)

# write results to a text file
write.table(results[,c(1,2,3,8)], file='gbm_enrichment.txt', sep='\t', quote=F, row.names=F)

