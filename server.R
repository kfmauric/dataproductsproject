library(shiny)
library(leaflet)
library(jsonlite)
shinyServer(
  function(input, output, session) {
    #grab data from api and make location table
    jsonData <- fromJSON("http://api.civicapps.org/restaurant-inspections?count=1000&since=2014-12-27")
    descPoint <- cbind(jsonData$results$location[,c("Longitude", "Latitude")], jsonData$results[c("name", "score")])

    descPoint$content <- paste(sep = "<br/>",
                              descPoint$name, descPoint$score
                )
    waitIcon <- makeIcon("Food-Waiter-icon.png",24,24)
    output$mymap <- renderLeaflet({
      leaflet(data=descPoint) %>% setView(lat = 45.5200, lng = -122.6819, zoom = 12) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addMarkers(~Longitude, ~Latitude, popup=~content, clusterOptions = markerClusterOptions(maxClusterRadius=80, disableClusteringAtZoom = 17), icon=waitIcon)
    })
    }
)
