library(rgdal)    # for readOGR and others
library(sp)       # for spatial objects
library(leaflet)  # for interactive maps (NOT leafletR here)
library(dplyr)    # for working with data frames
library(ggplot2)  # for plotting

tract <- readOGR(dsn="data/", layer = "cb_2014_36_tract_500k")
# convert the GEOID to a character
tract@data$GEOID<-as.character(tract@data$GEOID)

data <- read.csv("data/ACS_13_5YR_B19001.csv", stringsAsFactors = FALSE)

data <- select(data, GEO.id2, GEO.display.label, HD01_VD01, HD01_VD17) %>% 
  slice(-1) %>% # census has this extra descriptive record
  rename(id=GEO.id2, geography=GEO.display.label, total=HD01_VD01,
    over_200=HD01_VD17)

data <- mutate(data, id=as.character(id),
  geography=as.character(geography),
  total = as.numeric(total),
  over_200 = as.numeric(over_200),
  percent = (over_200/total)*100)

# # convert polygons to data.frame
# # Note that with ggplo2 version 2.0 you will need to 
# # Add maptools see http://bit.ly/1rybv3O
# library(maptools)
# ggtract<-fortify(tract, region = "GEOID") 
# # join tabular data
# ggtract<-left_join(ggtract, data, by=c("id")) 
# 
# # here we limit to the NYC counties
# ggtract <- ggtract[grep("Kings|Bronx|New York County|Queens|Richmond", ggtract$geography),]
# 
# ggplot() +
#   geom_polygon(data = ggtract , aes(x=long, y=lat, group = group, fill=percent), color="grey50") +
#   scale_fill_gradientn(colours = c("red", "white", "cadetblue"),
#     values = c(1,0.5, .3, .2, .1, 0))+
#   coord_map(xlim = c(-74.26, -73.71), ylim = c(40.49,40.92))



# create a new version
df.polygon2<-tract #tract is the 

# create a rec-field to make sure that we have the order correct
# this probably is unnecessary but it helps to be careful
df.polygon2@data$rec<-1:nrow(df.polygon2@data)
tmp <- left_join(df.polygon2@data, data, by=c("GEOID"="id")) %>% 
  arrange(rec)

# replace the original data with the new merged data
df.polygon2@data<-tmp
# limit to NYC
df.polygon2 <- df.polygon2[grep("Kings|Bronx|New York County|Queens|Richmond", df.polygon2$geography),]
#df.polygon2 <- df.polygon2[order(df.polygon2$percent),]

saveRDS(df.polygon2, "nyc-income.rds")
