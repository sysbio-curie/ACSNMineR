% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ACSN_Enrichment.R
\name{multisample_enrichment}
\alias{multisample_enrichment}
\title{Automated gene set analysis for multiple sets}
\usage{
multisample_enrichment(Genes_by_sample = NULL, maps = c("Apoptosis",
  "CellCycle", "DNA_repair", "EMT_motility", "Survival"),
  correction_multitest = "BH", statistical_test = "fisher",
  min_module_size = 5, universe = "map_defined",
  Remove_from_universe = NULL, threshold = 0.05, cohort_threshold = TRUE,
  alternative = "greater")
}
\arguments{
\item{Genes_by_sample}{List of character vectors. Each list element name should be a sample name, 
and each character vector the set of genes to test for the sample.}

\item{maps}{list of maps generated by format_from_gmt. Default: tests on all acsn maps}

\item{correction_multitest}{either FALSE, "bonferroni", "holm", "hochberg", "hommel", "BH", "fdr" (identical to BH), or "BY"}

\item{statistical_test}{one of "fisher", "hypergeom"}

\item{min_module_size}{will remove from the analysis all modules which are (strictly) smaller than threshold}

\item{universe}{Universe on which the statistical analysis should be performed. Can be either "HUGO","ACSN" 
,"map_defined", or a character vector of genes.}

\item{Remove_from_universe}{Default is NULL. A list of genes that should not be considered for enrichment 
(will be removed from input, maps, and universe). The size of universe and map will be updated after removal.}

\item{threshold}{maximal p-value (corrected if correction is enabled) that will be displayed}

\item{cohort_threshold}{if TRUE modules will be kept in all samples if at least one sample 
has p-value lower than threshold, otherwise the threshold is applied for each sample independently.}

\item{alternative}{One of "greater", "less", "both", or "two.sided" (only for fisher test).
Greater will check for enrichment, less will check for depletion, and both will look for both.}
}
\value{
Output is a list of dataframes with names the names given in `Genes_by_sample` with the following columns:\describe{
 \item{module}{The name of the map or the module preceded by the map}
 \item{module_size}{The number of genes in the module after taking into account universe reduction}
 \item{nb_genes_in_module}{The number of genes from input list in the module}
 \item{genes_in_module}{Names of the genes from input list in the module, space separated}
 \item{universe_size}{size of the input universe}
 \item{nb_genes_in_universe}{number of genes from the input list that are found in the universe}
 \item{test}{the kind of test that was looked for. "greater" when enrichment is tested, "less" when depletion is tested, or "two.sided"}
}
}
\description{
Automated gene set analysis for multiple sets
}
\examples{
multisample_enrichment(Genes_by_sample = list(set1 = genes_test,set2=c(genes_test,"PTPRD")),
maps = list(cellcycle = ACSNMineR::ACSN_maps$CellCycle),
min_module_size = 10,
universe = "ACSN",cohort_threshold = FALSE)
}

