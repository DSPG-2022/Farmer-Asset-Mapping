library(ggplot2)
library(FedData)
require(rgdal)

SSURGO.areas <- get_ssurgo(template = "IA001",label = "CO_TEST") #Querty Data from Web Soil Survey

SSURGO.areas.IA001 <- SSURGO.areas$spatial[SSURGO.areas$spatial$AREASYMBOL=='IA001',] #Get spactial Data

NED.IA001  <- get_ned(template=SSURGO.areas.IA001, label='SSURGO_IA001') ##get Elevation elevation data

plot(NED.IA001) #plot elevation

shp <- readOGR(dsn = file.path("C:\\Users\\cornd\\OneDrive\\Documents\\EXTRACTIONS\\CO_TEST\\SSURGO\\CO_TEST_SSURGO_Mapunits.shp"), stringsAsFactors = F)

IA001.Tabular <- SSURGO.areas$tabular
IA001.Spatical <- SSURGO.areas$spatial

ggplot() + geom_polygon(data = OverallSp, aes(x = long, y = lat, group = group), colour = "black", fill = NA)

map2
coclass <- IA001.Tabular$coecoclass
Componet <- IA001.Tabular$component
Mapunit <- IA001.Tabular$mapunit
Overall <- merge(Componet,Mapunit, by.x = "mukey", by.y = "mukey",all.x = TRUE, all.y =TRUE)
Overall <- merge(Overall,shp ,by.x ="musym",by.y ="MUSYM", all.x=TRUE, all.y=TRUE)
OverallSp <- Overall %>%
  distinct()
OverallRed <- Overall %>%
  select(cokey, mukey, muname,geomdesc,compname,slope.l,slope.r,slope.h,farmlndcl)

OverallRedCount <- OverallRed %>%
  group_by(farmlndcl) %>%
  count(geomdesc)


ggplot(OverallRedCount)+
  geom_col(aes(x= geomdesc, y= n))+
  ylab("Count")+
  ylim(ymin=0,ymax=130)+
  xlab("Description of Geometery")+
  labs(title = "Count of Geometetry based on Farm Class In IA001")+
  coord_flip()+
  geom_text(aes(x=geomdesc, y=n,label =n), hjust =-.25, size= 2)+
  facet_wrap(~farmlndcl)
