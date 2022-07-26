###NEED TO SET WD


knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(tidyr)
library(tidyverse)
library(tidycensus)
library(dplyr)
library(ggplot2)
library(readxl)


setwd("C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP")
mydata <- read.csv("Output\\WeatherData.csv")


newdata <- read_excel("Input\\Crop-Info_Farmer Asset Mapping.xlsx")



#new_data <- spread(new_data, ï..Types.of.Crops, Base.Temp.in.F)

mydata = subset(mydata, select = -c(`data.mrms_precip_in`,`data.prism_precip_in`,`data.12z_high_f`,`data.climate_daily_high_f`,`data.12z_low_f`,`data.climate_daily_low_f`,`data.daily_precip_in`,`data.12z_precip_in`,`data.climate_daily_precip_in` ) )
mydata<- mydata%>%
  group_by((data.date))%>%
  mutate(Average_temp = (data.daily_high_f + data.daily_low_f)/2)%>%
  mutate(OnionGDD = Average_temp - 40)%>%
  mutate(PeasGDD =Average_temp - 39)%>%
  mutate(AsparagusGDD= Average_temp - 50,PotatoGDD =Average_temp - 32 , CabbageGDD =Average_temp - 40, Sweet_PotatoGDD =Average_temp - 65
,SquashGDD = Average_temp - 60,CucumberGDD = Average_temp - 60,CauliflowerGDD =Average_temp - 40
,PumpkinGDD = Average_temp - 60,TomatoGDD = Average_temp - 50, WatermelonGDD = Average_temp - 50, CarrotGDD =Average_temp - 40,Sweet_cornGDD = Average_temp - 50,
LettuceGDD = Average_temp - 40
,EggplantGDD = Average_temp - 50
,RadishGDD = Average_temp - 40,
SpinachGDD = Average_temp - 35,
CantaloupeGDD = Average_temp - 65)


mydata$OnionGDD= ifelse(mydata$OnionGDD < 0, 0, mydata$OnionGDD)
mydata$PeasGDD= ifelse(mydata$PeasGDD < 0, 0,mydata$PeasGDD )
mydata$AsparagusGDD= ifelse(mydata$AsparagusGDD < 0, 0, mydata$AsparagusGDD )
mydata$PotatoGDD= ifelse(mydata$PotatoGDD < 0, 0, mydata$PotatoGDD )
mydata$CabbageGDD= ifelse(mydata$CabbageGDD < 0, 0,mydata$CabbageGDD )
mydata$Sweet_PotatoGDD= ifelse(mydata$Sweet_PotatoGDD < 0, 0,mydata$Sweet_PotatoGDD )
mydata$SquashGDD= ifelse(mydata$SquashGDD < 0, 0,mydata$SquashGDD )
mydata$CucumberGDD= ifelse( mydata$CucumberGDD< 0, 0,mydata$CucumberGDD )
mydata$CauliflowerGDD= ifelse(mydata$CauliflowerGDD < 0, 0, mydata$CauliflowerGDD)
mydata$PumpkinGDD= ifelse(mydata$PumpkinGDD < 0, 0,mydata$PumpkinGDD )
mydata$TomatoGDD= ifelse( mydata$TomatoGDD< 0,0,mydata$TomatoGDD )
mydata$WatermelonGDD= ifelse(mydata$WatermelonGDD < 0,0,mydata$WatermelonGDD )
mydata$CarrotGDD= ifelse( mydata$CarrotGDD< 0,0,mydata$CarrotGDD )
mydata$Sweet_cornGDD= ifelse(mydata$Sweet_cornGDD < 0, 0,mydata$Sweet_cornGDD )
mydata$LettuceGDD= ifelse(mydata$LettuceGDD < 0,0,mydata$LettuceGDD )
mydata$EggplantGDD= ifelse(mydata$EggplantGDD < 0,0,mydata$EggplantGDD )
mydata$RadishGDD= ifelse(mydata$RadishGDD < 0,0,mydata$RadishGDD )
mydata$SpinachGDD= ifelse(mydata$SpinachGDD < 0, 0,mydata$SpinachGDD )
mydata$CantaloupeGDD= ifelse(mydata$CantaloupeGDD < 0, 0,mydata$CantaloupeGDD )


mydata2 <- mydata %>% mutate(Month = substr(data.date,6,7), year= substr(data.date, 0, 4)) %>% group_by(year, Month) %>% summarise(acc_gdd_onion= sum(as.numeric(OnionGDD)), acc_gdd_peas = sum(as.numeric(PeasGDD)), acc_gdd_asparaguss = sum(as.numeric(AsparagusGDD)), acc_gdd_potato = sum(as.numeric(PotatoGDD)), acc_gdd_cabbage = sum(as.numeric(CabbageGDD)), acc_gdd_sweet_potato = sum(as.numeric(Sweet_PotatoGDD)), acc_gdd_Squash = sum(as.numeric(SquashGDD)), acc_gdd_cucumber = sum(as.numeric(CucumberGDD)), acc_gdd_Cauliflower = sum(as.numeric(CauliflowerGDD)), acc_gdd_Pumpkin = sum(as.numeric(PumpkinGDD)), acc_gdd_Tomato = sum(as.numeric(TomatoGDD)), acc_gdd_Watermelon = sum(as.numeric(WatermelonGDD)), acc_gdd_carrot = sum(as.numeric(CarrotGDD)), acc_gdd_sweet_corn = sum(as.numeric(Sweet_cornGDD)), acc_gdd_lettuce = sum(as.numeric(LettuceGDD)), acc_gdd_Eggplant = sum(as.numeric(EggplantGDD)), acc_gdd_radish = sum(as.numeric(RadishGDD)), acc_gdd_spinach = sum(as.numeric(SpinachGDD)), acc_gdd_cantaloupe = sum(as.numeric(CantaloupeGDD)))

mydata2<- mydata2 %>%
  mutate(Date = paste(Month,year,sep="/"))%>%
  mutate(MonthName = month.name[as.numeric(Month)])
##FIX 
## USE month.name[]



write.csv(mydata, "Output\\Speciality_Crops_GDD_2015-2021.csv", row.names = FALSE)

data2<-mydata2%>%
  group_by(data.date)%>%
  mutate(year = substr(data.date,0,4),Month=month.name[as.numeric(substr(data.date,6,7))])%>%
  ungroup%>%
  select(year,Month,everything())%>%
  select(-X,-data.date)%>%
  select(-3,-4,-5,-6)%>%
  pivot_longer(3:ncol(data2))
data3<-data2%>%
  group_by(year,Month,name)%>%
  summarise(value= sum(value))
data3<-data3%>%
  select(year,Month,Crops=name,value)
data3<-data3%>%
  mutate(Crops= substr(Crops,0,nchar(Crops)-3))
write.csv(data3,"Output\\Formatted_gdd.csv",row.names = FALSE)
