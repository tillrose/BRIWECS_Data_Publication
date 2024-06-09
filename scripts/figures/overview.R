library(ggplot2)
library(webr)
library(dplyr)

first.ring <- c("Genotype","Locations","Year","Management") 
second.ring <- list(c("228 cultivars","year of release\n1960-2016","SNIP"),
                    c("6 locations","soil map","experimental deisgn"),
                    c("precipitation","iradiance","temperature"),
                    c("plant protection","irrigation","fertilization"))
repid <- purrr::map_dbl(second.ring,~{
  length(.x)
})
pheno <- purrr::map2(first.ring,repid,~{
  rep(.x,each=.y)
}) %>% unlist()


td <- data.frame(phenotype=pheno,factor1=second.ring %>% unlist()) %>% 
  group_by(phenotype) %>% 
  mutate(n=n()) %>% ungroup()

PieDonut(td, aes(phenotype, factor1, count=n),
         explode = c(1,2,3,4),r0 = .5,
         addDonutLabel = TRUE,
         # family = "Arial",
         showRatioDonut = F, labelposition = 0.2,
         showRatioPie = F)
# +
  # theme(panel.border = element_blank())
