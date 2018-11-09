library(gganimate)
library(sf)
library(dplyr)
ice <- readRDS("ice/ellie-ice-contour15pc.rds")
ele <- readRDS("ellie_IMOS.RDS")
lon_0 <- round(mean(ele$lon), 1)
lat_0 <- round(mean(ele$lat), 1)
proj <- glue::glue("+proj=stere +lon_0={lon_0} +lat_0={lat_0} +datum=WGS84")
ele[c("X", "Y")] <- rgdal::project(as.matrix(ele[c("lon", "lat")]), proj)
slc <- ele %>% dplyr::filter(between(date, min(ice$date), max(ice$date))) %>% distinct(id)
sub <- ele %>% dplyr::inner_join(slc, "id") %>% sample_frac(.1) %>% 
  arrange(id, date)

pice <- st_transform(ice, proj) %>% dplyr::filter((row_number() %% 10) == 1) %>% 
  dplyr::mutate(id = "i am ice") 
ggplot() + 
 geom_point(data = sub , aes(X, Y, colour = id)) +
  geom_sf(data = pice) +
    gganimate::transition_time(date)

  #transition_reveal(10, date)





  

 


