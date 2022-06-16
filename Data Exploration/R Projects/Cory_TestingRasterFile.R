library(ggplot2)
library(FedData)
require(rgdal)
library(raster)

r <- raster(ncol=10, nrow=10)

ymax(r) <- 42.038534290775225
xmin(r) <- -93.48364437815002
xmax(r) <- -93.42596615723883
ymin(r) <- 41.99721346419466
# 42.038534290775225, -93.48364437815002 Upper left
# 42.037004368587496, -93.42596615723883 Upper Right
# 41.999254629022786, -93.47883785974075 Lower Left
# 41.99721346419466, -93.4273394482129 Lower Right
r
SSURGO.areas <- get_ssurgo(template = r,label = "Raster_Test") #Querty Data from Web Soil Survey
