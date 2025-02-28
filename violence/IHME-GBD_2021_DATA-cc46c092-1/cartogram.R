# cartogram of deaths from terrorism and conflict

library(readr)

library(dplyr)

IHME_GBD_2021 <- read_csv("violence/IHME-GBD_2021_DATA-cc46c092-1/IHME-GBD_2021_DATA-cc46c092-1.csv")

IHME_GBD_2021 <- IHME_GBD_2021 %>% 
  filter(measure_name == "Deaths") %>%
  filter(cause_name == "Conflict and terrorism") %>%
  filter(metric_name == "Rate")

summary(IHME_GBD_2021$val)

hist(IHME_GBD_2021$val)

names(IHME_GBD_2021)