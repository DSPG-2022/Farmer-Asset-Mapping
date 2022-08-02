knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(tidyr)
library(tidyverse)
library(tidycensus)
library(dplyr)
library(ggplot2)
library(readxl)

##Sets correct Working Directory
setwd("C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\Web Projects\\TestPHP")

##Raw Weather Data
mydata <- read.csv("Output\\WeatherData.csv")

##Crop Info
newdata <- read_excel("Input\\Crop-Info_Farmer Asset Mapping.xlsx")



##Removes unwanted Data from Weather Data
mydata = subset(mydata, select = -c(`data.mrms_precip_in`,`data.prism_precip_in`,`data.12z_high_f`,`data.climate_daily_high_f`,`data.12z_low_f`,`data.climate_daily_low_f`,`data.daily_precip_in`,`data.12z_precip_in`,`data.climate_daily_precip_in` ) )

##Creates new Data, based on Crop's base growing temp and average_temp for day
####CHANGE would like to add these values to Crop dataset to make it easier to add new crops
mydata<- mydata%>%
  group_by((data.date))%>%
  mutate(Average_temp = (data.daily_high_f + data.daily_low_f)/2)%>%
  mutate(OnionGDD = Average_temp - 40)%>%
  mutate(PeasGDD =Average_temp - 39)%>%
  mutate(AsparagusGDD= Average_temp - 50,PotatoGDD =Average_temp - 32 , CabbageGDD =Average_temp - 40, `Sweet PotatoGDD` =Average_temp - 65
,SquashGDD = Average_temp - 60,CucumberGDD = Average_temp - 60,CauliflowerGDD =Average_temp - 40
,PumpkinGDD = Average_temp - 60,TomatoGDD = Average_temp - 50, WatermelonGDD = Average_temp - 50, CarrotGDD =Average_temp - 40,`Sweet CornGDD` = Average_temp - 50,
LettuceGDD = Average_temp - 40
,EggplantGDD = Average_temp - 50
,RadishGDD = Average_temp - 40,OatsGDD = Average_temp - 40,
SpinachGDD = Average_temp - 35,
CantaloupeGDD = Average_temp - 65)


##ReLU
##GDD cannot be negative, so anyvalue below 0 is assigned to 0
mydata$OatsGDD= ifelse(mydata$OatsGDD < 0, 0, mydata$OatsGDD)
mydata$OnionGDD= ifelse(mydata$OnionGDD < 0, 0, mydata$OnionGDD)
mydata$PeasGDD= ifelse(mydata$PeasGDD < 0, 0,mydata$PeasGDD )
mydata$AsparagusGDD= ifelse(mydata$AsparagusGDD < 0, 0, mydata$AsparagusGDD )
mydata$PotatoGDD= ifelse(mydata$PotatoGDD < 0, 0, mydata$PotatoGDD )
mydata$CabbageGDD= ifelse(mydata$CabbageGDD < 0, 0,mydata$CabbageGDD )
mydata$`Sweet PotatoGDD`= ifelse(mydata$`Sweet PotatoGDD` < 0, 0,mydata$`Sweet PotatoGDD` )
mydata$SquashGDD= ifelse(mydata$SquashGDD < 0, 0,mydata$SquashGDD )
mydata$CucumberGDD= ifelse( mydata$CucumberGDD< 0, 0,mydata$CucumberGDD )
mydata$CauliflowerGDD= ifelse(mydata$CauliflowerGDD < 0, 0, mydata$CauliflowerGDD)
mydata$PumpkinGDD= ifelse(mydata$PumpkinGDD < 0, 0,mydata$PumpkinGDD )
mydata$TomatoGDD= ifelse( mydata$TomatoGDD< 0,0,mydata$TomatoGDD )
mydata$WatermelonGDD= ifelse(mydata$WatermelonGDD < 0,0,mydata$WatermelonGDD )
mydata$CarrotGDD= ifelse( mydata$CarrotGDD< 0,0,mydata$CarrotGDD )
mydata$`Sweet CornGDD`= ifelse(mydata$`Sweet CornGDD` < 0, 0,mydata$`Sweet CornGDD`)
mydata$LettuceGDD= ifelse(mydata$LettuceGDD < 0,0,mydata$LettuceGDD )
mydata$EggplantGDD= ifelse(mydata$EggplantGDD < 0,0,mydata$EggplantGDD )
mydata$RadishGDD= ifelse(mydata$RadishGDD < 0,0,mydata$RadishGDD )
mydata$SpinachGDD= ifelse(mydata$SpinachGDD < 0, 0,mydata$SpinachGDD )
mydata$CantaloupeGDD= ifelse(mydata$CantaloupeGDD < 0, 0,mydata$CantaloupeGDD )

data2<- mydata %>%
  group_by(data.date)%>%
  mutate(year = substr(data.date,0,4),Month=month.name[as.numeric(substr(data.date,6,7))])%>%
  ungroup%>%
  ##Reformat to nice order and remove unneeded Columns
  select(year,Month,everything())%>%
  select(-X,-data.date)%>%
  select(-3,-4,-5,-6)
data2<- data2%>%
  pivot_longer(3:ncol(data2))
data3<-data2%>%
  group_by(year,Month,name)%>%
  summarise(value= sum(value))

##Formats to match Tableau
data3<-data3%>%
  select(year,Month,Crops=name,value)
data3<-data3%>%
  mutate(Crops= substr(Crops,0,nchar(Crops)-3))


##Saves Raw Data
write.csv(mydata, "Output\\Speciality_Crops_GDD_2015-2021.csv", row.names = FALSE)

##Takes Everyday and Aggregates the values by month/year


##Saves to CSV
write.csv(data3,"Output\\Formatted_gdd.csv",row.names = FALSE)
