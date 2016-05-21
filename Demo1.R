library(ggplot2)

nyc_tracts_df <- readRDS("nyc-income-df.rds")

ggplot(nyc_tracts_df, aes(x=long, y=lat, group=group, fill=percent)) +
  geom_polygon(color="transparent") +
  coord_map()
