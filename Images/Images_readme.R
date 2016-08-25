# Generate images
q<-represent_enrichment(enrichment = list(SampleA = enrichment_test, 
                                          SampleB = enrichment_test[1:3,]), 
                        plot = "heatmap", scale = "log")
ggsave("Images/Heatmap.png")

q<-represent_enrichment(enrichment = enrichment_test,scale = "reverselog",
                                          sample_name = "test",plot = "bar")

ggsave("Images/barplot.png")