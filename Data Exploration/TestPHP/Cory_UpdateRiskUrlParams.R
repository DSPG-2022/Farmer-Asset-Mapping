library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)
library(raster)
##Updates the Parameters Column of hzrdlinks csv so that when they use links, it pops up with information relevant to their location

riskLink <-read.csv("hzrdLinks.csv",header =TRUE)

##FLOOD FEMA MAP 1

value = paste("&extent=",s@extent@xmin,sep="")
value= paste(value,s@extent@ymin,sep=',')
value= paste(value,s@extent@xmax,sep=',')
value= paste(value,s@extent@ymax,sep=',')
riskLink[1,4]<-value

##FLOOD FEMA Home 2
value =paste("?AddressQuery=",s@extent@xmin,sep="")
value= paste(value,s@extent@ymin,sep=',')
riskLink[2,4]<-value

##Drought Drought Monitor 3

value =paste("?",StateAbv,sep="")
riskLink[3,4]<-value
## Hazard Risk FEMA 4
##HAS no parameters so use end of url to make it work
value = "nri"
riskLink[4,4]<-value

## Haxard Risk Fema Report 5
value =paste("?dataLOD=Counties&dataIDS=C",Statefips, sep="")
riskLink[5,4]<-value

##CLimate mapper Climate Toolbax 6
##excahnge for center values
value =paste("?mapZoom=10&mapCenterLat=",s@extent@ymin,sep="")
value= paste(value,"&mapCenterLon=",sep='')
value= paste(value,s@extent@xmin,sep='')
riskLink[6,4]<-value


write.csv(riskLink,"hzrdLinks.csv",row.names = FALSE)
