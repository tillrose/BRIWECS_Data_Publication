rm(list=ls())
pacman::p_load(dplyr,purrr,ggplot2,toolPhD)
data <- read.csv2("output/BRIWECS_data_publication.csv") %>% 
  mutate(across(BBCH59:Protein_yield,as.numeric)) %>% 
  tidyr::pivot_longer(BBCH59:Protein_yield,names_to = "trait",values_to = "Trait")
# -------------------------------------------------------------------------
data_list <- data %>% 
  group_by(Year) %>% 
  group_split() %>% 
  .[!map_lgl(.,~{all(is.na(.x$Trait))})] %>% 
  .[!map_lgl(.,~{length(which(!is.na(.x$Trait)))==1})] %>% 
  map(.,~{
    .x %>% 
      select(Year,Location,Treatment,Row,Column,trait) %>% 
      distinct()
  })

plot_fun<- function(i){
  df <- data_list[[i]]
  
  df%>%
    tidyr::separate(Treatment,c("nitrogen","fungicide","irrigation"),"_") %>% 
    suppressWarnings() %>% 
    ggplot(aes(Row,Column,color=nitrogen,shape=fungicide))+
    geom_point(size=.8)+
    scale_shape_manual(values=c(1,16))+
    theme_phd_talk(legend.position="bottom")+
    facet_grid(Year~Location+irrigation)+
    scale_x_continuous(limits=c(0,50))+
    scale_y_continuous(limits=c(0,200))
}
## Create the sliding window mean, do the graphes
pdf("figure/exp_design.pdf",onefile = T,width = 20,height=10)

for(i in 1:length(data_list)){
  plot_fun(i) %>% print()
}

dev.off()
