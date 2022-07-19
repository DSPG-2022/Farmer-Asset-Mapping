library(ggplot2)
library(FedData)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)
library(raster)

##Bounding Box Input
s <- raster(ncol=2, nrow=2)
ymin(s) <- 42.078433865038505
ymax(s) <- 42.10709506728437
xmin(s) <- -93.85498251613917
xmax(s) <- -93.83524145838685

#Gather Data from Web Soil Survey
##Input can Either be a RasterLayer or a Spatial object
##Output is
  ##It downloads 2 Folders to local File, a RAW and an EXTRACTIONS folder
  ##Raw is raw data, EXTRACTIONS hold all info, has both tabular and spatial object
    ##In Extraction, will have folder named label
##NEED TO, specifiy where These folders go
#force.redo, Parameter in funciton that if
  #set to false, means that if there is already data in label folder, then it won't download data from web soil survey
  #set to true, any time it is called it will download data fromm web soil surbey and overwrite what is stored in label folder
Area<- get_ssurgo(template = s,label = "CropSelection_V3")



Data <- Area$tabular
Statefips<- as.numeric(sum(19000,as.numeric(substr(Data$legend$areasymbol,3,5))))
StateAbv <-substr(Data$legend$areasymbol,0,2)
componet <- Data$component 
muaggart <-Data$muaggatt
mapunit <-Data$mapunit
comonth <- Data$comonth %>% filter(month=="May")
coerosionacc <- Data$coerosionacc %>% filter(rvindicator=="Yes")

Overall<- merge(muaggart,componet,by = "mukey", all = TRUE)
Overall<- merge(Overall,mapunit,by = "mukey", all = TRUE)
Overall<- merge(Overall,comonth,by = "cokey", all = TRUE)
Overall<- merge(Overall,coerosionacc,by = "cokey", all = TRUE)

chorizon <- Data$chorizon
chtexturegrp <-Data$chtexturegrp %>%filter(rvindicator == "Yes")

chorizon2 <- merge(chorizon,chtexturegrp, by = "chkey", all.x=TRUE)
chorizon2 <-chorizon2%>%
  mutate(depth = hzdept.r /2.54)
#CropData
CropData <- read_excel("Crop-Info_Farmer Asset Mapping.xlsx")

