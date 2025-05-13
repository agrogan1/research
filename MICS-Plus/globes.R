library(plotly)

library(tibble)

countries <- tribble( 
  ~country, ~country_code, 
  "Mongolia", "MNG",
  "Georgia", "GEO"
)

plot_geo(countries) %>%
  add_trace(locations = ~country_code, 
            z = 1,
            color = 1,
            colors = "gold") %>%
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
