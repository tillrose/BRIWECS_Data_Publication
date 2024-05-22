rm(list=ls())
#### setup ####
pacman::p_load(dplyr,purrr,readr,stringr)
source("scripts/pre-processing/functions.R")

##### import #####
complete_dat <- list.files(path = "data/locations",
                           pattern="*.csv",
                           full.names = T) %>%
  map_df(~read_csv2(., col_types = cols(.default = "c")))%>% 
  suppressMessages() %>% 
  # for consistency of location and treatment naming rules
  treatment_location_name_correction()
##### tidy and filter #####
complete_dat <- complete_dat %>% 
  dplyr::select(-ReifeHoehe,-Kernel_number_bio , -Sorte, -`StrawYield_dt/ha`, -Subblock, -Subtrial) %>% 
  mutate(Row = as.integer(Row),
         Column = as.integer(Column),
         BRISONr = str_replace(BRISONr, "BRISONR", "BRISONr"),
         Year = as.integer(Year),
         Location = ifelse(Location == "KAD", "KAL", Location),
         Block = ifelse(Block == "1", "B1", Block),
         Block = ifelse(Block == "2", "B2", Block),
         Sowing_date = as.integer(Sowing_date),
         Emergence_date = as.integer(Emergence_date),
         BBCH59 = as.integer(BBCH59),
         BBCH87 = as.integer(BBCH87),
         Plantheight = as.integer(Plantheight),
         Plantheight = ifelse(Plantheight > 150, NA, Plantheight),
         Seedyield = signif(as.double(Seedyield), digits = 4),
         Seedyield = ifelse(Seedyield < 0, NA, Seedyield),
         Seedyield_bio = signif(as.double(Seedyield_bio), digits = 4),
         Seedyield_bio = ifelse(Seedyield_bio > 2000, NA, Seedyield_bio),
         Seedyield = ifelse(Seedyield > 3000, NA, Seedyield),
         Biomass_bio = signif(as.double(Biomass_bio), digits = 4),
         Biomass_bio = ifelse(Biomass_bio > 3500, NA, Biomass_bio),
         TKW_plot = signif(as.double(TKW_plot), digits = 3),
         TKW_plot = ifelse(TKW_plot > 80, NA, TKW_plot),
         TKW_bio = signif(as.double(TKW_bio), digits = 3),
         Spike_number = signif(as.double(Spike_number), digits = 3),
         Spike_number = ifelse(Spike_number > 1500, NA, Spike_number),
         Stripe_rust = as.integer(Stripe_rust),
         Powdery_mildew = as.integer(Powdery_mildew) %>% suppressWarnings(),
         Leaf_rust = as.integer(Leaf_rust),
         Leaf_rust = ifelse(Leaf_rust < 0, NA, Leaf_rust),
         Septoria = as.integer(Septoria)%>% suppressWarnings(),
         DTR = as.integer(DTR),
         Fusarium = as.integer(Fusarium),
         Sedimentation = signif(as.double(Sedimentation), digits = 3),
         Falling_number = signif(as.double(Falling_number), digits = 3),
         Crude_protein = signif(as.double(Crude_protein), digits = 3),
         Crude_protein = ifelse(Crude_protein < 5, NA, Crude_protein),
         Harvest_Index = signif(as.double(Harvest_Index), digits = 3),
         Harvest_Index = ifelse(is.na(Harvest_Index), Seedyield_bio / Biomass_bio, Harvest_Index),
         Harvest_Index = ifelse(Harvest_Index > 0.8, NA, Harvest_Index),
         Harvest_Index = ifelse(Harvest_Index < 0.1, NA, Harvest_Index),
         # !!! new added derived traits
         KperSpike=case_when(is.na(TKW_bio)~ 1000*Seedyield_bio/(TKW_plot*Spike_number),
                             T~ 1000*Seedyield_bio/(TKW_bio*Spike_number)),
         TKW = ifelse(is.na(TKW_plot), TKW_bio, TKW_plot), 
         Grain= Seedyield*1000/TKW,# set yield back to grain and divide by tkw
         Biomass = Seedyield/Harvest_Index,
         Straw = Biomass*(1-Harvest_Index),
         Protein_yield=Seedyield*Crude_protein/100
  ) %>% 
  filter(Treatment != "LLN_WF_RF",
         !BRISONr%in%c("BRISONr_?","BRISONr_NA"))

