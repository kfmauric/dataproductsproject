library(shiny)
library(leaflet)
library(jsonlite)
library(ggplot2)
library(DT)
library(lubridate)
shinyServer(
  #grab and process initial data
  function(input, output, session) {
    #grab data from api and make location table
    jsonData <- fromJSON("http://api.civicapps.org/restaurant-inspections?count=1000&since=2014-12-27")
    descPoint <- cbind(jsonData$results$location[,c("Longitude", "Latitude")], jsonData$results[c("name", "score")])
    descPoint$content <- paste(sep = "<br/>",
                              descPoint$name, descPoint$score)
    output$table = DT::renderDataTable(descPoint, selection = 'single')
    output$foo = renderText(input$table_rows_selected)
    update_server <- reactive({
      input$fetch
      jsonstring<-paste("http://api.civicapps.org/restaurant-inspections?count=1000&since=", input$date2, sep="")
      jsonData <- fromJSON(as.character(jsonstring))
      descPoint <- cbind(jsonData$results$location[,c("Longitude", "Latitude")],
                       jsonData$results[c("name", "score")])
      descPoint$content <- paste(sep = "<br/>",
                               descPoint$name, descPoint$score)
    })
    output$startdate = renderText({
      input$fetch
      isolate({
        #assemble string to fetch data
        paste("http://api.civicapps.org/restaurant-inspections?count=1000&since=", input$date2, sep="")
      })
   })
    waitIcon <- makeIcon("Food-Waiter-icon.png",24,24)
    output$value <- renderPrint({ input$resName })


    output$mymap <- renderLeaflet({
      leaflet(data=descPoint) %>% setView(lat = 45.5200, lng = -122.6819, zoom = 12) %>%
        setMaxBounds(lng1=-122.2, lat1=45.4, lng2=-122.9, lat2=45.6) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addMarkers(~Longitude, ~Latitude, popup=~content,
                   clusterOptions = markerClusterOptions(maxClusterRadius=80, disableClusteringAtZoom = 16),
                   icon=waitIcon)
     #update points of intrest when the map changes
    })
    }
)
