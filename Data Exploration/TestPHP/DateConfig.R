
Year= 2015
startMonth = 4
EndMonth = 10

CurrentDate <- Sys.Date()-2
StartDates <- list()
EndDates <-list()

EndDay = lubridate::days_in_month(as.Date(paste(EndMonth,"/01/2000",sep="")))

StartMonthCorrect <-format(as.Date(paste(startMonth,"/01/2000",sep=""), "%m/%d/%y"),"%m")
EndMonthCorrect <-format(as.Date(paste(EndMonth,"/01/2000",sep=""), "%m/%d/%y"),"%m")

YearRange = as.numeric(format(CurrentDate,"%Y"))-Year

for(yearVal in 0:YearRange){
  
    
  StartDate = paste(Year+yearVal,"-",StartMonthCorrect,'-',"01",sep="")
  EndDate = paste(Year+yearVal,"-",EndMonthCorrect,"-",EndDay,sep="")
  if(Year+yearVal==as.numeric(format(CurrentDate,"%Y"))){
    EndDate <- format(Sys.Date()-2,"%Y-%m-%d")
  }
  StartDates <-append(StartDates,StartDate)
  EndDates <-append(EndDates,EndDate)
}
knitr::opts_chunk$set(echo = TRUE)

