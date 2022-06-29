# waffle plots

library(waffle)

library(tibble)

library(dplyr)

library(michigancolors)

library(hrbrthemes)

mydata <- tribble(
  ~parts, ~vals, 
  "Not Spanked and Not Abused", 63,
  "Not Spanked and Abused", 5,
  "Spanked and Not Abused", 25, 
  "Spanked and Abused", 3,
  "Would Not Be Abused \nWere Spanking Eliminated", 4)

mydata %>%
  count(parts, wt = vals) %>%
  ggplot(aes(label = parts, values = n)) +
  geom_pictogram(n_rows = 10, 
                 aes(colour = parts), 
                 flip = TRUE, 
                 make_proportional = TRUE,
                 size = 5) +
  scale_color_manual(name = NULL,
                     values = c("#CC0000",
                                "#999999",
                                "#FF9900",
                                "#333399",
                                "#009900")) +
  scale_label_pictogram(
    name = NULL,
    values = c("child", "child", "child", "child")) +
  coord_equal() +
  labs(title = "Physical Abuse Among A Hypothetical Sample", 
       subtitle = "of 100 Children") +
  theme_ipsum_rc(grid="") +
  theme_void() +
  theme(legend.key.height = unit(2.25, "line")) +
  theme(legend.text = element_text(size = 10, 
                                   hjust = 0, 
                                   vjust = 0.75))

ggsave("./MICS-physical-abuse-waffle/pabuse.png")







