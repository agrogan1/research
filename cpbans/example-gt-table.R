# example gt table

mydata %>% 
  gt() %>%
  tab_header(title = "Countries With Corporal Punishment Bans") %>%
  cols_label(
    type = html("Type of Ban"),
    year.of.prohibition = html("Year of Prohibition"),
    country = html("Country"),
    country_code = html("ISO3 Country Code"),
    total.number.of.bans = html("Total Number of Bans")
  )