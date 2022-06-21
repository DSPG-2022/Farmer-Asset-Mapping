library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)

##Area of Selection
s <- raster(ncol=2, nrow=2)

ymin(s) <- 42.078433865038505
ymax(s) <- 42.10709506728437
xmin(s) <- -93.85498251613917
xmax(s) <- -93.83524145838685

#Gather Data from Web Soil Survey
Area<- get_ssurgo(template = s,label = "CropSelection", force.redo = TRUE)

##selecting the important Tabl
AreaTabular <- Area$tabular
Componet <- AreaTabular$component
chorizon <- AreaTabular$chorizon
mapunit <- AreaTabular$mapunit
legend <- AreaTabular$legend
chtexturegrp <-AreaTabular$chtexturegrp %>%
  filter(rvindicator == "Yes")

chorizon <- merge(chorizon,chtexturegrp, by = "chkey")

##for chorizon Select only important columns
##as of now only depth and ph are important, probably need to add some
chorzonSim <-select(chorizon, cokey,chkey,hzdept.l,hzdept.r,hzdept.h, ph1to1h2o.l,ph1to1h2o.r,ph1to1h2o.h, texdesc) %>%
  mutate(depth = hzdept.r /2.54) ##set to Inches

##Group Depths together
chorzonSim <-chorzonSim%>%
  mutate(depthLevel = ifelse(depth <12,"0-12",ifelse(depth<24, "12-24",ifelse(depth<36,'24-36',"36+"))))


##Find Average pH by Depth Level
chorzonSim <-chorzonSim %>%
  group_by(cokey, depthLevel) %>%
  mutate(pH_average = mean(ph1to1h2o.r, na.rm=TRUE))

##simplifying Componet
ComponetSim <-select(Componet, cokey,mukey,slope.l,slope.r,slope.l,geomdesc,elev.l,elev.r,elev.h,taxclname,taxpartsize, ffd)

##merges Them
Overall <- merge(ComponetSim,mapunit, by.x = "mukey", by.y = "mukey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,legend, by.x = "lkey", by.y = "lkey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,chorzonSim, by.x = "cokey", by.y = "cokey",all.x = TRUE, all.y =TRUE)

##Crop Info
CropData <- read_excel("Crop-Info_Farmer Asset Mapping.xlsx")


##Merges Crop Info with Web Soil Survey
MergedData <- sqldf("select * from Overall left join CropData
             on (Overall.pH_average >= CropData.ph_L and Overall.pH_average <= CropData.ph_H and Overall.depth <= CropData.Depth_h and Overall.depth >= CropData.Depth_l)")
MergedDataNoNA <- MergedData %>%
  filter(!is.na(`Types of Crops`))
write.csv(MergedDataNoNA,"CropSelection.csv")
