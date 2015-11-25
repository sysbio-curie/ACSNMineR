####Build Status:
[![Build Status](https://travis-ci.org/sysbio-curie/ACSNMineR.svg?branch=master)](https://travis-ci.org/sysbio-curie/ACSN_Enrichment)
####CRAN Status and statistics : 
[![CRAN version](http://www.r-pkg.org/badges/version/ACSNMineR)](http://www.r-pkg.org/badges/version/ACSNMineR)
[![CRAN downloads weekly](http://cranlogs.r-pkg.org/badges/ACSNMineR)](http://cran.rstudio.com/web/packages/ACSNMineR/index.html)
[![CRAN total](http://cranlogs.r-pkg.org/badges/grand-total/ACSNMineR)](http://cran.rstudio.com/web/packagesACSNMineR/index.html)

# <a name="I">ACSNMineR</a>


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
______
The gene set that was used for tests is the following:
> genes_test<-c("ATM","ATR","CHEK2","CREBBP","TFDP1","E2F1","EP300","HDAC1","KAT2B","GTF2H1","GTF2H2","GTF2H2B")

Gene set enrichment for a single set can be performed by calling:
> enrichment(genes_test,
    min_module_size = 10, 
    threshold = 0.05,
    maps = list(cellcycle = ACSNEnrichment::ACSN_maps$CellCycle))

Where:
* genes_test is a character vector to test
* min_module_size is the minimal size of a module to be taken into account
* threshold is the maximal p-value that will be displayed in the results (all modules with p-values higher than threshold will be removed)
* maps is a list of maps -here we take the cell cycle map from ACSN-  imported through the format_from_gmt() function of the package

Gene set enrichment for multiple sets/cohorts can be performed by calling:
>multisample_enrichment(Genes_by_sample = list(set1 = genes_test[-1],set2=genes_test[-2]),
    maps = ACSNEnrichment::ACSN_maps$CellCycle,
    min_module_size = 15)

Where:

* Genes_by_sample is a list of character vectors to test
* min_module_size is the minimal size of a module to be taken into account
* maps is a list of maps -here we take the cell cycle map from ACSN - imported through the format_from_gmt() function of the package


###  <a name="IIIB">Data visualization</a> 
______
Results from the enrichment analysis function can be transformed to images thanks to the represent enrichment function. Two different plot are available: heatmap and barplot.
####  <a name="IVA">Heatmaps</a>  
______
Heatmaps for single sample or multiple sample representing p-values can be easily generated thanks to the represent_enrichment function.
> represent_enrichment(enrichment = list(SampleA = enrichment_test[1:10,], 
    SampleB = enrichment_test[3:10,]),
    plot = "heatmap", 
    scale = "log",
    low = "steelblue" , high ="white",
    na.value = "grey")

Where:

* enrichment is the result from the enrichment or multisample_enrichment function
* scale can be set to either identity or log and will affect the gradient of colors
* low: the color for the low (significant) p-values 
* high: color for the high (less significant) p-values 
* na.value is the color in which tiles which have "NA" should appear

The result of this is:
![alt tag](https://github.com/sysbio-curie/ACSN_Enrichment/blob/master/Images/Heatmap.png)

####  <a name="IVB">Barplots</a> 
______
A barplot can be achieved by using the following:
> represent_enrichment(enrichment = list(SampleA = enrichment_test[1:10,], 
    'SampleB = enrichment_test[3:10,]),
    plot = "bar", 
    scale = "log",
    nrow = 1)

Where:
* enrichment is the result from the enrichment or multisample_enrichment function
* scale can be set to either identity or log and will affect the gradient of colors
* nrow is the number of rows that should be used to plot all barplots (default is 1)

![alt tag](https://github.com/sysbio-curie/ACSN_Enrichment/blob/master/Images/barplot.png)
