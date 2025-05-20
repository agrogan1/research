library(plotly) 

library(tibble)

library(rnaturalearth)

library(ggplot2)

library(sf)

library(patchwork)

# country outlines with rnaturalearth

Mongolia <- ne_countries(country = "mongolia",
                         scale = "medium")["geometry"]

Georgia <- ne_countries(country = "georgia",
                        scale = "medium")["geometry"]

plot(Mongolia,
     main = Mongolia
     col = "#FFBB00")

plot(Georgia,
     main = "Georgia",
     col = "#FFBB00")

pMongolia <- ggplot(Mongolia) + 
  geom_sf(fill = "#FFBB00",
          color = "black") +
  annotate("text", 
           x = 103, 
           y = 47, 
           label = "Mongolia", 
           color = "black",
           size = 7) +
  theme_void() +
  theme(plot.background = element_rect(fill = "#113f5d"),
        panel.background = element_rect(fill = "#113f5d"))

pGeorgia <- ggplot(Georgia) + 
  geom_sf(fill = "#FFBB00",
          color = "black") +
  annotate("text", 
           x = 43.7, 
           y = 42.1, 
           label = "Georgia", 
           color = "black",
           size = 7) +
  theme_void() +
  theme(plot.background = element_rect(fill = "#113f5d"),
        panel.background = element_rect(fill = "#113f5d"))

pMongolia / pGeorgia & 
  theme(panel.border = element_rect(colour = "#113f5d", 
                                    fill="NA"))

ggsave("./MICSPLUS/Mongolia and Georgia.png",
       height = 4,
       width = 4)

# plotly globe

countries <- tribble( 
  ~country, ~country_code, 
  "Mongolia", "MNG",
  "Georgia", "GEO"
)

plot_geo(countries) %>%
  add_trace(locations = ~country_code, 
            z = 1,
            color = 1,
            colors = "#FFBB00") %>%
  layout(title = "",
         geo = list(showland = TRUE,
                    # landcolor = toRGB("grey"),
                    landcolor = "#EBEBEB",
                    showcountries = TRUE,
                    projection = list(type = 'orthographic',
                                      rotation = list(lon = 55,
                                                      lat = 25,
                                                      roll = 0)),
                    bgcolor = "white",
                    framecolor = "black",
                    countrycolor = "black"),
         plot_bgcolor  = "#113f5d",
         paper_bgcolor = "#113f5d") %>% 
  hide_colorbar()
