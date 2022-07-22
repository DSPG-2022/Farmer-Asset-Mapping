library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(sqldf)
library(raster)

##NEED SOIL DATA
##NEED LONG/LAT

s <- raster(ncol=2, nrow=2)

ymin(s) <- 42.078433865038505
ymax(s) <- 42.10709506728437
xmin(s) <- -93.85498251613917
xmax(s) <- -93.83524145838685


riskLink <-read.csv("hzrdLinks.csv",header =TRUE)
riskLink

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
