library(ggplot2)
library(FedData)
library(raster)


r <- raster(ncol=10, nrow=10) #ncol and #nrow are most likely not important
#min acres: 0.05
#max acres: 100,000

ymin(r) <- 41.99721346419466
ymax(r) <- 42.038534290775225
xmin(r) <- -93.48364437815002
xmax(r) <- -93.42596615723883

# 42.038534290775225, -93.48364437815002 Upper left
# 42.037004368587496, -93.42596615723883 Upper Right
# 41.999254629022786, -93.47883785974075 Lower Left
# 41.99721346419466, -93.4273394482129 Lower Right
r
SSURGO.areas <- get_ssurgo(template = r,label = "Raster_Test") #Querty Data from Web Soil Survey
#42.06657633648302, -93.67933834195587


##For Geojson File

library(geojsonio)

sp <- geojson_read("map.geojson", what ="sp")


Test_surrgo_geojson <- get_ssurgo(template = sp,label = "geojson_Test") #Querty Data from Web Soil Survey
