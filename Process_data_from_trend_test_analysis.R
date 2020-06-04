load("df_all.Rda")
library(readr)
trend_data<-read_csv("Trend_test_analysis.csv")
trend_data<-merge(trend_data,df_all[,1:3], by="Location")
shp <- SpatialPointsDataFrame(trend_data[,c("X","Y")], 
                                       data= trend_data,
                                       proj4string = CRS("+init=ESRI:102700")) # montana state plane NAD83
buff<-buffer(Wells_points[Wells_points$Location %in% impacted_locs,], width=400, dissolve=TRUE)
plot(buff)


pts1<-Wells_points[Wells_points$Location %in% setdiff(unique(Dataset$Location),impacted_locs),]
t<-over(Wells_points[Wells_points$Location %in% setdiff(unique(Dataset$Location),impacted_locs),],buff)
pts1<-pts1[which(is.na(t)),]
#points(pts1)
#points(shp, pch=15)

buff2<-buffer(shp, width=350, dissolve=TRUE)
lines(buff2)
t<-over(Wells_points[Wells_points$Location %in% impacted_locs,],buff2)
pts2<-Wells_points[Wells_points$Location %in% impacted_locs,]
pts2<-pts2[which(is.na(t)),]
#points(pts2, pch=12)

pts1$`Slope Estimate (Yr-1)` <- 0
pts1$`Current Estimated Benzene` <- 0
pts1$`Slope Method` <- "Assumed"

pts2$`Slope Estimate (Yr-1)` <- -3.53e-5
pts2$`Current Estimated Benzene` <- NA
pts2$`Slope Method` <- "Assumed"

m<-rbind.SpatialPointsDataFrame(pts1[,c(1:3,22:24)],pts2[,c(1:3,22:24)])
shp<-shp[,c(1,18,19,2:17)]
shp2<-shp[,c(1:3,18,17,19)]

m<-rbind.SpatialPointsDataFrame(shp2,m)
points(m, pch=m$`Slope Estimate (Yr-1)`)
