library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
library(rgdal)


##Area of Selection
t <- raster(ncol=2, nrow=2)

ymin(t) <- 42.84894696045697
ymax(t) <- 42.87652608303261
xmin(t) <- -92.97595243970417
xmax(t) <- -92.94013998546687

#42.87652608303261, -92.97595243970417
#42.87635998062507, -92.94013998546687
#42.84894696045697, -92.94081996877516
#v42.84761753494782, -92.97481913419033

#Gather Data from Web Soil Survey
TestArea<- get_ssurgo(template = t,label = "CropSelectionTest")

##selecting the important Tabl
AreaTabular <- TestArea$tabular
sp <- TestArea$spatial
df <- AreaTabular$mapunit %>%
  mutate(MUKEY = mukey)
componet<-TestArea$tabular$component
df<-merge(df,componet,by= "mukey")
by  ="MUKEY"
sp@data = data.frame(sp@data, df[match(sp@data[,by], df[,by]),])

writeOGR(obj=sp, dsn="tempdir",layer = "map" ,driver="ESRI Shapefile")