## Filter Harvest Index by Standard Deviation
complete_dat <- complete_dat %>% 
  group_by(Year, Location, Treatment, BRISONr) %>% 
  mutate(HI_sd = sd(Harvest_Index, na.rm = TRUE),
         HI_mean = mean(Harvest_Index, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(Harvest_Index = ifelse(Harvest_Index < HI_mean - 4*HI_sd, NA, Harvest_Index),
         Harvest_Index = ifelse(Harvest_Index > HI_mean + 4*HI_sd, NA, Harvest_Index))


## Filter Spike Number by Standard Deviation
complete_dat <- complete_dat %>% 
  group_by(Year, Location, Treatment, BRISONr) %>% 
  mutate(Spike_number_sd = sd(Spike_number, na.rm = TRUE),
         Spike_number_mean = mean(Spike_number, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(Spike_number = ifelse(Spike_number < Spike_number_mean - 4*Spike_number_sd, NA, Spike_number),
         Spike_number = ifelse(Spike_number > Spike_number_mean + 4*Spike_number_sd, NA, Spike_number))

complete_dat <- complete_dat %>% 
  mutate_all(~ifelse(is.nan(.), NA, .))

##### export #####
export_dat <- complete_dat %>% 
  dplyr::select(BRISONr, Treatment, Block, Row, Column, Year, Location, Sowing_date,
                Emergence_date, BBCH59, BBCH87, Plantheight, Seedyield, Seedyield_bio,
                Biomass_bio, Harvest_Index, TKW_plot, TKW_bio, Spike_number, Stripe_rust,
                Powdery_mildew, Leaf_rust, Septoria, DTR, Fusarium, Falling_number, Crude_protein, Sedimentation,
                # !!! new added
                KperSpike,Grain,Biomass,Straw,Protein_yield
  ) %>% rename(Grain_per_spike=KperSpike,TGW_plot=TKW_plot,TGW_bio=TKW_bio) %>% 
  mutate(across(BBCH59:Protein_yield,as.numeric)) 
# consistent colnames ------------------------------------------------------------------------
# unit <- xlsx::read.xlsx("metadata/Unit.xlsx",sheetIndex = 1) %>%
#   mutate(
#     trait_old=trait,
#     trait=case_when(!grepl("bio",trait_old,perl=T)&
#                       sample.source=="biomass 50 cm cut"~paste0(trait_old,"_bio"),
#                     T~trait_old) %>%
#       gsub("_plot","",.))
# xlsx::write.xlsx(unit,"metadata/Unit.xlsx",row.names = F)

col_rename <- xlsx::read.xlsx("metadata/Unit.xlsx",sheetIndex = 1) %>%
  select(trait,trait_old) %>% 
  filter(!trait==trait_old,
         !trait_old=="Kernel_number_bio")
# names(raw)
names(export_dat)[match(col_rename$trait_old,names(export_dat))] <- col_rename$trait

# average double rows in KIE 2017-------------------------------------------------------------------------
tmpr <-export_dat %>% filter(!(BRISONr=="BRISONr_188"&Location=="KIE"&Year==2017&Treatment=="LN_NF_RF"&Block=="B2"))
tmps <- export_dat %>% filter((BRISONr=="BRISONr_188"&Location=="KIE"&Year==2017&Treatment=="LN_NF_RF"&Block=="B2")) %>% 
  mutate(Row=24) %>% 
  group_by_at(c("Row","Column","BRISONr","Year","Treatment","Block","Location")) %>% 
  summarise_all(mean)
res <- rbind(tmpr,tmps)
# -------------------------------------------------------------------------
write_delim(res, "output/BRIWECS_data_publication.csv", delim = ";")
# -------------------------------------------------------------------------
# a <- read.csv("data/cultivar_info.csv") %>% arrange(id)
# a1 <- read.csv("metadata/BRIWECS_BRISONr_information.csv")
# 
# setdiff(a$genotype%>% unlist(),
#         a1$genotype%>% unlist()) %>% sort()
# setdiff(a1$genotype%>% unlist(),
#         a$genotype%>% unlist()) %>% sort()
# 
# setdiff(a$kai,a1$breeding_progress_subset)
