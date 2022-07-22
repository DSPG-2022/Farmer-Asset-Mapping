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
mydata <- read.csv("2015_2021_clim.csv")


newdata <- read_excel("Input\\Crop-Info_Farmer Asset Mapping.xlsx")

new_data <- newdata[-c(20:38), ] 

new_data <- subset(new_data, select = -c(`Type.of.Irrigation`,`Precipitation`, `X`, `X.1`))

#new_data <- spread(new_data, ï..Types.of.Crops, Base.Temp.in.F)

mydata = subset(mydata, select = -c(`mrms_precip_in`,`prism_precip_in`,`X12z_high_f`,`climate_daily_high_f`,`X12z_low_f`,`climate_daily_low_f`,`daily_precip_in`,`X12z_precip_in`,`climate_daily_precip_in` ) )
mydata$Average_temp = (mydata$daily_high_f + mydata$daily_low_f)/2

mydata$OnionGDD <- mydata$Average_temp - 40

mydata$PeasGDD <- mydata$Average_temp - 39

mydata$AsparagusGDD <- mydata$Average_temp - 50

mydata$PotatoGDD <- mydata$Average_temp - 32

mydata$CabbageGDD <- mydata$Average_temp - 40

mydata$Sweet_PotatoGDD <- mydata$Average_temp - 65

mydata$SquashGDD <- mydata$Average_temp - 60

mydata$CucumberGDD <- mydata$Average_temp - 60

mydata$CauliflowerGDD <- mydata$Average_temp - 40

mydata$PumpkinGDD <- mydata$Average_temp - 60

mydata$TomatoGDD <- mydata$Average_temp - 50

mydata$WatermelonGDD <- mydata$Average_temp - 50

mydata$CarrotGDD <- mydata$Average_temp - 40

mydata$Sweet_cornGDD <- mydata$Average_temp - 50

mydata$LettuceGDD <- mydata$Average_temp - 40

mydata$EggplantGDD <- mydata$Average_temp - 50

mydata$RadishGDD <- mydata$Average_temp - 40

mydata$SpinachGDD <- mydata$Average_temp - 35

mydata$CantaloupeGDD <- mydata$Average_temp - 65

mydata$OnionGDD= ifelse(mydata$OnionGDD < 0, "0", mydata$OnionGDD)
mydata$PeasGDD= ifelse(mydata$PeasGDD < 0, "0",mydata$PeasGDD )
mydata$AsparagusGDD= ifelse(mydata$AsparagusGDD < 0, "0", mydata$AsparagusGDD )
mydata$PotatoGDD= ifelse(mydata$PotatoGDD < 0, "0", mydata$PotatoGDD )
mydata$CabbageGDD= ifelse(mydata$CabbageGDD < 0, "0",mydata$CabbageGDD )
mydata$Sweet_PotatoGDD= ifelse(mydata$Sweet_PotatoGDD < 0, "0",mydata$Sweet_PotatoGDD )
mydata$SquashGDD= ifelse(mydata$SquashGDD < 0, "0",mydata$SquashGDD )
mydata$CucumberGDD= ifelse( mydata$CucumberGDD< 0, "0",mydata$CucumberGDD )
mydata$CauliflowerGDD= ifelse(mydata$CauliflowerGDD < 0, "0", mydata$CauliflowerGDD)
mydata$PumpkinGDD= ifelse(mydata$PumpkinGDD < 0, "0",mydata$PumpkinGDD )
mydata$TomatoGDD= ifelse( mydata$TomatoGDD< 0, "0",mydata$TomatoGDD )
mydata$WatermelonGDD= ifelse(mydata$WatermelonGDD < 0, "0",mydata$WatermelonGDD )
mydata$CarrotGDD= ifelse( mydata$CarrotGDD< 0, "0",mydata$CarrotGDD )
mydata$Sweet_cornGDD= ifelse(mydata$Sweet_cornGDD < 0, "0",mydata$Sweet_cornGDD )
mydata$LettuceGDD= ifelse(mydata$LettuceGDD < 0, "0",mydata$LettuceGDD )
mydata$EggplantGDD= ifelse(mydata$EggplantGDD < 0, "0",mydata$EggplantGDD )
mydata$RadishhGDD= ifelse(mydata$RadishhGDD < 0, "0",mydata$RadishhGDD )
mydata$SpinachGDD= ifelse(mydata$SpinachGDD < 0, "0",mydata$SpinachGDD )
mydata$CantaloupeGDD= ifelse(mydata$CantaloupeGDD < 0, "0",mydata$CantaloupeGDD )


mydata2 <- mydata %>% mutate(Month = substr(date,0,1), year= substr(date, (nchar(date)-3), nchar(date))) %>% mutate(Month = ifelse(Month ==1,10,Month))%>% group_by(year, Month) %>% summarise(acc_gdd_onion= sum(as.numeric(OnionGDD), acc_gdd_peas = sum(as.numeric(PeasGDD)), acc_gdd_asparaguss = sum(as.numeric(AsparagusGDD)), acc_gdd_potato = sum(as.numeric(PotatoGDD)), acc_gdd_cabbage = sum(as.numeric(CabbageGDD)), acc_gdd_sweet_potato = sum(as.numeric(Sweet_PotatoGDD)), acc_gdd_Squash = sum(as.numeric(SquashGDD)), acc_gdd_cucumber = sum(as.numeric(CucumberGDD)), acc_gdd_Cauliflower = sum(as.numeric(CauliflowerGDD)), acc_gdd_Pumpkin = sum(as.numeric(PumpkinGDD)), acc_gdd_Tomato = sum(as.numeric(TomatoGDD)), acc_gdd_Watermelon = sum(as.numeric(WatermelonGDD)), acc_gdd_carrot = sum(as.numeric(CarrotGDD)), acc_gdd_sweet_corn = sum(as.numeric(Sweet_cornGDD)), acc_gdd_lettuce = sum(as.numeric(LettuceGDD)), acc_gdd_Eggplant = sum(as.numeric(EggplantGDD)), acc_gdd_radishh = sum(as.numeric(RadishhGDD)), acc_gdd_spinach = sum(as.numeric(SpinachGDD)), acc_gdd_cantaloupe = sum(as.numeric(CantaloupeGDD)) ))

mydata2<- mydata2 %>%
  mutate(Date = paste(Month,year,sep="/"))

##FIX 
## USE month.name[]
mydata2$Month = ifelse(mydata2$Month == 4,"April",
                       ifelse(mydata2$Month == 5, "May",
                              ifelse(mydata2$Month == 6, "June",
                                     ifelse(mydata2$Month == 7, "July",
                                            ifelse(mydata2$Month == 8, "August",
                                                   ifelse(mydata2$Month == 9, "September",
                                                          ifelse(mydata2$Month == 10,"October", mydata2$Month))))))) 


New = data.frame(month= c("April","May","June","July","Aug","September","October"), acc_onion_gdd= sum())

write.csv(mydata, "Output\\Speciality_Crops_GDD_2015-2021.csv", row.names = FALSE)
