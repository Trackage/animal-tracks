## use trip format to create KML 

## the KML has time spans on each line segment, so it's actually responsive in GE to the slider

## trip is not really required, this should use arrange, group_by, select - or possibly ggplot_build 
## trip::explode is used for convenience to break the tracks up into line segments with time spans

library(trip)
library(dplyr)

d <- readRDS("ellie_IMOS.RDS")
d <- as.data.frame(d, stringsAsFactors = FALSE)
coordinates(d) <- c("lon", "lat")
obj <- trip(d, c("date", "id"))
xsegs <- trip::explode(obj)
coords_segs <-   unlist(lapply(xsegs@lines, function(a) lapply(a@Lines, slot, "coords")), recursive = FALSE)
coordinates <- unlist(lapply(coords_segs, function(x) paste(apply(cbind(x, 0), 1, paste, collapse = ","), collapse = "\n")))  ## will need the get Z and/or M for sf
tripID <- xsegs[["id"]]
linesegID <- unlist(lapply(split(tripID, tripID), seq_along))
time_begin <- format(xsegs[["starttime"]], "%Y-%m-%dT%H:%M:%S+00:00")
time_end <- format(xsegs[["endtime"]], "%Y-%m-%dT%H:%M:%S+00:00")
aaggbbrr <- function(x) {
  unlist(lapply(strsplit(x, ""), function(x) paste("#", x[8], x[9], x[6], x[7], x[4], x[5], x[2], x[3], collapse = "", sep = "")))
}


line_colour <- aaggbbrr(tolower(sample(viridis::viridis(length(unique(tripID))))[factor(tripID)]))

library(glue)

template_document <- '<kml xmlns:xsd="http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd" xmlns:xmlns="http://www.opengis.net/kml/2.2/" version="1.0">
<Document>
<name>ellie24</name>
<visibility>1</visibility>
<open>1</open>
<Folder>

%s
</Folder>
</Document>
</kml>
'


template_line <- '
<Placemark> 
<TimeSpan><begin>{time_begin}</begin><end>{time_end}</end></TimeSpan>
<LineString>
<altitudeMode>clampToGround</altitudeMode>
<coordinates>
{coordinates}
</coordinates>
</LineString>

<Style> 
<LineStyle>  
<color>{line_colour}</color>
</LineStyle> 
</Style>
</Placemark>
'


line <- glue(template_line)
doc <- sprintf(template_document, paste(line, collapse = "\n"))

writeLines(doc, "kml/doc.kml")
zip("kml/ellie24.kmz", "kml/doc.kml")
unlink("kml/doc.kml")
