library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
r <- raster(ncol=10, nrow=10)


ymin(r) <- 42.078433865038505
ymax(r) <- 42.10709506728437
xmin(r) <- -93.85498251613917
xmax(r) <- -93.83524145838685

# 42.10709506728437, -93.85498251613917
# 42.10709506728437, -93.83524145838685
# 42.078433865038505, -93.85446753202392
# 42.0781790407238, -93.83506979701508

Test.area <- get_ssurgo(template = r,label = "Crop_SelectionTest")

##selecting the important Tables
Test.areaTabular <- Test.area$tabular
Componet <- Test.areaTabular$component
chorizon <- Test.areaTabular$chorizon
mapunit <- Test.areaTabular$mapunit
legend <- Test.areaTabular$legend


##for chorizon Select only important columns
  ##as of now only depth and ph are important, probably need to add some
chorzonSim <-select(chorizon, cokey,chkey,hzdept.l,hzdept.r,hzdept.h, ph1to1h2o.l,ph1to1h2o.r,ph1to1h2o.h) %>%
  mutate(depth = hzdept.r /2.54) ##set to Inches

##Group Depths together
chorzonSim <-chorzonSim%>%
  mutate(depthLevel = ifelse(depth <12,"0-12",ifelse(depth<24, "12-24",ifelse(depth<36,'24-36',"36+"))))


##Find Average pH by Depth Level
chorzonSim <-chorzonSim %>%
  group_by(cokey, depthLevel) %>%
  mutate(pH_average = mean(ph1to1h2o.r, na.rm=TRUE))

##simplifying Componet
ComponetSim <-select(Componet, cokey,mukey,slope.l,slope.r,slope.l,geomdesc,elev.l,elev.r,elev.h,taxclname,taxpartsize)

##merges Them
Overall <- merge(ComponetSim,mapunit, by.x = "mukey", by.y = "mukey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,legend, by.x = "lkey", by.y = "lkey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,chorzonSim, by.x = "cokey", by.y = "cokey",all.x = TRUE, all.y =TRUE)

glimpse(Overall)
write.csv(Overall,"6_16_CropSelectionTest.csv")

##Crop Info
CropData <- read_excel("Crop-Info_Farmer Asset Mapping.xlsx")

