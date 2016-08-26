#source("https://bioconductor.org/biocLite.R")
#biocLite()
library(breastCancerMAINZ)
library(Biobase)
library(limma)
library(ACSNMineR)
library(hgu133a.db)
library(RNaviCell)
# load data and extract expression and phenotype data
data(mainz)
eset <- exprs(mainz)
pdat <- pData(mainz)
# Create list of genes differentially expressed between ER positive and
# ER negative samples using moderated t-test statistics
design <- model.matrix(~factor(pdat$er == '1'))
lmFit(eset, design) -> fit
eBayes(fit) -> ebayes
toptable(ebayes, coef=2,n=25000) -> tt
which(tt$adj < 0.05) -> selection
rownames(tt[selection,]) -> probe_list
mget(probe_list, env=hgu133aSYMBOL) -> symbol_list
symbol_list <- as.character(symbol_list)
# calculate enrichment in ACSN maps
enrichment(symbol_list) -> results
dim(results)


### Generate table
if(!require("xtable")) install.packages("xtable")
print(xtable::xtable(results[,c("module","module_size","nb_genes_in_module","p.value","p.value.corrected")],
                     display = c("s","d","d","g","g")),
      include.rownames = FALSE)

mtsig <- format_from_gmt('jss/scripts/c2.cp.v5.0.symbols.gmt')
mtsig_enrich<- enrichment(symbol_list, maps = mtsig)[,c("module","module_size","nb_genes_in_module","p.value.corrected")]
print(xtable::xtable(mtsig_enrich), include.rownames=FALSE)

### Show 10 with lowest p-value
print(xtable::xtable(mtsig_enrich[order(mtsig_enrich$p.value.corrected,decreasing = FALSE)[1:10],],
                     display = c("s","d","d","g","g")),
      include.rownames=FALSE,math.style.exponents = TRUE)


## Extract genes lowly expressed
apply(eset[probe_list,pdat$er == 0],1,mean)->er_minus_mean
names(er_minus_mean)<-symbol_list
er_minus_mean<-as.matrix(er_minus_mean)
colnames(er_minus_mean) <- c('exp')

## NaviCell viz
navicell<-NaviCell()
navicell$proxy_url <- "https://acsn.curie.fr/cgi-bin/nv_proxy.php"
navicell$map_url <- "https://acsn.curie.fr/navicell/maps/acsn/master/index.php"
navicell$launchBrowser()
navicell$importDatatable("mRNA expression data", "GBM_exp", er_minus_mean)
navicell$heatmapEditorSelectSample('0','exp')
navicell$heatmapEditorSelectDatatable('0','GBM_exp')
navicell$heatmapEditorApply()

