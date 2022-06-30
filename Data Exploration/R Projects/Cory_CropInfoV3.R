library(ggplot2)
library(FedData)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)
library(raster)

s <- raster(ncol=2, nrow=2)

ymin(s) <- 42.078433865038505
ymax(s) <- 42.10709506728437
xmin(s) <- -93.85498251613917
xmax(s) <- -93.83524145838685

#Gather Data from Web Soil Survey
Area<- get_ssurgo(template = s,label = "CropSelection_V3")
Data <- Area$tabular

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
            ptotal = mean(ptotal.r,na.rm=TRUE),soilTextsum = soilText, )%>%
  filter(soilTextsum!="")

chData <- merge(chorzonSim2,CropData,by = "Types of Crops")



##function to  determine which soil texture to use

Overall <- Overall %>%
  filter(majcompflag=="Yes")

Overall2<- merge(Overall,chData,by = "cokey", all = TRUE)


Overall2 <- Overall2 %>%
  filter(majcompflag=="Yes")

Simple <- as_tibble(Overall2) %>%
  dplyr::select(mukey,cokey,muname = muname.x,taxorder,compname,slope.r,slopegradwta, slope.l,slope.h,localphase,erokind,erocl,tfact,wei,
         niccdcd,hydgrp,soilslippot,drainagecl,drclassdcd,niccdcd,awc,aws025wta,aws050wta, flodfreqcl,floddurcl,pondfreqcl,
         pondfreqprs,flodfreqdcd,flodfreqmax,pondfreqprs,iacornsr,ph,ph_l,ph_h,cec7,gypsum,ksat,ec,sar,caco3,om,ptotal, 
         soilTextdes =soilTextsum,`Types of Crops`,`Soil Types`,`Rooting Depth`,`pH-Level`,`Temperature Tolerances`)

write.csv(Simple,"CropSelection2.csv")
