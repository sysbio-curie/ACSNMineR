This package contains R scripts and data to reproduce some of the figures of the
paper "Calculating Biological Module Enrichment or Depletion and Visualizing
Data on Large-scale Molecular Maps with the R packages ACSNMineR and RNaviCell".

Note that only figures for which the data is not easily available online (for
instance included in a Bioconductor package) is included here. Other figures and
tables can easily be reproduced with the code snippets included in the paper.

The scripts are:
- DU145_heatmap.R: load cell line DU145 expression data and creates heatmap
  visualization.
- GBM_mutations_glyphs.R: load glioblastoma (GBM) data frequently mutated genes
  and creates glyph visualization on the ACSN master map.
- gbm_enrichment.R: load GBM data and calculates ACSN maps enrichment
  statistics. 

The libraries ACSNMineR and RNaviCell should be installed (they are available on
CRAN and GitHub).

The default browser on your machine should be Chrome, Firefox or Safari.

To reproduce the figures, you can execute the scripts with the commands:

Rscript DU145_heatmap.R

You can also source the scripts from within an R session:

> source('DU145_heatmap.R')

Comments and questions to paul.deveau@curie.fr, eric.bonnet@curie.fr.
