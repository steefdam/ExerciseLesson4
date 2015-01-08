# Janna Jilesen & Stefan van Dam
# 8 January 2015
# Exercise Lesson 4

# Loading Packages
library(raster)

# Image LC81970242014109-SC20141230042441.tar.gz is taken on the 109th day of 2014.
# This corresponds with 19 April 2014
# Image LT51980241990098-SC20150107121947.tar.gz is taken on the 98th day of 1990.
# This corresponds with 8 April 2014

# 1st step: Download the files (manually)

# 2nd step: Untar() (manualy)

# 3rd step: List the layers and extract the RED and NIR layers
listL8 <- list.files(path='data/LC81970242014109', pattern = glob2rx('*.tif'), full.names=TRUE)
listL5 <- list.files(path='data/LT51980241990098', pattern = glob2rx('*.tif'), full.names=TRUE)

REDL8 <- raster(listL8[5])
NIRL8 <- raster(listL8[6])
REDL5 <- raster(listL5[6])
NIRL5 <- raster(listL5[7])

# 4th step: Calculate NDVI of both files
source('R/ndvOver.R')
NDVIL8 <- overlay(x=REDL8, y=NIRL8, fun=ndvOver)
plot('NDVIL8')
NDVIL5 <- overlay(x=REDL5, y=NIRL5, fun=ndvOver)
plot('NDVIL5')

# 5th step: Remove clouds
cloudmaskL8 <- raster(listL8[1])
cloudmaskL5 <- raster(listL5[1])
source('R/cloud2NA.R')
cfNDVIL8 <- overlay(x = NDVIL8, y = cloudmaskL8, fun = cloud2NA)
cfNDVIL5 <- overlay(x = NDVIL5, y = cloudmaskL5, fun = cloud2NA)

# 6th step: Attain same extent
source('R/sameExtent.R')
sameExtentL8<-sameExtent(cfNDVIL8,cfNDVIL5)
sameExtentL5<-sameExtent(cfNDVIL5,cfNDVIL8)

# 7th step: Calculate difference
NDVIDifference <- sameExtentL8 - sameExtentL5
plot('NDVIDifference')