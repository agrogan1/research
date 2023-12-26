# Map for MICS GII X Discipline Paper

library(rnaturalearth)

library(ggplot2)

library(dplyr)

library(readr)

MICS_GII <- read_csv("MICS-GII-map/MICS-GII.csv")

ggplot(data = ne_countries()) +
  geom_sf() +
  theme_minimal()





