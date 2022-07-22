library(ggplot2)
library(FedData)
library(raster)
library(readxl)
library(dplyr)
library(tidyr)
##Takes in Crop info and List of rotations and combines examples to crops 

CropData <- read_excel("Crop-Info_Farmer Asset Mapping.xlsx")
CropRotation <- read_excel("Sanika-Crop_Rotation.xlsx")

Combined <- merge(CropData,CropRotation, by.x = "Types of Crops", by.y = "Crop", all.x=TRUE )

write.csv(Combined,"testRotation.csv")
