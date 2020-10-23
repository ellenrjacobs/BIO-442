##Assignment 1 Map Plotting Template

library(sp)
library(rgdal)

clean_data <- read.csv("my_clean_data.csv")

plotting_data <- SpatialPoints(clean_data[, c("Longitude", "Latitude")])

#Map of DC neighborhoods from maps2.dcgis.dc.gov
dc <- readOGR("Neighborhood_Clusters-shp", "Neighborhood_Clusters")

#Plot the map of DC

par(mar = c(1, 1, 1, 1))

plot(
  dc,
  col = "darkgrey",
  border = "white",
  main = "District of Columbia Bird Sightings"
)
plot(dc[46, ],
     add = TRUE,
     col = "#718BAE80",
     border = "white")


#Add your data

plot(plotting_data,
     add = TRUE,
     pch = 16,
     cex = 0.25)
