rm(list=ls())
pacman::p_load(dplyr,purrr,rlang)
mana_list<- 
  list.files("data/management",full.names = T)

# management -------------------------------------------------------------------------
condi1 <- list(quo(!Notice=='Notice'),quo(!is.na(Amount)))
condi2 <- list(quo(!`Plant protection`=='Plant protection'),quo(!Notice==0))
# condi3 <- list(quo(!Infection_data=='Infection_data'),quo(!is.na(Infection_data)))
condi_list <- list(condi1,condi2)

Management<- map(mana_list,~{
  locat_year <- strsplit(.x,"/") %>% 
    unlist() %>% .[3] %>%
    gsub("(Management_information_|.xlsx)","",.,perl = T)
  # print(.y)
  tmp<- xlsx::read.xlsx(.x,stringsAsFactors = F,sheetIndex = 1)
  # first find the row with Managements
  row_id <- grep("^Managements$",tmp[,1],ignore.case = F,perl =T)
  
  col_start<- grep(c('Treatment|Plant protection|Infection_data'),
                   tmp[min(row_id+1),])
  col_end <- c(col_start[2:3]-1,col_start[3]+1)
  new_colnam <- as.character(unlist(tmp[row_id+1,])) 
  new_colnam[grepl("Treatment",new_colnam)] <- "Treatment"
  new_colnam[grepl("Amount",new_colnam)] <- "Amount"
  
  map(1:length(condi_list),function(col_id){#fertilizer, plant-protection, disease 
    col_range <- seq(col_start[col_id],
                     col_end[col_id],1)
    if(col_id>1){# include treatment column for plant-protection and disease 
      col_range <- c(1,col_range)
    }
    
    tmp2 <- tmp[row_id+2:nrow(tmp),col_range]%>%
      `colnames<-`(new_colnam[col_range])%>% 
      mutate(Treatment=stringr::str_extract(Treatment,"\\((.*?)\\)") %>% 
               gsub("(\\(|\\))","",.) %>% 
               gsub("Trockenstress","D",.)
             
      ) %>% 
      # colnames(tmp2) <- new_colnam[col_range]
      # tmp2 <-  tmp2%>% 
      rename_with(~ "Date", matches("(?i)date")) %>% 
      filter(!!condi_list[[col_id]][[1]],!!condi_list[[col_id]][[2]]) 
    if(col_id<3){
      tmp2<-tmp2  %>% 
        mutate(Date=as.Date(as.numeric(Date),origin='1900-01-01')) %>% suppressWarnings()
    }else{
      tmp2<-tmp2  %>% 
        mutate(Date=case_when(stringr::str_detect(Date, "^\\d{5}$")~as.Date(as.numeric(Date),origin='1900-01-01') %>% as.character(),
                              T~Date              
        ))%>% suppressWarnings()
    }
    tmp2<-tmp2  %>% 
      mutate(Locat_Year=locat_year,
             across(.fns = ~ tidyr::replace_na(as.character(.x), ""))) %>% 
      tidyr::separate(Locat_Year,c("Location","Year"),sep="_")
    return(tmp2)
  })
})

source("scripts/pre-processing/functions.R")
nitrogen <- Management  %>% map_dfr(.,~{.x[[1]]}) %>%
  treatment_location_name_correction() %>% 
  filter(grepl("nitrogen",Fertilization)) %>% 
  mutate(unit='kg ha-1') 

plant <- Management  %>% map_dfr(.,~{.x[[2]]}) %>% 
  rename(Chemical=Notice)%>% treatment_location_name_correction()
# disease <- Management  %>% map_dfr(.,~{.x[[3]]})%>% rename(Note=Date)%>% treatment_location_name_correction()

xlsx::write.xlsx(nitrogen%>%
                   relocate(Location,Year,Treatment) %>%
                   relocate(Notice,.after = unit) %>% 
                   arrange(Location,Year,Treatment),
                 "metadata/fertilizer.xlsx",row.names = F)
xlsx::write.xlsx(plant%>% relocate(Location,Year,Treatment) %>%
                   arrange(Location,Year,Treatment),
                 "metadata/plant_protection.xlsx",row.names = F)
# xlsx::write.xlsx(disease %>% relocate(Location,Year,Treatment) %>%
#                    arrange(Location,Year,Treatment),
#                  "metadata/disease_record.xlsx",row.names = F)
# soil --------------------------------------------------------------------
tar.vec <- c("Type of soil",
             "Preceding crop",
             "Pre-Preceding crop",
             "Soil cultivation before preceding crop",
             "Catch crop (Zwischenfrucht)",
             "Clay",
             "Sand ",
             "Silt",
             "pH",
             "organical content",
             "P2O5",
             "K2O",
             "C/N ratio")

soildf<- map_dfr(mana_list,~{
  tmp<- xlsx::read.xlsx(.x,stringsAsFactors = F,sheetIndex = 1)
  names(tmp)[1:2] <-c("soil","type")
  tmp <- tmp %>%
    .[,1:2]%>%
    filter(soil%in%tar.vec) %>% 
    na.omit()
  res <- data.frame(tmp$type %>% t()) 
  names(res) <- tmp$soil
  fold <- strsplit(.x,"/") %>% unlist() %>% .[3] %>% 
    gsub("(Management_information_|.xlsx)","",.,perl = T)
  locat <-  strsplit(fold,"_") %>% unlist() %>% .[1]
  res%>%  
    mutate(Location= locat,
           Year=strsplit(fold,"_") %>% unlist() %>% .[2])
})
names(soildf)[1] <- "Typesoil"
names(soildf)[grepl('Sand',names(soildf))] <- 'Sand'
soilt<- xlsx::read.xlsx(file="data/soil_translate.xlsx",stringsAsFactors=F,sheetIndex = 1) 
names(soilt)[1] <- "Typesoil"
names(soildf) <- gsub("( |\\/|\\(|\\))",".",names(soildf)) %>% 
  gsub("Zwischen.*","",.)

soil_merge <- left_join(soildf,soilt,by="Typesoil") %>% 
  mutate(
    across(c(Clay:organical.content,Sand),function(x)gsub("(%|NA)","",x)),
    across(P2O5:K2O,function(x)gsub("(\\(|mg/100g|\\))","",x)),
    C.N.ratio=gsub("nicht.*","",C.N.ratio),
    organical.content=ifelse(grepl("0",organical.content),
                             as.numeric(organical.content)*100,
                             organical.content)
  ) %>% suppressWarnings() %>% 
  mutate(across(.fns = ~ tidyr::replace_na(as.character(.x), ""))) %>% 
  select(-`Catch.crop..`)

cid <- c(names(soil_merge)[grepl("(Year|Location|soiltype|pH)",names(soil_merge))],
         names(soil_merge)[grepl("(Clay|Silt|Sand)",names(soil_merge))],
         names(soil_merge)[grepl("(Water|Nutri|crop|organic)",names(soil_merge))])
soil_merge <- soil_merge[,cid]%>%
  relocate(Location,Year,soiltype,Clay,Silt,Sand) %>% 
  dplyr::select(-Soil.cultivation.before.preceding.crop)
# names(a)[grepl("(Clay|Silt|Sand|pH|Year|Location|soiltype|Water|Nutri|crop)",names(a))]
xlsx::write.xlsx(soil_merge,"metadata/soil.xlsx",row.names = F)