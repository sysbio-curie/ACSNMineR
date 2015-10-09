#!/bin/R
####### ACSN enrichment analysis

enrichment<-function(Genes=NULL,
                    maps = list(ACSN_apop_formatted,
                                ACSN_cellcyc_formatted,
                                ACSN_dnarep_formatted,
                                ACSN_emtmotil_formatted,
                                ACSN_master_formatted,
                                ACSN_survival_formatted), 
                    correction_multitest = FALSE,
                    statistical_test = "fisher",
                    min_module_size = 5,
                    universe = "HUGO"){
  if(universe == "HUGO"){
    ###Total size of approved symbols, from http://www.genenames.org/cgi-bin/statistics, as of October 8th 2015
    size = 39480
  }
  else if(universe == "ACSN"){
    genes<-character()
    for(lt in maps){
      ### extract modules of size >= module_size
      
      genes<-unique(lapply(X = maps, FUN = function(z){z[,-(1:2)]}))
      genes<-genes[genes != ""]
      size <- length(genes)
      print(size)
    }
    
  }
  else if(is.numeric(universe)){
    size = universe
  }
  else{
    stop("Invalid universe input: must be 'HUGO','ACSN', or numeric")
  }
  ### Checking that gene list is unique
  Genes<-unique(Genes)
  Genes_size<-length(Genes)  
  ### If ACSN universe, restrict Genes to the ones in ACSN?
  
  
  ### get from list how many are in each sub-compartment
  result<-data.frame()
  ### what would be the expected?
  for(map in maps){
    keep<-map[,2]>=min_module_size
    modules<-map[keep,1]
    if(statistical_test == "fisher"){
      p.values<-apply(map[keep,],margin = 1, FUN = function(z){
        short_z<-z[z!=""][-c(1,2)] ### remove empty slots, module name and length
        Genes_in_module<-length(Genes %in% short_z)
        fisher.test(x = matrix(c(Genes_in_module,
                                 z[2]-Genes_in_module,
                                 Genes_size - Genes_in_module,
                                 universe - z[2]
                                 nrow = 2)))$p.value
        
      })
      result<-rbind(result,cbind(modules,p.values))
    }
  }
  return(result)
}

represent_enrichment<-function(enrichment){
  
}

format_from_gmt<-function(path = ""){
  gmt<-read.csv(path,header = FALSE, sep = "\t")
  result<-t(apply(gmt,1,FUN = function(z){
          pos<-grep(pattern = "\\*",x = z)
          res<-z
          res[pos]<-""
          return(res)
          }))
  result[,2]<-apply(result[,-(1:2)], 1, FUN = function(z) sum(z!=""))
  return(result)
}
