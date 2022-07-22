library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
setwd("C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP")
TempData <-read.csv("Output\\WeatherData.csv")

TempData2 <- TempData %>%
  mutate(Month = as.numeric(substr(data.date,6,7)), year = substr(data.date,0,4))%>%
  group_by(year,Month)%>%
  summarise(AverageTempH = mean(data.daily_high_f),AverageTempL = mean(data.daily_low_f),
            SumPrecip = sum(data.prism_precip_in), SumClimPrecip = sum(data.climate_daily_precip_in))
TempData2<- TempData2 %>%
  mutate(Date = paste(Month,year,sep="/"))

write.csv(TempData2,"Output\\aggClimData.csv")

         