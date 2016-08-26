#Plots

#### Graphic representation of results ####
#' Graphic representation of enrichment
#'@param enrichment Data frame or list of dataframes with p-values or corrected p-values (whenever available) 
#'and module names for representation.
#'The name of the dataframe will be used as sample name.
#'@param plot Any of "heatmap" or "bar"
#'@param scale Any of "log", "identity" or "reverselog" (i.e. -log10(p-value))
#'@param low Color to be used in heatmap mode corresponding to lowest value
#'@param high Color to be used in heatmap mode corresponding to highest value
#'@param nrow Number of rows of the grid for display in bar mode.
#'@param sample_name  used only is enrichment is a dataframe
#'@param na.value color for the missing values in the heatmap
#'@examples 
#'represent_enrichment(enrichment = enrichment_test,scale = "reverselog",
#'                     sample_name = "test",plot = "bar")
#'
#'represent_enrichment(enrichment = list(SampleA = enrichment_test, 
#'                                      SampleB = enrichment_test[1:3,]), 
#'                      plot = "heatmap", scale = "log")
#'@return Function returns a ggplot2 object if input is a dataframe or a gridExtra object if the output is a list. 
#'@import ggplot2 
#'@importFrom gridExtra grid.arrange
#'@export
represent_enrichment<-function(enrichment, plot = "heatmap" , scale = "log", 
                               low = "steelblue" , high ="white",
                               nrow = 1,sample_name = "Sample",
                               na.value = "grey"){
  
  
  if(is.data.frame(enrichment)){
    if("p.value.corrected" %in% colnames(enrichment)){
      enrichment$p.values<-enrichment$p.value.corrected
    }
    else if("p.value" %in% colnames(enrichment)){
      enrichment$p.values<-enrichment$p.value
    }
    else{
      warning("dataframe has no column 'p.value' or 'p.value.corrected'. Exiting!")
      return(NA)
    }
    enrichment$sample_name<-sample_name 
    enrichment$p.values<-cnum(enrichment$p.values)
    if(plot == "heatmap"){
      
      q<-ggplot2::ggplot(enrichment,
                         ggplot2::aes_string(x= "sample_name",
                                             y = "module", 
                                             fill = "p.values"))+ggplot2::xlab("")+ ggplot2::ylab("Modules") + ggplot2::geom_tile()
      if(scale == "log"){
        q<- q + ggplot2::scale_fill_gradient("p-values",low = low , high = high, na.value = na.value, trans = "log10")
      }
      else if(scale == "reverselog"){
        q<- q + ggplot2::scale_fill_gradient("p-values",low = high , 
                                             high = low, na.value = na.value, 
                                             trans = reverselog_trans())
      }
      
      else{
        q<-q+ ggplot2::scale_fill_gradient("p-values",low = low , high = high, na.value = na.value)
      }
      
    }
    else{
      q<-ggplot2::ggplot(data= enrichment,
                         aes_string(x= "module",
                                    y= "p.values"),
                         xlab = "Modules", ylab = "p-values")
      if(scale == "log"){
        q<- q + ggplot2::scale_y_continuous(trans = "log10")
      }
      else if(scale == "reverselog"){
        q<- q + ggplot2::scale_y_continuous(trans = reverselog_trans())
      }
      q<-q+ggplot2::theme_minimal()+ggplot2::theme(axis.text.x = element_text(angle = 90, hjust = 0), axis.ticks = ggplot2::element_blank())
      q<-q+ggplot2::geom_bar(stat = "identity")
    }    
  }
  else if(is.list(enrichment)){
    sample_names<-names(enrichment)
    if(is.null(sample_names)){
      warning("Your list has no names... Will use numbers instead")
      sample_names<-1:length(enrichment)
    }
    if(plot == "heatmap"){
      dataset<-data.frame()
      
      ### check if there is a need to add NAs for modules which are not present in all datasets
      all_equal<-TRUE
      modules<-as.character(enrichment[[1]]$module)
      for(sample in enrichment){
        if(!setequal(modules,as.character(sample$module))){
          all_equal<-FALSE
          modules<-unique(c(modules,as.character(sample$module)))
        }
      }
      tracker<-0
      if(all_equal){
        
        for(sample in enrichment){ ### Modules are present in all samples
          tracker<-tracker+1
          if("p.value.corrected" %in% colnames(sample)){
            dataset<-rbind(dataset, cbind(modules,sample_names[tracker],cnum(sample$p.value.corrected)))
          }
          else if("p.value" %in% colnames(sample)){
            dataset<-rbind(dataset, cbind(modules,sample_names[tracker],cnum(sample$p.value)))
          }
          else{
            warning(paste("Element", sample_names[tracker],"has no p.value column"))
            return(NA)
          }
        }
        colnames(dataset)<-c("module","sample_name","p.values")
      }
      else{ ###need to fill with NAs
        ### Not functional yet
        
        for(sample in enrichment){
          tracker<-tracker + 1
          
          test<-modules %in% as.character(sample$module)
          restricted_modules<-as.character(modules[test])
          position_modules<-as.numeric(sapply(X = restricted_modules,FUN = function(z){
            which(sample$module ==z)
          }))
          
          if(sum(!test)>0){ ### complement only when necessary
            complement<-as.character(modules[!test])
            if("p.value.corrected" %in% colnames(sample)){ ### 
              
              spare_dataset<-rbind(cbind(module = restricted_modules, sample_name = sample_names[tracker], 
                                         p.values = cnum(sample$p.value.corrected[position_modules])),
                                   cbind(module = complement, 
                                         sample_name = sample_names[tracker],
                                         p.values = NA))
              
            }
            else if("p.value" %in% colnames(sample)){ ### 
              spare_dataset<-rbind(cbind(restricted_modules, sample_names[tracker], cnum(sample$p.value[position_modules])),
                                   cbind(complement, sample_names[tracker],NA))
              
            } else{
              warning(paste("Element", sample_names[tracker],"has no p.value column"))
              return(NA)
            }
            colnames(spare_dataset)<-c("module","sample_name","p.values")
            dataset<-rbind(dataset, spare_dataset)
          }
          else{ ### rbind dataframe with values
            if("p.value.corrected" %in% colnames(sample)){ ### 
              
              spare_dataset<-cbind(module = restricted_modules, sample_name = sample_names[tracker], 
                                   p.values = cnum(sample$p.value.corrected[position_modules]))
              
            }
            else if("p.value" %in% colnames(sample)){ ### 
              spare_dataset<-cbind(restricted_modules, sample_names[tracker], cnum(sample$p.value[position_modules]))
            } else{
              warning(paste("Element", sample_names[tracker],"has no p.value column"))
              return(NA)
            }
            colnames(spare_dataset)<-c("module","sample_name","p.values")
            dataset<-rbind(dataset, spare_dataset)
            
          }
        }
      }
      dataset$p.values<-cnum(dataset$p.values)
      ### Plot heatmap
      q<-ggplot2::ggplot(dataset,
                         aes_string(x= "sample_name",
                                    y = "module", 
                                    fill = "p.values"))+ggplot2::xlab("")+ ggplot2::ylab("Modules") + ggplot2::geom_tile()
      if(scale == "log"){
        q<- q + ggplot2::scale_fill_gradient("p-values",low = low , high = high, na.value = na.value, trans = "log10")
      }
      else if(scale == "reverselog"){
        q<- q + ggplot2::scale_fill_gradient("p-values",low = high , high = low, na.value = na.value , trans = reverselog_trans())
        
        
      }     
      else{
        q<-q+ ggplot2::scale_fill_gradient("p-values",low = low , high = high, na.value = na.value)
      }
      q<-q+ggplot2::theme_minimal()+ggplot2::theme(axis.text.x = element_text(angle = 90, hjust = 0), axis.ticks = ggplot2::element_blank())
    }
    else{ ### barplot with grid
      names_sample<-names(enrichment)
      plot<-list()
      for(s in 1:length(enrichment)){
        plot[[s]]<-represent_enrichment(enrichment[[s]], plot = "bar" , 
                                        scale = scale, 
                                        sample_name = names_sample[s])
        
      }
      #       if(length(plot)%%nrow ==0){
      #         ncol <- length(enrichment)/nrow
      #       }
      #       else{
      #         ncol <- floor(length(enrichment)/nrow)+1
      #       }
      return(do.call(gridExtra::grid.arrange, c(plot, nrow=nrow)))
    }
    
  }
  else{
    warning("Wrong input format for enrichment!")
    return(NA)
    
  }
  return(q)
  
}

#' Scale for barplots and heatmaps
#' 
#' Outputs the "-log" of a scale
#' @param base : base for the log, defaut is 10
#' @importFrom scales trans_new log_breaks
#' 
reverselog_trans<-function(base = 10){
  trans<-function(x) -log(x,base)
  inv<-function(x) base^(-x)
  
  scales::trans_new(name = "reverselog",transform = trans,inverse = inv,
                    breaks = scales::log_breaks(base = base),
                    domain = c(10^(-60),Inf)
  )
  
}