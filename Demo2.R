library(leaflet)

nyc_tracts <- readRDS("nyc-income.rds")

pal <- colorNumeric("RdYlBu", NULL)
leaflet(nyc_tracts) %>%
  addTiles() %>%
  addPolygons(
    weight = 1, fillOpacity = 0.7, smoothFactor = 0.2,
    color = ~pal(percent), label = ~paste0(round(percent), "%")
  ) %>%
  addLegend(pal = pal, values = ~percent, title = "% over $200K")
