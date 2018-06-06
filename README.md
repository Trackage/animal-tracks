# animal-tracks
animal tracks data sets in ready to use data frame form


```R
## bsam package
## two (id) elephant seals in data frame  (lon, lat, date)
ellie <- bsam::ellie 

## trip package
## several (Deployment) walrus tracks (X_AED170_70 Y_AED170_70, DataDT)
trip::walrus818 
library(trip)
walrus <- tibble::as_tibble(as.data.frame(walrus818))

saveRDS(ellie, "ellie.rds")
saveRDS(walrus, "walrus.rds")
```
