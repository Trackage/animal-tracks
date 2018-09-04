## elephant seal tracks
ellie <- readRDS("ellie_IMOS.RDS")

library(trip)
ellie <- as.data.frame(ellie, stringsAsFactors = FALSE)
coordinates(ellie) <- c("lon", "lat")

proj4string(ellie) <- CRS("+init=epsg:4326")
tr <- trip(ellie, c("date", "id"))

## convert to SpatialLinesDataFrame of segments
trip::explode(tr)

## more relevant to primitives
library(silicate)
SC(tr) ## silicate edge type with all data maintained

