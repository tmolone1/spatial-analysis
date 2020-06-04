# cleanup
rm(list=ls())
load("df_all.Rda")
library(sp)
library(readr)
library(raster)
library(rgdal)
library(rgeos)
library(gstat)
shp<-"M:/Chevron/Sunburst/GIS/Projects/FeasibilityStudyReports/NSZD/Data/Benzene_DecayRate_Data.shp"
shp<-m
Wells_points <- SpatialPointsDataFrame(df_all[,2:3], 
                                       data= df_all,
                                       proj4string = CRS("+init=ESRI:102700")) # montana state plane NAD83

# setup a grid for interpolations
grd <- as.data.frame(spsample(Wells_points, "regular", n=50000))
names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object
# Add Wells_points's projection information to the empty grid
plot(grd)
points(Wells_points)

#select data to interpolate
interp<-readOGR(shp)
interp<-shp
interp$model_value<-interp$Decay
interp$model_value<-shp$`Slope Estimate (Yr-1)`
proj4string(grd) <- proj4string(interp)

#Log_Transform
pre_log_shift<-(abs(min(interp$model_value)))
interp$model_value<-interp$model_value+pre_log_shift
interp$model_value<-log(interp$model_value, base=10)

# interpolation, idw
idw <- gstat::idw(model_value ~ 1, interp, newdata=grd, idp=2)
idw <-raster(idw)
idw<-10^(idw)-pre_log_shift
plot(idw)

proj4string(idw) <- proj4string(interp)

#idw_for_ndcontour<-idw
points(interp, colours = interp$model_value)
contour(idw, levels=-0.00002, add=TRUE)
idw_for_ndcontour<-(idw_for_ndcontour>0.005)*idw_for_ndcontour # clip to extent of > 0.005
interp$model_value <- 10^(interp$model_value)-pre_log_shift

#### write outputs
writeRaster(idw, filename="idwbenzdecay.grd", format="GTiff", overwrite=TRUE)
