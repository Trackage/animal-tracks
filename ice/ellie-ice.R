library(raadtools)

ellie_IMOS <- readRDS("ellie_IMOS.RDS")
## drop the pre-2012 stuff
library(dplyr)
ellie <- dplyr::filter(ellie_IMOS, date >= as.POSIXct("2012-01-01"))
ex <- extent(range(ellie$lon, na.rm = TRUE), 
             range(ellie$lat, na.rm = TRUE)) + 2
xmin(ex) <- 5  ## reign in to avoid wrap issue
dts <- seq(min(ellie$date) - 3 * 24 * 3600, 
           max(ellie$date) + 3 * 24 * 3600, by = "1 days")


## extent in ice projected space
icedummy <- readice()
pex <- projectExtent(raster(ex, crs = "+proj=longlat +datum=WGS84"), 
                     projection(icedummy))
## read ice and get contours
ice <- crop(readice(dts), extent(pex))
## reduce resolution (a lot)
ice <- aggregate(ice, fact = 4)
cl <- vector("list", nlayers(ice))
for (i in seq_len(nlayers(ice))) {
  cl[[i]] <- sf::st_as_sf(rasterToContour(ice[[i]], levels = 15))
}

library(sf)
cl <- st_transform(do.call(rbind, cl), 4326)
cl$date <- dts
saveRDS(cl, "ice/ellie-ice-contour15pc.rds", compress = "bzip2")
