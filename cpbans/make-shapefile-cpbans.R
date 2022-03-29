# make shapefile of cp bans

library(maps) # maps

library(maptools) # maptools

library(sf) # simple features

library(maptools) # map data

library(countrycode) # manipulate country names and codes

library(dplyr) # data wrangling

data(wrld_simpl) # world simple data

global_data <- st_as_sf(wrld_simpl) # make an sf dataset

load("cpbans/CPBans.RData")

# cpbans is an sf object that is subset of global_data

cpbans <- global_data %>% 
  select(-POP2005) %>%
  filter(ISO3 %in% mydata$country_code)

st_write(cpbans, "cpbans/shapefile/cpbans.shp")

zip(zipfile = "cpbans/shapefile/cpbans.zip",
    files = c("cpbans/shapefile/cpbans.shp",
              "cpbans/shapefile/cpbans.shx",
              "cpbans/shapefile/cpbans.dbf",
              "cpbans/shapefile/cpbans.prj"))


# make a map!

library(ggplot2)

ggplot(global_data,
       aes(fill = 1)) +
  geom_sf(fill = "grey") +
  geom_sf(data = cpbans, fill = "#5b92e5") +
  labs(title = "Countries With Corporal Punishment Bans") +
  theme_minimal()

ggsave("cpbans/cpbans-ggplot.png")






