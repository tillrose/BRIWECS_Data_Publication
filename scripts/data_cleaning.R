rm(list=ls())
#### setup ####
library("tidyverse")
##### import #####
complete_dat <- list.files(path = "data/locations",
                           pattern="*.csv",
                           full.names = T) %>%
  map_df(~read_csv2(., col_types = cols(.default = "c")))%>% 
  # for consistency of location and treatment naming rules
  mutate(
    Treatment = stringr::str_replace_all(Treatment, "(D{1,2})", "IR"),# irrigation
    Treatment=case_when(Location=="DKI"~paste0(Treatment,"_RO"),# rain out shelter
                        T~Treatment),
    Location=gsub("DKI","KIE",Location)
  )
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
         Powdery_mildew = as.integer(Powdery_mildew),
         Leaf_rust = as.integer(Leaf_rust),
         Leaf_rust = ifelse(Leaf_rust < 0, NA, Leaf_rust),
         Septoria = as.integer(Septoria),
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
         Kernel= Seedyield*1000/TKW,# set yield back to grain and divide by tkw
         Biomass = Seedyield/Harvest_Index,
         Straw = Biomass*(1-Harvest_Index),
         Protein_yield=Seedyield*Crude_protein/100
         ) %>% 
  filter(Treatment != "LLN_WF")

## Filter Harvest Index by Standard Deviation
complete_dat <- complete_dat %>% 
  group_by(Year, Location, Treatment, BRISONr) %>% 
  mutate(HI_sd = sd(Harvest_Index, na.rm = TRUE),
         HI_mean = mean(Harvest_Index, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(Harvest_Index = ifelse(Harvest_Index < HI_mean - 2*HI_sd, NA, Harvest_Index),
         Harvest_Index = ifelse(Harvest_Index > HI_mean + 2*HI_sd, NA, Harvest_Index))


## Filter Spike Number by Standard Deviation
complete_dat <- complete_dat %>% 
  group_by(Year, Location, Treatment, BRISONr) %>% 
  mutate(Spike_number_sd = sd(Spike_number, na.rm = TRUE),
         Spike_number_mean = mean(Spike_number, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(Spike_number = ifelse(Spike_number < Spike_number_mean - 2*Spike_number_sd, NA, Spike_number),
         Spike_number = ifelse(Spike_number > Spike_number_mean + 2*Spike_number_sd, NA, Spike_number))

complete_dat <- complete_dat %>% 
  mutate_all(~ifelse(is.nan(.), NA, .))

##### export #####
export_dat <- complete_dat %>% 
  dplyr::select(BRISONr, Treatment, Block, Row, Column, Year, Location, Sowing_date,
                Emergence_date, BBCH59, BBCH87, Plantheight, Seedyield, Seedyield_bio,
                Biomass_bio, Harvest_Index, TKW_plot, TKW_bio, Spike_number, Stripe_rust,
                Powdery_mildew, Leaf_rust, Septoria, DTR, Fusarium, Falling_number, Crude_protein, Sedimentation,
                # !!! new added
                KperSpike,Kernel,Biomass,Straw,Protein_yield
                ) %>% 
  mutate(across(BBCH59:Protein_yield,as.numeric)) 
# ------------------------------------------------------------------------
write_delim(export_dat, "output/BRIWECS_data_publication.csv", delim = ";")
