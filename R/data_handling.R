#Data and data handling

#' Atlas of Cancer Signalling Networks
#' 
#' A dataset containing the six maps of ACSN: apoptosis, cell cycle, DNA reparation, EMT motility, survival, and the master map
#' @format A list of dataframes
#' \describe{
#'  \item{Apoptosis}{Map of apoptosis pathways}
#'  \item{CellCycle}{Map of the cell cycle pathways}
#'  \item{DNA_repair}{Map of DNA repair}
#'  \item{EMT_motility}{Map of the Epithelial Mesenchymal Transition}
#'  \item{Master}{Map grouping all modules from other maps, without a master module for each map}
#'  \item{Survival}{Map of cellular survival pathways}
#' }
#' @source \url{https://acsn.curie.fr/downloads.html}
"ACSN_maps"

#' Set of genes to test map
#' 
#' Genes of high importance in oncogenesis
#' @format A character vector
"genes_test"

#' Result from enrichment test of "genes_test" on the ACSN maps
#' 
#' Parameters: bonferroni correction, min module size = 5
#' @format data.frame
#' \describe{
#'  \item{module}{Name of module}
#'  \item{genes_in_module}{Genes from genes_test in module}
#'  \item{p.value}{Uncorrected p-value}
#'  \item{p.value.corrected}{p-value corrected for multiple testing by Bonferroni correction}
#'  }
"enrichment_test"


#' Import data from gmt files
#' Convert gmt file to dataframe that can be used for anaysis
#'@param path Path to the gmt file to be imported
#'@return Returns a dataframe with the module - first column -, module length - seconde column - and gene names
#'@examples file<-system.file("extdata", "cellcycle_short.gmt", package = "ACSNMineR")
#'format_from_gmt(file)
#'
#'@export

format_from_gmt<-function(path = ""){
  
  Lines<-readLines(path,warn = FALSE)
  
  
  ### Filter out non-genes
  if(length(Lines)==1){ ### testing if gmt is single line
    gmt<-unlist(strsplit(x = Lines,split = "\t"))
    short_gmt<-gmt[-c(1,2)]
    pos<-grepl(pattern = "\\*",x = short_gmt)
    result<-c(gmt[c(1,2)],gmt[-c(1,2)][!pos])
    result[2]<-length(result)-2
    result<-as.data.frame(t(result))
    
    
  }
  else{
    max_length<-max(sapply(X=Lines,FUN = function(z){
      z2<-gsub("\t","",z)
      return(nchar(z)-nchar(z2))
    }))+1  ### max gets number of intervals, so number of items is max +1
    gmt<-read.csv(path,header = FALSE, 
                  sep = "\t",fill = TRUE,
                  col.names = paste("V",1:max_length,sep="")
    )
    gmt[is.na(gmt)]<-""
    result<-t(apply(gmt,1,FUN = function(z){
      pos<-grepl(pattern = "\\*",x = z)
      res<-z
      res[pos]<-""
      return(res)
    }))
    
    if(sum(is.na(x = result[,ncol(result)]))){
      result<-result[,-ncol(result)]
    }
    result[,2]<-apply(result[,-(1:2)],MARGIN =  1, FUN = function(z) sum(as.character(z)!=""))
    
  }
  
  return(result)
}

#' From a list of maps, create  or replace a master
#' 
#' @param maps A list of molecular maps created by `format_from_gmt`
#' @return Returns a list with previous maps and the master map, i.e. a concatenation of previous maps.
#' @examples 
#' Create_master_map(list(Cycle = ACSNMineR::ACSN_maps$CellCycle,
#'                    Apoptosis = ACSNMineR::ACSN_maps$Apoptosis))
#' @export
Create_master_map<-function(maps){
  if(!is.list(maps)){
    stop("The input must be a list")
  }
  if(length(maps)==1){
    warning("This list has a single map. The master and map will be identical!")
  }
  
  ### check that input does not contain master, if it does: erase
  if(sum(grepl(x = names(maps),pattern = "^master$",ignore.case = TRUE))){
    maps<-maps[-grep(x=names(maps),
                     pattern="^master$",ignore.case = TRUE,perl = TRUE)]
  }
  max_col<-max(unlist(lapply(X = maps, FUN = ncol)))
  result<-maps
  master<-maps[[1]]
  if(ncol(master)<max_col){ ### Add empty columns
    master<-cbind(master,matrix("", ncol = max_col - ncol(master),
                                nrow = nrow(master))
    )
  }
  if(length(maps)>1){
    for(i in 2:length(maps)){
      if(ncol(maps[[i]]<max_col)){
        master<-rbind(master,
                      cbind(maps[[i]],
                            matrix("",ncol = max_col - ncol(maps[[i]]),
                                   nrow = nrow(maps[[i]])
                            )
                      )
        )
      }
      else{
        master<-rbind(master,
                      maps[[i]]
                      )
      }
    }
  }
  result$Master<-master
  return(result)
}