MergedData <- sqldf("select * from chorizon2 left join CropData
             on (chorizon2.depth <= CropData.Depth_l)")
MergedDataNoNA <- MergedData %>%
  filter(!is.na(`Types of Crops`))




chorzonSim <-MergedDataNoNA%>%
  mutate(depthLevel = "0-MaxRootDepth")


chorzonSim2<- chorzonSim%>%
  filter(depthLevel=="0-MaxRootDepth")%>%
  group_by(cokey,`Types of Crops`)%>%
  mutate(soilText= ifelse(depth==0,texdesc,""))%>%
  summarise(ksat = mean(ksat.r,na.rm=TRUE),awc = mean(awc.r, na.rm=TRUE),caco3 = mean(caco3.r,na.rm=TRUE),gypsum= mean(gypsum.r,na.rm=TRUE),sar =mean(sar.r,na.rm=TRUE),ec = mean(ec.r,na.rm=TRUE),cec7= mean(cec7.r,na.rm=TRUE), ph = mean(ph1to1h2o.r,na.rm=TRUE),ph_l = mean(ph1to1h2o.l,na.rm=TRUE),ph_h= mean(ph1to1h2o.h,na.rm=TRUE),om= mean(om.r,na.rm=TRUE),
            ptotal = mean(ptotal.r,na.rm=TRUE),soilTextsum = soilText,Kfact = mean(kffact,na.rm=TRUE))%>%
  filter(soilTextsum!="")

chData <- merge(chorzonSim2,CropData,by = "Types of Crops")



##function to  determine which soil texture to use

Overall <- Overall %>%
  filter(majcompflag=="Yes")

Overall2<- merge(Overall,chData,by = "cokey", all = TRUE)


Overall2 <- Overall2 %>%
  filter(majcompflag=="Yes")

Simple <- as_tibble(Overall2) %>%
  dplyr::select(musym.x,mukey,cokey,muname = muname.x,taxorder,compname,slope.r,slopegradwta, slope.l,slope.h,localphase,erokind,erocl,tfact,Kfact,wei,
         niccdcd,hydgrp,soilslippot,drainagecl,drclassdcd,niccdcd,awc,aws025wta,aws0150wta, flodfreqcl,floddurcl,pondfreqcl,
         ponddurcl,flodfreqdcd,flodfreqmax,pondfreqprs,iacornsr,ph,ph_l,ph_h,cec7,gypsum,ksat,ec,sar,caco3,om,ptotal, 
         soilTextdes =soilTextsum,`Types of Crops`,`Soil Types`,`Rooting Depth`,`pH-Level`,`Temperature Tolerances`,ph_L,ph_H,Boron,Copper,Zinc,Molybdenum,Iron,Manganese,)
CropRotation <- read_excel("Sanika-Crop_Rotation.xlsx")

Simple <- merge(Simple,CropRotation, by.x = "Types of Crops", by.y = "Crop", all.x=TRUE )

Simple<- Simple%>%
  mutate(Flags =
           ifelse(ph <= ph_H & ph>=ph_L,0,1),FlagDesc = ifelse(ph <= ph_H & ph>=ph_L,"",",pH does not fit into range"))%>%
  mutate(Flags = 
           ifelse(soilTextdes != `Soil Types`,Flags+1,Flags),FlagDesc = ifelse(soilTextdes!=`Soil Types`,paste(FlagDesc,"Soil Texture does not match",sep=','),FlagDesc))%>%
  mutate(Flags = 
           ifelse(tfact <4,Flags+1,Flags),FlagDesc =ifelse(tfact <4,paste(FlagDesc,"Soil Erosion Tolerance may be an issue",sep=','),FlagDesc) )%>%
  mutate(Flags  =
           ifelse(Kfact> .38,Flags+1,Flags),FlagDesc =ifelse(Kfact> .38,paste(FlagDesc,"This soil is more susceptible to erosion",sep=','),FlagDesc))%>%
  mutate(Flags  =
           ifelse(om<2 | om>8,Flags+1,Flags),FlagDesc =ifelse(om< 2|om>8,paste(FlagDesc,"This soil's organic matter percent could be an issue",sep=','),FlagDesc))%>%
  mutate(Flags  =
           ifelse(erocl == "Class 2",Flags+1,Flags),FlagDesc =ifelse(erocl == "Class 2",paste(FlagDesc,"This soil's topsoil may have been depleated",sep=','),FlagDesc))%>%
  mutate(Flags  =
           ifelse(aws0150wta <=9.00,Flags+1,Flags),FlagDesc =ifelse(aws0150wta<=9.00,paste(FlagDesc,"This soil's water holding may be limited",sep=','),FlagDesc))%>%
  mutate(Flags  =
           ifelse(drclassdcd =="Very poorly drained" | drclassdcd == "Poorly drained",Flags+1,Flags),FlagDesc =ifelse(drclassdcd =="Very poorly drained" | drclassdcd == "Poorly drained",paste(FlagDesc,"This soil's drainage may be limited",sep=','),FlagDesc))%>%
  mutate(FlagDesc =  ifelse(substr(FlagDesc,1,1)==',',substr(FlagDesc,2,nchar(FlagDesc)),FlagDesc))
  


##NEED TO FIX
#  mutate(Flags  =
        #   ifelse(pondfreqcl == "Frequent" | ponddurcl=="",Flags+1,Flags, na.rm=TRUE),FlagDesc =ifelse(pondfreqcl == "Frequent" | ponddurcl=="",paste(FlagDesc,"This soil's may have an issue with ponding",sep=','),FlagDesc, na.rm=TRUE))
#  mutate(Flags  =
         #  ifelse(flodfreqcl == "Frequent" | flodfreqcl== "Very frequent" |flodfreqcl=="",Flags+1,Flags),FlagDesc =ifelse(flodfreqcl == "Frequent" | flodfreqcl== "Very frequent" |flodfreqcl=="",paste(FlagDesc,"This soil's may have an issue with flooding",sep=','),FlagDesc))

source("GitHub\\Farmer-Asset-Mapping\\Data Exploration\\R Projects\\Cory_UpdateRiskURLParams.R")  
write.csv(Simple,"CropSelection2.csv")
