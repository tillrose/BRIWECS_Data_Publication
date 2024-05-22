rm(list=ls())
pacman::p_load(dplyr,purrr,foreach,ggplot2,doParallel,toolPhD,ggpmisc)
source("scripts/fun/Cor_fun.R")
# -------------------------------------------------------------------------
tr.vec    <- c('Seedyield','Straw','Harvest_Index_bio','Biomass','TGW','Grain',
               "Spike_number_bio",'Grain_per_spike_bio',"BBCH59","BBCH87")
BLU       <- readRDS("output/BLUE.RDS") %>% rename(Trait=emmean)
fraw_data <- read.csv2("output/BRIWECS_data_publication.csv") %>% 
  mutate(across(BBCH59:Protein_yield,as.numeric)) %>% 
  tidyr::pivot_longer(BBCH59:Protein_yield,
                      names_to = "trait",values_to = "Trait") %>% 
  group_by(BRISONr,Year,Location,Treatment,trait) %>% 
  summarise(Trait=mean(Trait,na.rm = T)) %>% ungroup() 

dat.ls <- list(BLU,fraw_data)
names(dat.ls) <- c("BLUEs","Trait")

m.gen <- 
  map_dfr(tr.vec ,function(tr){
    imap_dfr(dat.ls[1],function(dt,dn){
      # imap_dfr(rm.loca.ls,function(lv,ln){
      dt %>% 
        dplyr::filter(
          trait==tr,
          Treatment%in% c('HN_WF_RF', 'HN_NF_RF', 'LN_NF_RF') ,
          Year<2018
        ) %>% 
        group_by_at(c("Treatment","Location","Year","trait")) %>% 
        summarise(BRISONr=length(unique(BRISONr)),.groups="drop") %>% 
        mutate(
          data=dn)
      # })
    })
  })
df <- m.gen%>% 
  mutate(BRISONr=gsub("Levels number:","",BRISONr),
         BRISONr= case_when(BRISONr=="220"~".",
                            # is.na(BRISONr)~"XX",
                            T~BRISONr))
trait_env_list <- m.gen %>%
  filter(!Location=="RHH") %>% 
  group_by(Location,Treatment,trait) %>%
  summarise(n=n()) %>% ungroup() %>% 
  filter(n==3) %>% select(-n)
saveRDS(trait_env_list,"output/trait_env_list.RDS",compress = T)
# -------------------------------------------------------------------------
subdata <-  readRDS("output/BLUE.RDS")%>%
  dplyr::filter(
    trait%in%c('Seedyield','Straw','Harvest_Index_bio',
               'Biomass','TKW','Grain',
               "Spike_number_bio",'Grain_per_spike_bio'),
    Treatment%in% c('HN_WF_RF', 'HN_NF_RF', 'LN_NF_RF') )

big.gen <- subdata %>% 
  dplyr::filter(
    !Location%in%c("RHH","KAL"),
    Year<2018
  ) %>% 
  select(-(SE:asymp.UCL)) %>% 
  tidyr::pivot_wider(.,names_from = trait,values_from = emmean) %>%
  na.omit() %>% 
  group_by_at(c("Treatment","Location","Year")) %>% group_split() %>%
  map(.,~{.x$BRISONr}) %>% Reduce("intersect",.)

length(big.gen)

year4 <-
  subdata%>%
  filter(Year<2019,
         Location%in%c("KIE","HAN","GGE")) %>%
  common_group(.,c("Treatment","Location","Year","trait"),"BRISONr")
length(year4)

year5<- subdata%>%
  filter(Location%in%c("HAN","KIE")) %>% 
  common_group(.,c("Treatment","Location","Year","trait"),"BRISONr")
length(year5)
small.gen <- intersect(big.gen,year5)
# identical(intersect(small.gen,year4),small.gen)
saveRDS(list(big=big.gen,small=small.gen),"data/gen_list.RDS")