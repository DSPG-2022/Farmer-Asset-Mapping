library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)

##Area of Selection
s <- raster(ncol=2, nrow=2)

ymin(s) <- 42.84894696045697
ymax(s) <- 42.87652608303261
xmin(s) <- -92.97595243970417
xmax(s) <- -92.94013998546687

#42.87652608303261, -92.97595243970417
#42.87635998062507, -92.94013998546687
#42.84894696045697, -92.94081996877516
#v42.84761753494782, -92.97481913419033

#Gather Data from Web Soil Survey
Area<- get_ssurgo(template = s,label = "CropSelection2", force.redo = TRUE)

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
  #mutate(depthLevel = ifelse(depth <12,"0-12",ifelse(depth<24, "12-24",ifelse(depth<36,'24-36',"36+"))))
  mutate(depthLevel = ifelse(depth <24,"0-24",ifelse(depth<48, "24-48","48+")))


##Find Average pH by Depth Level
chorzonSim <-chorzonSim %>%
  group_by(cokey, depthLevel) %>%
  mutate(pH_average = mean(ph1to1h2o.r, na.rm=TRUE))

##simplifying Componet
ComponetSim <-select(Componet, cokey,mukey,slope.l,slope.r,slope.l,geomdesc,elev.l,elev.r,elev.h,taxclname,taxpartsize, ffd.r)

##merges Them
Overall <- merge(ComponetSim,mapunit, by.x = "mukey", by.y = "mukey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,legend, by.x = "lkey", by.y = "lkey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,chorzonSim, by.x = "cokey", by.y = "cokey",all.x = TRUE, all.y =TRUE)

##Crop Info
CropData <- read_excel("Crop-Info_Farmer.xlsx")[1:19,]

##Soil Texture
#SoilTexture <- read_excel("SoilTextureHierarchy.xlsx")

##merges Soil Texture Hierarchy with Soil Data
#Overall <- merge(Overall,SoilTexture, by.x = "texdesc", by.y = "Sand Type", all.x= TRUE, all.y = FALSE)

##Merges Crop Info with Web Soil Survey
MergedData <- sqldf("select * from Overall left join CropData
             on (Overall.pH_average >= CropData.ph_L and Overall.pH_average <= CropData.ph_H and Overall.depth <= CropData.Depth_h and Overall.depth >= CropData.Depth_l)")
MergedDataNoNA <- MergedData %>%
  filter(!is.na(`Types of Crops`))

##CHANGE TO  Soil_Text
MergedDataNoNA <- MergedDataNoNA %>%
  ##Fix Issue with Sandy loam and Loamy Sand
  group_by(musym,`Types of Crops`, chkey)%>%
  mutate(SoilCompatability = ifelse(
    length(intersect(unlist(strsplit(tolower(texdesc),split=" ")),unlist(strsplit(tolower(Soil_Text),split=" ")))) == 0,0.1,
    (length(intersect(unlist(strsplit(tolower(texdesc),split=" ")),unlist(strsplit(tolower(Soil_Text),split=" ")))) / max(length(unlist(strsplit(tolower(Soil_Text),split=" "))),length(unlist(strsplit(tolower(texdesc),split=" ")))))))%>%
  mutate(SoilCompatability = SoilCompatability *100)
##mutate(SoilCompatability = ifelse(texdesc == `Soil Types`,1,ifelse(`Soil Types`== Accept_Other_Type1,0.9,ifelse(`Soil Types` == Accept_Other_Type2,0.8,ifelse(`Soil Types` == Accept_Other_Type3,0.7,ifelse(`Soil Types`==Accept_Other_Type4,0.6,ifelse(`Soil Types`==Accept_Other_Type5,0.5,0.1)))))))


write.csv(MergedDataNoNA,"CropSelection2.csv")
