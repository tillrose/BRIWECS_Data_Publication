rm(list=ls())
pacman::p_load(purrr,dplyr,toolPhD,ggplot2)
raw <- read.csv2("output/BRIWECS_data_publication.csv")

# preprocessing -------------------------------------------------------------------------
long <- raw %>%
  mutate(across(BBCH59:Sedimentation,as.numeric)) %>% 
  tidyr::pivot_longer(BBCH59:Sedimentation,
                      names_to="trait",values_to = "Trait") %>% 
  filter(!is.na(Trait)) 

with(long,Trait[grepl("a-z",Trait)])
tiff(filename="figure/data_number.tiff",
     type="cairo",
     units="cm",
     compression = "lzw",
     width=10,
     height=8,
     pointsize=6,
     res=600,# dpi,
     family="Arial")
long %>% 
  group_by(trait) %>% summarise(n=n()) %>% 
  mutate(trait = forcats::fct_reorder(trait, n)) %>%
  ggplot( aes(x=trait, y=n)) +
  geom_segment( aes(xend=trait, yend=0)) +
  geom_point( size=4, color="orange") +
  coord_flip() +
  theme_bw() +
  xlab("")+ylab("Number of observations")+
  geom_text(aes(y=n+2000, label=n),size=3)+
  toolPhD::theme_phd_facet()
dev.off()


tiff(filename="figure/data_point.tiff",
     type="cairo",
     units="cm",
     compression = "lzw",
     width=30,
     height=15,
     pointsize=6,
     res=600,# dpi,
     family="Arial")
long %>%
  arrange(Location,desc(Year),Treatment)%>%
  mutate(BRISONr=gsub("BRISONr_","",BRISONr) %>% as.numeric,
         Env=interaction(Location,Year,Treatment) %>% factor(.,levels=unique(.)) ,
         trait=gsub("\\_","\n",trait)
  )%>%   
  ggplot( aes(x=BRISONr, y=Env)) +
  geom_point(size=0.05,shape=1,stroke=.3)+
  ggh4x::facet_nested(~trait,
                      # nrow = 1,
                      nest_line = element_line(colour = "black"),
                      space = 'free',
                      scale="free_x")+
  theme_test()+
  theme(axis.text.y= element_text(size=4),
        axis.text.x= element_text(size=6,angle = 90,hjust=1),
        strip.text = element_text(size=5),
        strip.background = element_blank())+
  ylab("combination of ExM")+
  xlab("genotype identifier")
dev.off()

# get some number for summary statistics -------------------------------------------------------------------------
# how many traits in total 
long%>% 
  nrow()
# how many unique environments combination 
long %>% 
  select(Treatment,Year,Location) %>% view_df()

long %>% 
  toolPhD::df_ue(coln=c(Treatment,Year,Location))

long %>% 
  toolPhD::df_ue(coln=c(trait))
