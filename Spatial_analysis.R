rm(list=ls())
library(sp)
library(rgdal)
library(rgeos)
library(raster)
load("map_effsols.Rda")
load("df_all.Rda")
Wells_points <- SpatialPointsDataFrame(df_all[,2:3], 
                                       data= df_all,
                                       proj4string = CRS("+init=ESRI:102700")) # montana state plane NAD83
Wells_points[zerodist(Wells_points)[,1],] # Prints duplicates, should be 0 features

#create Grid
grd <- as.data.frame(spsample(Wells_points, "regular", n=50000))
names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object
# Add Wells_points's projection information to the empty grid
proj4string(grd) <- proj4string(Wells_points)
polys<-as.SpatialPolygons.GridTopology(getGridTopology(grd),proj4string = CRS("+init=ESRI:102700"))
grd_points<-getSpatialPolygonsLabelPoints(polys)
proj4string(grd_points) <- proj4string(Wells_points)
plot(grd)
points(Wells_points)

# dpgi3
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/dpgi3.tif")
newproj <- CRS("+init=ESRI:102700")
r.transform <- projectRaster(r, crs=newproj) 
grd_points$geocem_idx<-extract(r,grd_points)
rm(r)
rm(r.transform)
# K_est
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/K_est.tif")
r.transform <- projectRaster(r, crs=newproj) 
grd_points$K_est<-extract(r,grd_points)
rm(r)
rm(r.transform)
# ws_benz
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/ws_benz.tif")
r.transform <- projectRaster(r, crs=newproj) 
grd_points$ws_benz<-extract(r,grd_points)
rm(r)
rm(r.transform)
# top_ws
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/top_ws.tif")
proj4string(r) <- proj4string(Wells_points)
grd_points$top_ws<-extract(r,grd_points)
rm(r)
# as_benz
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/as_benz.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$as_benz<-extract(r,grd_points)
rm(r)
# benz_decay2
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idwbenzdecay.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$benz_decay<-extract(r,grd_points)
rm(r)
# co2flux3
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_co2flux.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$co2flux<-extract(r,grd_points)
rm(r)
# cs_benz
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/cs_benz.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$cs_benz<-extract(r,grd_points)
rm(r)
# depth2water
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/depth2water.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$depth2water<-extract(r,grd_points)
rm(r)
# dis_tph2
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/dis_tph2.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$GWtphconc<-extract(r,grd_points)
rm(r)
# ground
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/ground.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$ground<-extract(r,grd_points)
rm(r)
# Idw_shp1
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_benzMF.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$soilnplbmf<-extract(r,grd_points)
rm(r)
# Molecular Weight of TPH in Soil
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idwsoiltphmw.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$soil_tphmw<-extract(r,grd_points)
rm(r)
# lnapltrans
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/lnapltrans.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnapltrans<-extract(r,grd_points)
rm(r)
# prod_class
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/prod_class.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$prod_class<-extract(r,grd_points)
rm(r)
## Alternate version hydraulic gradient
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/MergedPotsurface.grd")
proj4string(r)<-proj4string(Wells_points)
grad_rads<-terrain(r, opt="slope", unit="radians", neighbors=8)
hydr_grad<-tan(grad_rads)
writeRaster(hydr_grad, filename="hydr_grad", format="GTiff", overwrite=TRUE)
grd_points$hydr_grad<-extract(hydr_grad,grd_points)
# relativeperm
grd_points$rel_perm<-(1/(grd_points$prod_class*grd_points$hydr_grad))
## K_est
p2ri45<-Wells_points[Wells_points$Location=="P2RI-45E",c("X","Y")]
r <- rasterFromXYZ(data.frame(cbind(grd_points@coords,grd_points$rel_perm)))
writeRaster(r, filename="rel_perm", format="GTiff", overwrite=TRUE)
p2ri45$perm<-extract(r,p2ri45)
grd_points$K_est<-grd_points$rel_perm/p2ri45$perm*3.5
r <- rasterFromXYZ(data.frame(cbind(grd_points@coords,grd_points$K_est)))
p2ri45$K_est<-extract(r,p2ri45)
writeRaster(r, filename="K_est2", format="GTiff", overwrite=TRUE)
# soil_tph
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_soil_tph.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$soil_tph<-extract(r,grd_points)
rm(r)
# sum3hsu
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/sum3hsu.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$sum3hsu<-extract(r,grd_points)
rm(r)
# gwdarcyvel
grd_points$gwdarcyvel<-grd_points$K_est*grd_points$hydr_grad
# top_cs
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/top_cs.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$top_cs<-extract(r,grd_points)
rm(r)
# idw_LNAPL_median_thick_2019_deep
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_LNAPL_median_thick_2019_deep.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnplthicdeep<-extract(r,grd_points)
rm(r)
# idw_LNAPL_median_thick_2019_shallow
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_LNAPL_median_thick_2019_shallow.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnplthicshlw<-extract(r,grd_points)
rm(r)
# idw_LNAPL_pers_2019_deep
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_LNAPL_pers_2019_deep.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnplpersdeep<-extract(r,grd_points)
rm(r)
# idw_LNAPL_pers_2019_shallow
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_LNAPL_pers_2019_shallow.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnplpersshlw<-extract(r,grd_points)
rm(r)
# idw_LNAPL_pers_2019_shallow
r<- raster("C:/Users/tmoloney/OneDrive - Trihydro/Projects/CVX - Sunburst/Data/Spatial_Analysis/idw_LNAPL_pers_2019_shallow.tif")
r.transform <- projectRaster(r, crs=newproj) 
#proj4string(r) <- proj4string(Wells_points)
grd_points$lnplpersshlw<-extract(r,grd_points)
rm(r)
# depth_ws
grd_points$depth_ws<-grd_points$ground-grd_points$top_ws
# depth_cs
grd_points$depth_cs<-grd_points$ground-grd_points$top_cs
# Yrs Benzene longevity
grd_points$ws_bz_yrs<-(0.005-grd_points$ws_benz)/grd_points$benz_decay/365.25
grd_points$as_bz_yrs<-(0.005-grd_points$as_benz)/grd_points$benz_decay/365.25
grd_points$cs_bz_yrs<-(0.005-grd_points$cs_benz)/grd_points$benz_decay/365.25
#
df<-as.data.frame(grd_points@data)
row.names(df) <- getSpPPolygonsIDSlots(polys)
# Make spatial polygon data frame
spdf <- SpatialPolygonsDataFrame(polys, data =df)
writeOGR(spdf, dsn = getwd(), layer = "SpatialAnalysisGrid_polys", driver = "ESRI Shapefile", overwrite_layer=TRUE)
writeOGR(grd_points, dsn = getwd(), layer = "SpatialAnalysisGrid_pts", driver = "ESRI Shapefile", overwrite_layer=TRUE)
