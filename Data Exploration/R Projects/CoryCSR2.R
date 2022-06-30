library(ggplot2)
library(FedData)
library(readxl)
library(dplyr)
library(tidyr)
SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

IA001.Tabular <- SSURGO.areas$tabular
Space <- SSURGO.areas$spatial
#mapuniit$iacornsr
#componet$taxsubgrp
#muaggart$aws_wta
#comonth$flodfreqcl
#comonth$floddurcl
#comonth$pond3frercl
#comonth$ponddurcl
#componet$slope.r
#componet$erocl - how much topsoil has been lost
#componet$localphase
#componettfact - erosion tolerance
#componet$wei
#componet$taxorder
#componet$compname
#componet$drainagecl
#componet$soilslipot ##possibily that mass of soil will slip when 1)veg is removed 2)soil water near saturation 3)
#componet$hydrp - runoff
componet <- IA001.Tabular$component 

muaggart <-IA001.Tabular$muaggatt

mapunit <-IA001.Tabular$mapunit

comonth <- IA001.Tabular$comonth %>% filter(month=="May")
legend<-IA001.Tabular$legend
Overall<- merge(muaggart,componet,by = "mukey", all = TRUE)
Overall<- merge(Overall,mapunit,by = "mukey", all = TRUE)
Overall<- merge(Overall,comonth,by = "cokey", all = TRUE)


chorizon <- IA001.Tabular$chorizon

coerosionacc <- IA001.Tabular$coerosionacc %>%
  filter(rvindicator=="Yes")
Overall<- merge(Overall,coerosionacc,by = "cokey", all = TRUE)



chtexturegrp <-IA001.Tabular$chtexturegrp %>%
  filter(rvindicator == "Yes")
chorizon <- merge(chorizon,chtexturegrp, by = "chkey", all.x=TRUE)

 ##set to Inche
chorzonSim <-chorizon%>%
  mutate(depth = hzdept.r /2.54)%>%
  mutate(depthLevel = ifelse(depth <12,"0-12",ifelse(depth<24, "12-24",ifelse(depth<36,'24-36',"36+"))))


chorzonSim2<- chorzonSim%>%
  filter(depthLevel=="0-12")%>%
  group_by(cokey,depthLevel)%>%
  mutate(soilText= ifelse(depth==0,texdesc,""))%>%
  summarise(ksat = mean(ksat.r,na.rm=TRUE),awc = mean(awc.r, na.rm=TRUE),caco3 = mean(caco3.r,na.rm=TRUE),gypsum= mean(gypsum.r,na.rm=TRUE),sar =mean(sar.r,na.rm=TRUE),ec = mean(ec.r,na.rm=TRUE),cec7= mean(cec7.r,na.rm=TRUE), ph = mean(ph1to1h2o.r,na.rm=TRUE),ph_l = mean(ph1to1h2o.l,na.rm=TRUE),ph_h= mean(ph1to1h2o.h,na.rm=TRUE),om= mean(om.r,na.rm=TRUE),
            ptotal = mean(ptotal.r,na.rm=TRUE),soilTextsum = soilText)%>%
  filter(soilTextsum!="")



##function to  determine which soil texture to use



Overall<- merge(Overall,chorzonSim2,by = "cokey", all = TRUE)


Overall <- Overall %>%
  filter(majcompflag=="Yes")

Simple <- Overall %>%
  select(mukey,cokey,muacres,muname = muname.x,taxorder,compname,slope.r,slopegradwta, slope.l,slope.h,localphase,erokind,erocl,tfact,wei,niccdcd,hydgrp,soilslippot,drainagecl,drclassdcd,niccdcd,awc,aws025wta,aws050wta, flodfreqcl,floddurcl,pondfreqcl,pondfreqprs,flodfreqdcd,flodfreqmax,pondfreqprs,iacornsr,ph,ph_l,ph_h,cec7,gypsum,ksat,ec,sar,caco3,om,ptotal, soilTextdes =soilTextsum, depthLevel)



