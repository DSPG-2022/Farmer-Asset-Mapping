library(ggplot2)
library(FedData)

SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

IA001.Tabular <- SSURGO.areas$tabular


componet <- IA001.Tabular$component 

cotaxfmmin <- IA001.Tabular$cotaxfmmin
cotaxmoistcl <- IA001.Tabular$cotaxmoistcl #taxmoistcl
cotxfmotherv <-IA001.Tabular$cotxfmother #taxfamother
mapunit <-IA001.Tabular$mapunit

mutext <- IA001.Tabular$legend
