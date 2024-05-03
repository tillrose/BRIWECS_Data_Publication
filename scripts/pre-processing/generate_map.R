
## ggsflabel has to be installed from github

library("tidyverse")
library("sf")
library("ggthemes")
library("rnaturalearth")
library("ggrepel")
library("ggsflabel")

## Background map
ctrys <- ne_countries(continent = "europe", scale = 10, type = "countries", returnclass = "sf")
ctrys <- ctrys %>% 
  mutate("fill" = "grey90",
         fill = ifelse(sovereignt == "Germany", "darkgoldenrod1", fill))


## Locations
locations <- read_delim("metadata/BRIWECS_location_coordinates.csv")
locations <- st_as_sf(locations, coords = c("Long", "Lat"), crs = st_crs(ctrys)) 
locations <- locations %>% 
  mutate("nudge" = case_when(Location == "KIE" ~ 2,
                               Location == "HAN" ~ -2,
                               Location == "QLB" ~ 2,
                               Location == "RHH" ~ 2,
                               Location == "KAL" ~ -2,
                               Location == "GGE" ~ 2))

locations_1 <- locations %>% 
  filter(Location %in% c("KIE", "QLB", "RHH", "GGE"))
locations_2 <- locations %>% 
  filter(Location %in% c("HAN", "KAL"))

## Map
plot_ <- ggplot() +
  theme_map() + theme(panel.background = element_rect(fill = "dodgerblue3", colour = "transparent", linewidth = 0.25),
                      plot.background = element_rect(colour = "black")) +
  geom_sf(data = ctrys, aes(fill = fill), colour = "black", size = 0.25) +
  geom_sf_label_repel(data = locations_1, fill = "white", size = 4, aes(label = Location), nudge_x = 2, label.r = unit(0, "lines")) +
  geom_sf_label_repel(data = locations_2, fill = "white", size = 4, aes(label = Location), nudge_x = -2, label.r = unit(0, "lines")) +
  geom_sf(data = locations, shape = 21, fill = "red3", size = 3, stroke = 0.5) +
  coord_sf(xlim = c(-3, 23), ylim = c(43, 59)) +
  scale_fill_identity()

ggsave(plot = plot_, device = "png", filename = "BRIWECS_locations_map.png", path = "figure/")
