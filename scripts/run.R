code_dir <- "scripts/pre-processing"
# install necessary packages
source(file.path(code_dir,"set_up.R"))
pacman::p_load(purrr,dplyr)
src.vec <- list.files(code_dir) %>%
  .[!grepl("set",.)] 
pb = txtProgressBar(min = 0, max = length(src.vec),
                    style = 3,    # Progress bar style
                    width = 30,initial = 0)
# running through scripts
iwalk(src.vec,~{
  source(file.path(code_dir,.x))
  message(.x)
  setTxtProgressBar(pb,.y) %>% print()
})