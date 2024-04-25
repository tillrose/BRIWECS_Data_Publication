rm(list=ls())
mana_list<- 
  list.files("data/management",full.names = T)

# management -------------------------------------------------------------------------
condi1 <- rlang::quo(!(Notice=='Notice')&!is.na(Notice))
condi2 <- rlang::quo(!'Plant protection'=='Plant protection'|!Notice==0)
condi3 <- rlang::quo(!Infection_data=='Infection_data'|!is.na(Infection_data))
condi_list <- list(condi1,condi2,condi3)

Management<- imap(mana_list,~{
  locat_year <- strsplit(.x,"/") %>% 
    unlist() %>% .[3] %>%
    gsub("(Management_information_|.xlsx)","",.,perl = T)
  print(.y)
  tmp<- xlsx::read.xlsx(.x,stringsAsFactors = F,sheetIndex = 1)
  row_id <- grep("^Managements$",tmp[,1],ignore.case = F,perl =T)
  
  col_start<- grep(c('Treatment|Plant protection|Infection_data'),
                   tmp[min(row_id+1),])
  col_end <- c(col_start[2:3]-1,col_start[3]+1)
  new_colnam <- as.character(unlist(tmp[row_id+1,])) 
  map(1:3,function(col_id){
    col_range <- seq(col_start[col_id],
                     col_end[col_id],1)
    tmp2 <- tmp[row_id+2:nrow(tmp),col_range]%>%
      `colnames<-`(new_colnam[col_range])%>% 
    # colnames(tmp2) <- new_colnam[col_range]
    # tmp2 <-  tmp2%>% 
      rename_with(~ "Date", matches("(?i)date")) %>% 
      filter(!!condi_list[[col_id]]) 
    if(col_id<3){
      tmp2<-tmp2  %>% 
        mutate(Date=as.Date(as.numeric(Date),origin='1900-01-01'))
    }
    tmp2<-tmp2  %>% 
      mutate(Locat_Year=locat_year)
    return(tmp2)
  })
})

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
  fold <- strsplit(.x,"/") %>% unlist() %>% .[3]
  if(fold=="KIE"){
    locat <- strsplit(.x,"/") %>% unlist() %>% .[6] %>%  strsplit(.,"_") %>% unlist() %>% .[1]
  }else{
    locat <- fold
  }
  res%>%  
    mutate(Location= locat,
           Year=strsplit(.x,"/") %>% unlist() %>% .[4])
})
names(soildf)[1] <- "Typesoil"
names(soildf)[grepl('Sand',names(soildf))] <- 'Sand'
soilt<- xlsx::read.xlsx(file="raw_data/google_ai_soil_table.xlsx",stringsAsFactors=F,sheetIndex = 1) 
names(soilt)[1] <- "Typesoil"
names(soildf) <- gsub("( |\\/|\\(|\\))",".",names(soildf)) %>% 
  gsub("Zwischen.*","",.)

a <- left_join(soildf,soilt) %>% 
  mutate(
    across(c(Clay:organical.content,Sand),function(x)gsub("(%|NA)","",x)),
    across(P2O5:K2O,function(x)gsub("(\\(|mg/100g|\\))","",x)),
    C.N.ratio=gsub("nicht.*","",C.N.ratio),
    organical.content=ifelse(grepl("0",organical.content),
                             as.numeric(organical.content)*100,
                             organical.content)
  ) %>% 
  mutate_all(., list(~na_if(.,"")))

cid <- c(names(a)[grepl("(Year|Location|soiltype|pH)",names(a))],
         names(a)[grepl("(Clay|Silt|Sand)",names(a))],
         names(a)[grepl("(Water|Nutri|crop|organic|C.N)",names(a))])

# names(a)[grepl("(Clay|Silt|Sand|pH|Year|Location|soiltype|Water|Nutri|crop)",names(a))]
xlsx::write.xlsx(a[,cid],"data/soil.xlsx",row.names = F)