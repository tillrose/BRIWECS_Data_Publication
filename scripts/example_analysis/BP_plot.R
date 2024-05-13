rm(list=ls())
pacman::p_load(dplyr,purrr,ggplot2)
level_order <- c('HN_WF_RF', 'HN_NF_RF', 'LN_NF_RF') 
traitlist <- c('Straw','Harvest_Index_bio','TKW',
               "Spike_number_bio",'KperSpike_bio',
               'Biomass','Seedyield','Kernel')

un <- xlsx::read.xlsx("metadata/Unit.xlsx",sheetIndex = 1) %>% 
  mutate(unit=gsub('\\#','Nbr ',unit),
         unit=gsub('\\*',' x ',unit),
         unit=ifelse(is.na(unit),' ',unit)) %>% 
  rename(Parameter=trait)

blue <- readRDS("output/BLUE.RDS") %>%
  dplyr::filter(Treatment%in%level_order,
                !Location%in%c("DKI",'RHH'),
                Year<2018)
m.gen <- 
  map_dfr(c('Seedyield','Straw','Harvest_Index_bio','Biomass',
            'TKW','Kernel','KperSpike_bio',"Spike_number_bio") ,function(tr){
              
              blue %>% 
                dplyr::filter(
                  trait==tr) %>% 
                group_by_at(c("Treatment","Location","Year","trait")) %>% 
                summarise(BRISONr=length(unique(BRISONr)),.groups="drop") 
            })
env_trait<-  m.gen %>%
  group_by(Location,Treatment,trait) %>%
  summarise(n=n()) %>% ungroup() %>% 
  filter(n==3) %>% dplyr::select(-n)%>% rename(Parameter=trait)
s_window_statistic <- read.csv("output/Slidingwindow_BLUES_statistics.csv") %>% 
  mutate(across(Ab_BP:Ab_BP,as.numeric),
         Treatment=Environment %>% strsplit(.,"/") %>% 
           map_chr(.,~{.x[3]}) %>% as.factor(),
         Year=Environment %>% strsplit(.,"/") %>% 
           map_chr(.,~{.x[1]}),
         Location=Environment %>% strsplit(.,"/") %>% 
           map_chr(.,~{.x[2]}),
         Treatment_Location=paste(Treatment, Location, sep="-"),
         Treatment_Year=paste(Treatment, Year, sep="-")
  ) %>% 
  left_join(.,un) %>% 
  
  left_join(env_trait,.) %>% 
  filter(!is.na(Ab_BP)) %>% 
  group_by(Parameter) %>%
  mutate(m=mean(Ab_BP))
# -------------------------------------------------------------------------

orderid<- s_window_statistic %>% dplyr::select(abbrev,m) %>%
  distinct() %>% arrange(-m) %>% .$abbrev
sdf <- s_window_statistic %>% 
  arrange(m) %>% 
  mutate(
    M=max(Ab_BP) %>%toolPhD::round_scale() %>% as.numeric(),
    r1=paste0(
      "M:",M ,"\n",
      "A:",mean(Ab_BP)%>% toolPhD::round_scale(),"\n",
      "m:",min(Ab_BP) %>% toolPhD::round_scale()),
    abbrev=factor(abbrev,levels=orderid),
    unit=case_when(unit==" "~unit,
                   grepl("/",unit)~ paste0("(",unit," year",")"),
                   T~ paste0("(",unit," /year",")"))
    ) 
# levels(sdf$abbrev)
sdf$unit %>% unique()
p <- sdf%>% 
  ggplot(aes(abbrev,Ab_BP,group=abbrev))+
  ggplot2::scale_fill_viridis_d(option = "D") + 
  ggplot2::geom_violin(alpha = 0.5, 
                       position = position_dodge(width = 1), 
                       linewidth = .5) + 
  ggbeeswarm::geom_quasirandom(size = 3, shape=1,aes(
    color=p),
    dodge.width = 1) + 
  ggplot2::geom_boxplot(outlier.size = -1,  
                        position = position_dodge(width = 1), 
                        lwd = .6, color="darkorange",
                        width = 0.3, alpha = 0.05, show.legend = F) +
  toolPhD::theme_phd_facet(t=10,b=30) + 
  ggplot2::theme(panel.grid.major.x = element_blank(), 
                 legend.position = c(.8,.2),
                 axis.title.x = element_blank(),
                 axis.title.y = element_blank(),
                 axis.text.x=element_blank())+
  scale_y_continuous(scales::cut_short_scale())+
  geom_hline(yintercept=0,linetype=3,linewidth=1,color="darkgray")+
  facet_wrap(~abbrev+unit,
             scales = "free",
             # strip.position="left",
             dir="h",
             labeller = stickylabeller::label_glue('({.L}) {abbrev}\n{unit}'),
            
  )
png(filename="figure/BP_range.png",
    type="cairo",
    units="cm",
    width=18,
    height=18,
    pointsize=5,
    res=650,# dpi,
    family="Arial")
p
dev.off()
