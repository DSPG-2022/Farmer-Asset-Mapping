library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
##Takes in Crop info and List of rotations and combines examples to crops
setwd("C:\\Users\\cornd\\OneDrive\\Documents\\GitHub\\Farmer-Asset-Mapping\\Data Exploration\\Web Projects\\TestPHP")
CropData <- read_excel("Input\\Crop-Info_Farmer Asset Mapping.xlsx")
CropRotation <- read_excel("Sanika-Crop_Rotation.xlsx")

Combined <- merge(CropData,CropRotation, by.x = "Types of Crops", by.y = "Crop", all.x=TRUE )

write.csv(Combined,"Input\\testRotation.csv")
