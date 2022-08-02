# This will let the script know 
args <- commandArgs(TRUE)


setwd("C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\TestPHP")

##Inputs from PHP
Year= as.numeric(args[1])
startMonthName = args[2]
EndMonthName = args[3]
lat = as.numeric(args[4])
lon= as.numeric(args[5])

##Finds month number according to its name
startMonth <- match(startMonthName, month.name)
EndMonth <- match(EndMonthName,month.name)

##Finds current Date
CurrentDate <- Sys.Date()-2
StartDates <- list()
EndDates <-list()

##finds the number of days in the end month given
EndDay = lubridate::days_in_month(as.Date(paste("2000/",EndMonth,"/01",sep="")))

##format the start month correctly
StartMonthCorrect <-format(as.Date(paste(startMonth,"/01/2000",sep=""), "%m/%d/%y"),"%m")
EndMonthCorrect <-format(as.Date(paste(EndMonth,"/01/2000",sep=""), "%m/%d/%y"),"%m")

##finds number of years between current year and selected year
YearRange = as.numeric(format(CurrentDate,"%Y"))-Year

for(yearVal in 0:YearRange){
  
  ##Formats correct Year input based on year, month,day
  StartDate = paste(Year+yearVal,"-",StartMonthCorrect,'-',"01",sep="")
  EndDate = paste(Year+yearVal,"-",EndMonthCorrect,"-",EndDay,sep="")
  
  ##end date will be current day
  if(Year+yearVal==as.numeric(format(CurrentDate,"%Y"))){
    EndDate <- format(Sys.Date()-2,"%Y-%m-%d")
  }
  
  ##appends to list of dates
  StartDates <-append(StartDates,StartDate)
  EndDates <-append(EndDates,EndDate)
}


library(ncdf4) 
library(raster)
library(tidyverse)
library(jsonlite)
library(httr)
library(rlist)
library(lubridate)
library(urltools)
library(rgdal)
library(maps)
library(mapdata)
library(sp)
library(rgeos)
library ("geosphere")


##part of url for websraping
base_url <- "https://mesonet.agron.iastate.edu/iemre/"
target_request <- "multiday/"
end_of_url <- "json"

#Create empty list to store url's
url_list <-list()

#Loop through the start and end dates. First date is the start date, second date is the end date. Dates are paired.
#url format is: https://mesonet.agron.iastate.edu/iemre/multiday/start_dates/end_dates/lat/lon/json

#Create empty dataframe
df <- data.frame()

##Scrapes Data for correct time length and adds to df
for (i in 1:length(StartDates)) {
  
  url <- paste0(base_url, target_request, StartDates[i], "/", EndDates[i], "/", lat, "/", lon, "/", end_of_url)
  url_list <- c(url_list, url)
  print(url) 
  data <- as.data.frame(jsonlite::fromJSON(url))
  df <- rbind(df,data)
  
}


write.csv(df,"Output\\WeatherData.csv")
