treatment_location_name_correction<- function(df){
  df %>% 
    mutate(
      Treatment = stringr::str_replace_all(Treatment, "(D{1,2})", "D"),# replace DD or D to D
      Treatment=case_when(Location=="GGE"& 
                            Year%in%c(2015,2018,2019)&#
                            (!grepl("D",Treatment))~paste0(Treatment,"_IR"),# irrigation when not with D text
                          T~Treatment),
      Treatment=case_when(Location=="DKI"~paste0(Treatment,"_RO"),# rain out shelter
                          T~Treatment),
      Treatment = stringr::str_replace_all(Treatment, "_(D{1,2})", ""), # replace D 
      Treatment=case_when(!grepl("(IR|RO)$",Treatment)~paste0(Treatment,"_RF"),# the rest all replace with 
                          T~Treatment),
      Location=gsub("DKI","KIE",Location)
    )
}