library(sp)
library(dplyr)

nyc_tracts <- readRDS("nyc-income.rds")

nyc_tracts@data %>%
  select(geography, total, over_200, percent) %>%
  View()
