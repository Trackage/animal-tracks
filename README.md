# animal-tracks
animal tracks data sets in ready to use data frame form


```R
## bsam package
## two (id) elephant seals in data frame  (id, date, lc, lon, lat)
ellie <- bsam::ellie 

## trip package
## several (Deployment) walrus tracks (X_AED170_70 Y_AED170_70, DataDT)
trip::walrus818 
library(trip)
walrus <- tibble::as_tibble(as.data.frame(walrus818))

## IMOS elephant seal data, used in Jonsen et al. 2018 doi:https://doi.org/10.1101/314690
## 24 (id) seals in data frame (id, date, lc, lon, lat, trip)
## `trip` denotes an ice-bound or pelagic foraging trip, all originating from Isles Kerguelen
ellie_IMOS <- tibble::as_tibble(readRDS("ellie_IMOS.RDS"))

saveRDS(ellie, "ellie.rds")
saveRDS(walrus, "walrus.rds")
```
