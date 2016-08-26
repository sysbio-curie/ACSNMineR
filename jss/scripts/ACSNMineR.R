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
print(nrow(results_uncorrected))

print(xtable::xtable(results_uncorrected[1:3,c("module","module_size","genes_in_module","p.value","test")],
                     display = c("s","d","s","g","g","s")),
      include.rownames = FALSE,math.style.exponents = TRUE)

### Plot heatmap
heatmap <- represent_enrichment(enrichment = list(Corrected = results[1:6,], 
                                       Uncorrected = results_uncorrected[1:6,]),
                                plot = "heatmap", scale = "reverselog", 
                                low = "steelblue" , high ="white", na.value = "grey")

ggsave("jss/figures/comparison_corrected_unc.pdf")
### Plot bar
pdf("jss/figures/comparison_corrected_unc_bars.pdf")
represent_enrichment(enrichment = list(Corrected = results[1:6,], 
                                                 Uncorrected = results_uncorrected[1:6,]),
                               plot = "bar", scale = "reverselog", 
                               nrow = 1)
dev.off()

### End of ACSNMineR demo