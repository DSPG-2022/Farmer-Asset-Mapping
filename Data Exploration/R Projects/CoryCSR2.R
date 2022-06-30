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
#componet$erocl
#componet$localphase
#componettfact
#componet$wei
#componet$taxorder
#componet$compname
#componet$drainagecl
#componet$soilslipot ##possibily that mass of soil will slip when 1)veg is removed 2)soil water near saturation 3)
#componet$hydrp - runoff
componet <- IA001.Tabular$component 

muaggart <-IA001.Tabular$muaggatt

mapunit <-IA001.Tabular$mapunit

Overall<- merge(muaggart,componet,by = "mukey", all = TRUE)
Overall<- merge(Overall,mapunit,by = "mukey", all = TRUE)

Overall <- Overall %>%
  filter(majcompflag=="Yes")
Simple <- Overall %>%
  select(mukey,cokey,muname,taxorder,compname)

cotaxfmmin <- IA001.Tabular$cotaxfmmin
cotaxmoistcl <- IA001.Tabular$cotaxmoistcl #taxmoistcl
cotxfmotherv <-IA001.Tabular$cotxfmother #taxfamother

