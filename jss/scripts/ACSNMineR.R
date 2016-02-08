### Script to reproduce results and figures from ACSNMineR paper

library(ACSNMineR)

### print ACSN map structure:
print(length(ACSNMineR::ACSN_maps))
print(names(ACSNMineR::ACSN_maps))

for(map in names(ACSNMineR::ACSN_maps)){
  print(map)
  MAP<-ACSNMineR::ACSN_maps[[map]]
  
  print(paste("Number of genes:",sum(unique(as.character(MAP[,-(1:2)]))!="")))
  MODS<-as.numeric(as.character(MAP[,2]))
  print(paste("Number of modules:",length(MODS)))
  print(paste("Smallest module size:",min(MODS)))
  print(paste("Biggest module size:",max(MODS)))
  print(paste("Mean module size:", round(mean(MODS))))
  print("**************")
}

### Print genes test

print(genes_test)

### compute corrected enrichment
results<-enrichment(genes_test)

print(dim(results))

print(results[1,])

### compute uncorrected enrichment

results_uncorrected<-enrichment(genes_test,correction_multitest = FALSE)
print(head(results_uncorrected,3))


### Plot heatmap
heatmap <- represent_enrichment(enrichment = list(Corrected = results[1:6,], 
                                       Uncorrected = results_uncorrected[1:6,]),
                                plot = "heatmap", scale = "reverselog", 
                                low = "steelblue" , high ="white", na.value = "grey")

print(heatmap)

### Plot bar
baplot <- represent_enrichment(enrichment = list(Corrected = results[1:6,], 
                                                 Uncorrected = results_uncorrected[1:6,]),
                               plot = "heatmap", scale = "reverselog", 
                               nrow = 1)
print(barplot)


### End of ACSNMineR demo