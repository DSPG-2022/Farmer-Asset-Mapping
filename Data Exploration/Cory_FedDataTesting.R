library(ggplot2)
library(FedData)

SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

SSURGO.areas.IA001 <- SSURGO.areas$spatial[SSURGO.areas$spatial$AREASYMBOL=='IA001',] #Get spactial Data

NED.IA001  <- get_ned(template=SSURGO.areas.IA001, label='SSURGO_IA001') ##get Elevation elevation data

plot(NED.IA001) #plot elevation



IA001.Tabular <- SSURGO.areas$tabular



coclass <- IA001.Tabular$coecoclass
Componet <- IA001.Tabular$component
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
