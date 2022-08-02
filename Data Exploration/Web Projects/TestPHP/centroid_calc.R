# This will let the script know 
args <- commandArgs(TRUE)
 

# Because the data are passed as text, we need to convert them to 
# numbers in order to do our calculations. 
# Before this, the form should validate the input to make sure only
# numbers are being entered & submitted. Validation should not
# happen in the R script. 

xmin <- as.numeric(args[1])
xmax <- as.numeric(args[2])
ymin <- as.numeric(args[3])
ymax <- as.numeric(args[4])
#cat(xmin, xmax, ymin, ymax)

xcenter <- (xmin + xmax) / 2
ycenter <- (ymin + ymax) / 2

cat(xcenter,", ", ycenter)
return = list(xcenter,ycenter)