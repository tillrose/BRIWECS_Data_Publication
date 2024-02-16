pkg.list <- 
  c("ggplot2",
    "tidyverse",
    "viridis",
    "ggpmisc",
    'pacman',
    'scico',
    'purrr',
    "ggridges",
    "patchwork",
    "ggcorrplot",
    "paletteer",
    "ggrepel")
local.pkg <- installed.packages()[,"Package"]
new.packages <- pkg.list[!(pkg.list %in% local.pkg)]
if(length(new.packages)) install.packages(new.packages)
# remotes::install_github("Illustratien/toolPhD",dependencies = T)

update.packages("dplyr")
update.packages("purrr")