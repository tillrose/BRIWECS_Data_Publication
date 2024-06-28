pkg.list <- 
  c("ggplot2",
    "tidyverse",
    "ggraph",
    "igraph",
    "pacman",
    "viridis",
    "xlsx",
    "rmakrdown",
    "knitr",
    "ggpmisc",
    'pacman',
    'scico',
    'purrr',
    "ggridges",
    "patchwork",
    "ggcorrplot",
    "paletteer",
    "factoextra",
    "ggrepel")
local.pkg <- installed.packages()[,"Package"]
new.packages <- pkg.list[!(pkg.list %in% local.pkg)]
if(length(new.packages)) install.packages(new.packages)

update.packages("dplyr")
update.packages("purrr")