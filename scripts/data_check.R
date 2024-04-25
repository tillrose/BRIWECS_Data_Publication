rm(list=ls())
pacman::p_load(purrr,dplyr,toolPhD,ggplot2,scales)
raw <- read.csv2("output/BRIWECS_data_publication.csv")

# preprocessing -------------------------------------------------------------------------
long <- raw %>%
  mutate(across(BBCH59:Protein_yield,as.numeric)) %>% 
  tidyr::pivot_longer(BBCH59:Protein_yield,
                      names_to="trait",values_to = "Trait") %>% 
  filter(!is.na(Trait)) 

# with(long,Trait[grepl("a-z",Trait)])

# data range -------------------------------------------------------------------------
illu <- raw %>% 

  mutate(Environment = paste(Location, Year, sep = "_"),
         Treatment = forcats::fct_relevel(Treatment, "HN_WF", "HN_WF_D", "HN_NF", "LN_WF", "LN_NF"),
         Environment = forcats::fct_expand(Environment, "RHH_2018", "RHH_2019"),
         Environment = forcats::fct_expand(Environment, "GGE_2019", after = 4)) %>% 
  select(Environment,Treatment,Seedyield,Harvest_Index,)

# plot_ <- 
plot_ls <- map(c("Seedyield",
                 "",
                 "",
                 ""),
               function(trait){
  ggplot(illu) +
    aes(x = Seedyield, 
        y = Environment, fill = Treatment) +
    theme_classic() +
    theme(legend.justification = "top") +
    ggridges::geom_density_ridges(alpha = 0.75,
                                  jittered_points = TRUE,
                                  position = "raincloud",
                                  point_size = 0.05,
                                  point_alpha = 0.2) +
    scale_fill_brewer(palette = "Set1") +
    scale_y_discrete(drop=FALSE) 
})


# number of observation -------------------------------------------------------------------------
png(filename="figure/data_number.png",
    type="cairo",
    units="cm",
    # compression = "lzw",
    width=16,
    height=14,
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
  ggtitle(sprintf("total number of observation: %s",nrow(long)))+
  xlab("")+ylab("Number of observations")+
  ggrepel::geom_text_repel(aes(label=n),
                           size=2.7,
                           hjust=0,
                           point.padding = 1,
                           segment.linetype = 5,
                           nudge_y=.1,
                           direction="y"
  )+
  scale_y_log10(
    labels =label_number(scale_cut = cut_short_scale()),
    expand = expansion(mult = 0.5)
  )+
  toolPhD::theme_phd_facet(b=10,r=10,plot.title = element_text(size=10))
dev.off()
# all data points -------------------------------------------------------------------------

png(filename="figure/data_point.png",
     type="cairo",
     units="cm",
     # compression = "lzw",
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
  geom_point(size=0.05,shape=1,stroke=.3,color="orange")+
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
  xlab("genotype identifier (G)")
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
