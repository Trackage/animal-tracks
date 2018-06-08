library(raadtools)  ## not generally available

ellie_IMOS <- readRDS("ellie_IMOS.RDS")
## drop the pre-2012 stuff
library(dplyr)
ellie <- dplyr::filter(ellie_IMOS, date >= as.POSIXct("2012-01-01"))
ex <- extent(range(ellie$lon, na.rm = TRUE), range(ellie$lat, na.rm = TRUE)) + 2

dts <- seq(min(ellie$date) - 3 * 24 * 3600, max(ellie$date) + 3 * 24 * 3600, by = "5 days")
sst <- readsst(dts, xylim = ex)
## reduce resolution to 0.5 degree
sst <- aggregate(sst, fact = 2, fun = median, na.rm = TRUE)
sst <- setZ(sst, dts)
saveRDS(sst, "sst/ellie-sst.rds", compress = "bzip2")
## a representative-ish ncdump
system(sprintf("ncdump -h %s > sst/sstdata_ncdump.txt", sstfiles()$fullname[11000]))
