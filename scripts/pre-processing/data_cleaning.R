rm(list=ls())
#### setup ####
pacman::p_load(dplyr,purrr,readr,stringr)
source("scripts/pre-processing/functions.R")

##### import #####
complete_dat <- list.files(path = "data/locations",
                           pattern="*.csv",
                           full.names = T) %>%
  map_df(.,function(filename){
    if(grepl("RHH_2018",filename)){
      df <-read_csv(filename, col_types = cols(.default = "c"))
    }else{
      df <-read_csv2(filename, col_types = cols(.default = "c"))
    }
    
    if(grepl("GGE_2019",filename)){
      s1 <- xlsx::read.xlsx("data/patching_files/GG2019.xlsx", sheetIndex = 1) %>% distinct()
      s2 <- xlsx::read.xlsx("data/patching_files/GG2019.xlsx", sheetIndex = 2) %>% 
        tidyr::pivot_longer(starts_with("X"), names_to = "Column", values_to = "Name") %>% 
        mutate(Column=gsub("X", "", Column)) %>%
        right_join(.,s1 ) %>% 
        dplyr::select(Row,Column,BRISONr,Replication,Treatment,Seedyield.dt.ha.100.) %>%
        rename(SeedyieldM=Seedyield.dt.ha.100.) %>%
        mutate(Treatment=case_when(Treatment==1~"LN_NF",
                                   Treatment==2~"LN_WF",
                                   Treatment==3 ~ "HN_NF",
                                   Treatment==4 ~"HN_WF",
                                   T~"HN_WF_DD"),
               SeedyieldM=round(as.numeric(SeedyieldM),3),
               Block=paste0("B",Replication),
               across(c(Row,Column),as.character),
               BRISONr=paste0("BRISONr_",BRISONr)) %>% 
        dplyr::select(-Replication)
      
      df <- df %>% 
        mutate(SeedyieldM=round(as.numeric(Seedyield),3),
               Seedyield=case_when(Seedyield=='0'~NA,
                                   T~Seedyield)) %>% 
        left_join(.,s2) %>% relocate(Row,Column) %>%
        dplyr::select(-SeedyieldM)
      
    }else if(grepl("KAL_20(18|19|20)",filename)){
      
      KAL_table <- 
        data.frame(
          # genotype=
          #            c('RGT Reform','Benchmark','Barranco','Nordkap',
          #              'Porthus','Sheriff','Apostel'), 
          BRISONr=paste0('BRISONr_',c(222:228)),   
          bri2=paste0('BRISONr_',214:220))
      
      
      df <-  df %>% 
        left_join(.,KAL_table,"BRISONr") %>% 
        mutate(BRISONr=case_when(!is.na(bri2) ~ bri2,
                                 TRUE ~ BRISONr)) %>% 
        dplyr::select(-bri2)
      
    }else if(grepl("HAN_2018",filename)){
      double <- df%>%
        dplyr::select(Treatment:Column) %>%
        group_by_all() %>% 
        reframe(n=n()) %>% filter(n>1)
      
      mis <- df %>% filter(is.na(Column)|is.na(Row)) %>%
        dplyr::select(Treatment:Column) %>% bind_rows(.,double)
      
      han2 <- mis %>% select(-n) %>% 
        left_join(.,df) %>% 
        mutate(
          across(c(Row,Column),as.numeric),
          Row=case_when(BRISONr=="BRISONr_47"~Row+1,
                        BRISONr=="BRISONr_38"~Row-3,
                        T~Row),
          Column=case_when(
            BRISONr%in%paste0("BRISONr_",c(226,213,169,222))~Column+1,
            is.na(Column)~12, #102
            T~Column),
          across(c(Row,Column),as.character)
        )
      han_res <- df %>% anti_join(.,mis)
      df <- han2 %>% bind_rows(han_res)
    }else if(grepl("KIE_2017",filename)){
      # average double rows in KIE 2017-------------------------------------------------------------------------
      tmpr <-df %>% filter(!(BRISONr=="BRISONr_188"&Treatment=="LN_NF"&Block=="B2"))
      tmps <- df %>% filter((BRISONr=="BRISONr_188"&Treatment=="LN_NF"&Block=="B2")) %>% 
        mutate(Row=24) %>% 
        group_by_at(c("Row","Column","BRISONr","Year","Treatment","Block","Location")) %>% 
        mutate(across(Sowing_date:Subtrial,as.numeric)) %>% 
        reframe(across(where(is.numeric),~mean(.x,na.rm = T)))
      # remove KAL 2018-2020 problem data before raw data got updated. 
      df <- rbind(tmpr,tmps) %>% 
        mutate(
          across(c(Row,Column),as.character)
        )
    }else if(grepl("RHH_2016",filename)){
      
      rhh_patch <- xlsx::read.xlsx("data/patching_files/RHH2016.xlsx",
                                   sheetIndex = 1) %>% 
        tidyr::pivot_longer(starts_with("X"), names_to = "Column", 
                            values_to = "Name") %>% 
        rename(Row=row) %>% 
        mutate(Column=gsub("X", "", Column) %>% as.numeric(),
               newc=as.character(Column+30*(gcolumn-1)),
               # this part need to be corrected.
               Treatment=case_when(treatment==1~"LN_NF",
                                   treatment==2~"HN_NF",
                                   T~"HN_WF"
               ),
               Block=paste0("B",block),
               across(c(Row,Column),as.character),
               BRISONr=paste0("BRISONr_",Name)) %>% 
        filter(!is.na(Name)) %>% select(-c(treatment:block,gcolumn,Name))
      
      df <- rhh_patch %>% 
        right_join(.,df ) %>% 
        mutate(Column=newc) %>% dplyr::select(-newc)
    }else{
      df <- df
    }
    
    return(df)
  })%>% 
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
         
         Protein_yield=Seedyield*Crude_protein/100
  ) %>% 
  filter(Treatment != "LLN_WF_RF",
         !BRISONr%in%c("BRISONr_NA"),
         !is.na(BRISONr)) %>% 
  group_by(Treatment,Location,Year) %>% 
  mutate( 
    BRISONr=ifelse(BRISONr=="BRISONr_?","BRISONr_229",BRISONr),
    across(Stripe_rust:Fusarium,
           ~case_when(all(is.na(.))~., # if all is na, then keep na
                      # otherwise, replace NA or <0 with 0
                      T~ifelse(is.na(.)|.<0, 0, .)))) %>% 
  ungroup()

## Filter Harvest Index by Standard Deviation
complete_dat <- complete_dat %>% 
  group_by(Year, Location, Treatment, BRISONr) %>% 
  mutate(HI_sd = sd(Harvest_Index, na.rm = TRUE),
         HI_mean = mean(Harvest_Index, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(Harvest_Index = ifelse(Harvest_Index < HI_mean - 4*HI_sd, NA, Harvest_Index),
         Harvest_Index = ifelse(Harvest_Index > HI_mean + 4*HI_sd, NA, Harvest_Index),
         Biomass = Seedyield/Harvest_Index,
         Straw = Biomass*(1-Harvest_Index),
         # Straw =ifelse(Straw < 5, NA, Crude_protein)
  )

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

# remove KAL 2018-2020 problem data before raw data got updated. 
res <- export_dat %>%
  mutate(across(-c(BRISONr:Emergence_date,Seedyield),
                ~ case_when(Location == "KAL" & Year > 2017 ~ NA_real_,
                            T~.)))
# -------------------------------------------------------------------------
write_delim(export_dat, "output/BRIWECS_data_publication.csv", delim = ";")
