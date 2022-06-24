library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)

TempData <-read.csv("2015_2021_clim.csv")
NewData <- data.frame()
 
TempData2 <- TempData %>%
  mutate(Month = substr(date,0,1), year = substr(date,(nchar(date)-3),nchar(date)))%>%
  mutate(Month = ifelse(Month ==1,10,Month))%>%
  group_by(year,Month)%>%
  summarise(AverageTempH = mean(daily_high_f),AverageTempL = mean(daily_low_f),SumPrecip = sum(prism_precip_in), SumClimPrecip = sum(climate_daily_precip_in))
TempData2<- TempData2 %>%
  mutate(Date = paste(Month,year,sep="/"))

write.csv(TempData2,"aggClimData.csv")

         