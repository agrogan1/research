# Map for MICS GII X Discipline Paper

# libraries

library(rnaturalearth)

library(ggplot2)

library(ggrepel)

library(dplyr)

library(readr)

library(countrycode)

# read in MICS data

MICS_GII <- read_csv("MICS-GII-map/MICS-GII.csv")

# create ISO3 variable

MICS_GII$ISO3 <- countrycode(MICS_GII$Country, 
                           'country.name', 
                           'iso3c')

# merge countries with MICS data

mapdata <- left_join(ne_countries(), 
                     MICS_GII, 
                     by = c('iso_a3' = 'ISO3'))

# mapdata2 <- mapdata %>% filter(!is.na(GII))

# map

ggplot(data = mapdata) +
  geom_sf(aes(fill = GII)) +
  # ggrepel::geom_label_repel(
  #   data = mapdata2,
  #   aes(label = name, geometry = geometry),
  #   stat = "sf_coordinates",
  #   min.segment.length = 0,
  #   size = 2) + 
  scale_fill_gradient(name = "Gender \nInequality \nIndex",
                      low = "grey95",
                      high = "grey1",
                      na.value = "white") +
  # labs(title = "Gender Inequality Index",
  #      subtitle = "For Countries in MICS") +
  theme_minimal()

ggsave("MICS-GII-map/MICS-GII.pdf",
       width = 11,
       height = 8.5)

ggsave("MICS-GII-map/MICS-GII.png",
       width = 11,
       height = 8.5,
       bg = "white")


