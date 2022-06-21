library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
t <- raster(ncol=2, nrow=2)

ymin(t) <- 42.31099067527376
ymax(t) <- 42.325325673547056
xmin(t) <- -92.90460116766555
xmax(t) <- -92.88551960008392

#42.325325673547056, -92.90460116766555
#42.32509995085107, -92.88551960008392
#42.31099067527376, -92.88582490516522
#42.31110356203111, -92.90460116766555



#ymin(t) <- 42.513722543108855
#ymax(t) <- 42.52713373548898
#xmin(t) <- -92.5545365313668
#xmax(t) <- -92.52466745268065

# 42.52713373548898, -92.55384988587976
# 42.527639761857884, -92.52466745268065
# 42.513722543108855, -92.52535409816768
# 42.51346947407476, -92.5545365313668


Test.area <- get_ssurgo(template = t,label = "Crop_SelectionTest", force.redo = TRUE)

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





##Merging datasets together
library(sqldf)

#output <- sqldf("select * from FD left join shpxt 
#                on (FD.X >= shpxt.Xmin and FD.X <= shpxt.Xmax and
#               FD.Y >= shpxt.Ymin and FD.Y <= shpxt.Ymax ) ")

##have to use SQL basically 
##need to account for more variables


test2 <- sqldf("select * from Overall left join CropData
             on (Overall.pH_average >= CropData.ph_L and Overall.pH_average <= CropData.ph_H and Overall.depth <= CropData.Depth_h and Overall.depth >= CropData.Depth_l)")
test3 <- test2 %>%
  filter(!is.na(`Types of Crops`))
write.csv(test2,"6_16_CropSelection.csv")
write.csv(test3,"6_16_CropSelection2.csv")




##testing depth
Overall2 <-sqldf("select * from Overall left join CropData
             on (Overall.pH_average >= CropData.ph_L and Overall.pH_average <= CropData.ph_H)")
Overall2 <- Overall2 %>%
  group_by(musym)%>%
  group_by(`Types of Crops`) %>%
  mutate(depthCheck = ifelse(depth<= Depth_h,ifelse(depth>=Depth_l,1,ifelse(pH_average>=ph_L,ifelse(pH_average<=ph_H,2,3),3)),0))

OverallView <- Overall2 %>%
  select(musym,mukey,chkey,`Types of Crops`,pH_average,ph_L,ph_H,depth,Depth_l,Depth_h,depthCheck,depthLevel) %>%
  group_by(`Types of Crops`)
