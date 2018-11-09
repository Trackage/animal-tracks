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
sub <- ele %>% dplyr::inner_join(slc %>% sample_frac(.2), "id") %>% sample_frac(.01) %>% 
  #rename(ele_date = date) %>% 
  rename(ele = id) %>% 
  arrange(ele, date)

pice <- st_transform(ice, proj) #%>% dplyr::rename(ice_date = date)
ggplot() + 
  geom_sf(data = pice %>% dplyr::filter((row_number() %% 10) == 1)) + 
  geom_point(data = sub , aes(X, Y, colour = ele)) +
  transition_manual(date) 

  

 


