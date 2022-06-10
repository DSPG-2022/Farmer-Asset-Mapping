library(ggplot2)
library(FedData)


##List of Important Columns
#Keys
  ##mukey, cokey, chkey 
#Data Columns
  ##rupreseblkmst, rupresblkdry, desgnsuffix, ecoclassname , erokind
#Data Tables that have to many columns to list all
  # chfrags - Horizon Fragements - Gives percent of fragements on horizon
  # chorizon - more info about horizon
    #partdensity
    # Has Info like caco (Carbonate as a weight percent)
    # gypsum, Sar(Na relative to CA and Mg)
    # electrical conucticity 
    # cec, phosporous
    # etc
 #cohydriccrietia


SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

SSURGO.areas.IA001 <- SSURGO.areas$spatial[SSURGO.areas$spatial$AREASYMBOL=='IA001',] #Get spactial Data

IA001.Tabular <- SSURGO.areas$tabular  #GetTabular Data

chconsistence <- IA001.Tabular$chconsistence
chdesgnsuffic <- IA001.Tabular$chdesgnsuffix
chfrags <- IA001.Tabular$chfrags
chorizon <- IA001.Tabular$chorizon
chstruct <- IA001.Tabular$chstruct
chstructgrp <- IA001.Tabular$chstructgrp

coecoclass <- IA001.Tabular$coecoclass ##ecoloigal names

coerosionacc <- IA001.Tabular$coerosionacc ##erosion

cohydriccrietia <- IA001.Tabular$cohydriccriteria  #might be useful - hrydric classifcation criteria

cointerp <- IA001.Tabular$cointerp ##Could be interesting

comonth <- IA001.Tabular$comonth ##Ponds -Has Flood frequency about ponds

componet <- IA001.Tabular$component 
  ##componet Data 
    #Slope
    #Runoff , runoff (potential), wei (tons/acre/year soil loss by wind - From WEG), tfact - soil loss tolerance factor
    #localphase could be used with compname to identify soil component
    #weg - see runoff
    #erosion - erocl - 1997NRCS classification
coclass <- IA001.Tabular$coecoclass
Mapunit <- IA001.Tabular$mapunit
Overall <- merge(Componet,Mapunit, by.x = "mukey", by.y = "mukey",all.x = TRUE, all.y =TRUE)

OverallRed <- Overall %>%
  select(cokey, mukey, muname,geomdesc,compname,slope.l,slope.r,slope.h,farmlndcl)

OverallRedCount <- OverallRed %>%
  group_by(farmlndcl) %>%
  count(geomdesc)


ggplot(OverallRedCount)+
  geom_col(aes(x= geomdesc, y= n))+
  ylab("Count")+
  xlab("Description of Geometery")+
  labs(title = "Count of Geometetry based on Farm Class")+
  coord_flip()+
  facet_wrap(~farmlndcl)
