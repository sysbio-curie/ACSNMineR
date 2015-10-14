# <a name="I">ACSN Enrichment</a>


##  <a name="IIA">Description </a>
ACSNEnrichment is an R package, freely available.

This package is designed for an easy analysis of gene maps (either user imported from gmt files or ACSN maps).
Its aim is to allow a statistical analysis of statistically enriched or depleted pathways from a user imported gene list, as well as a graphic representation of results.

This readme contains:

  [1. This description](#IIA)

  [2. Usage section](#IIB)

  [2.1. Pathway analysis](#IIIA)

  [2.2. Data vizualization](#IIIB)

  [2.2.1. Heatmaps](#IVA)

  [2.2.2. Barplots](#IVB)


##  <a name="IIB">Usage </a>
###  <a name="IIIA">Pathway analysis</a> 
The gene set that was used for tests is the following:
> genes_test<-c("ATM","ATR","CHEK2","CREBBP","TFDP1","E2F1","EP300","HDAC1","KAT2B","GTF2H1","GTF2H2","GTF2H2B")

Gene set enrichment for a single set can be performed by calling:
> enrichment(genes_test,min_module_size = 10, threshold = 0.05, maps = list(cellcycle = ACSN_cellcyc_formatted))

Where:
*min_module_size is the minimal size of a module to be taken into account
*threshold is the maximal p-value that will be displayed in the results (all modules with p-values higher than threshold will be removed)
*maps is a list of MAPS, here we take the cell cycle map from ACSN, imported through the format_from_gmt() function of the package



###  <a name="IIIB">Data visualization</a> 
Results from the enrichment analysis function can be transformed to images thanks to the represent enrichment function. Two different plot are available: heatmap and barplot.
####  <a name="IVA">Heatmaps</a>  
![alt tag](https://github.com/sysbio-curie/ACSN_Enrichment/blob/master/Images/Heatmap.png)

####  <a name="IVB">Barplots</a> 
![alt tag](https://github.com/sysbio-curie/ACSN_Enrichment/blob/master/Images/barplot.png)
