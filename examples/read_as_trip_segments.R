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



sc_coord.tbl_df <- function(x, ...) {
  if (dplyr::is_grouped_df(x)) {
   ## remove grouping columns 
    gvars <- attr(x, "vars")
    x <- ungroup(x)
    x[gvars] <- NULL
  } 
  x
}

sc_path.tbl_df <- function(x, ...) {
  if (dplyr::is_grouped_df(x)) {
    ## remove grouping columns 
    gvars <- attr(x, "vars")
    x <- ungroup(x)
    x[gvars] <- NULL
  }
}