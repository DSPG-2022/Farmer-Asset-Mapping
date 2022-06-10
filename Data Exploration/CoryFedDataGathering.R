library(ggplot2)
library(FedData)


##List of Important Columns
#Keys
  ##mukey, cokey, chkey ,lkey



SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

SSURGO.areas.IA001 <- SSURGO.areas$spatial[SSURGO.areas$spatial$AREASYMBOL=='IA001',] #Get spactial Data

IA001.Tabular <- SSURGO.areas$tabular  #GetTabular Data

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
    #erosion - erocl -see image for desc
    #hydricrating - used to indacte hydric soil
    #drainagecl, elevation
    #geomdesc -Component Geomorphic Description table.
    #average air temp - might be outdated
    #map -  precipiation data - like average air - no labels
    #ffd - expected days between last ffreezing in spring and first freezing in fall
    #cropprodindex - used to capacity of soil to produce spefic plant - could be explored
    #wlgrain - sutablity of soil to produce wildlife grain - all NA's - have for alot of wildlife
    #frostact - interpretation of susceptibility of the soil to frost heaving
    #initsub - decrease in surface elevation due to 3 years of drainage ...
    #hydgrp - runoff potential under simiar storm condition (NSSH)
    #corcon - corsteel - susceptiility to corrosion when touch soil
    #taxclname - concatenation of the Soil Taxonomy subgroup and family for a soil
    #taxorder - naming of soil


copm <- IA001.Tabular$copm #soil parent info
  #pmmodifier - general description of texture of parent material. Soil Survey Manual and Soil Taxonomy
copmgrp <- IA001.Tabular$copmgrp #concat of table above

corestriction <- IA001.Tabular$corestrictions #resking - restrictions of water movement

cosoilmoist <- IA001.Tabular$cosoilmoist #soil moisture data
  #soimoistdept - depth - top to upper boundary of moisture layer
  #soimoststat - mean monthly soil water state
  #Componet Soil Moisture Table

cosoiltemp #no table for this county but supposed to have soil temp - use IEM probably

cogeomordesc<- IA001.Tabular$cogeomordesc #Extra Geom Data
#cogeomdkey
cosurfmorphhpp <- IA001.Tabular$cosurfmorphhpp #geopgraphic data
cosurfmorphgc <- IA001.Tabular$cosurfmorphgc #geom data
cosurfmorphmr <- IA001.Tabular$cosurfmorphmr #geomm data

cotaxfmmin <- IA001.Tabular$cotaxfmmin #taxminalogy -SOil Taxonomy
cotaxmoistcl <- IA001.Tabular$cotaxmoistcl #taxmoistcl
cotxfmotherv <-IA001.Tabular$cotxfmother #taxfamother

cotext <- IA001.Tabular$cotext # text - text entries with date as recdate

distinterpmd <- IA001.Tabular$distinterpmd #rule interpretations name and descr and time

distlegendmd <-IA001.Tabular$distlegendmd #data for legend
  #cordate 


featdesc <- IA001.Tabular$featdesc

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
