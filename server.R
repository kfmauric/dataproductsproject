library(shiny)
library(leaflet)
library(jsonlite)
library(ggplot2)
library(DT)
library(lubridate)
library(dplyr)
shinyServer(
  #grab and process initial data
  function(input, output, session) {
    #grab data from api and make location table
    #big grab upfront and then subset in R
    #jsonData <- fromJSON("http://api.civicapps.org/restaurant-inspections?count=1000&since=2000-12-27")
    #descPoint <- cbind(jsonData$results$location[c("Longitude", "Latitude")],
                       #jsonData$results[c("name", "inspection_number","restaurant_id","type","date","score")],
                       #jsonData$results$address[c("street", "city","zip")])
    source("data.Rdmpd")
    #fix the dates
    descPoint$date <- ymd(descPoint$date)
    #fix the score
    descPoint$score <-as.numeric(descPoint$score)
    #fix the longitude and latitude
    #change to numeric
    descPoint$Longitude <- as.numeric(descPoint$Longitude)
    descPoint$Latitude <- as.numeric(descPoint$Latitude)
    #filter location errors
    descPoint <- descPoint %>%
      mutate(temp=floor(Longitude)) %>%
      filter(temp==-123)
    descPoint <- descPoint %>%
      mutate(temp=floor(Latitude)) %>%
      filter(temp==45)
    descPoint$content <- paste(sep = "<br/>",
                              descPoint$name, descPoint$score)
    rdescPoint <- descPoint %>%
      filter(date>=ymd(as.character(Sys.Date()-365))) %>%
      group_by(name, restaurant_id, street, zip) %>%
      summarise(avg_score=mean(score))
    mdescPoint <- descPoint %>%
      group_by(Longitude, Latitude, name, restaurant_id) %>%
      summarise(ave_score=mean(score))
    mdescPoint$content <- paste(sep = "<br/>",
                               mdescPoint$name, mdescPoint$ave_score)
    output$table = DT::renderDataTable(rdescPoint<-dateNewData(), selection = 'single')
    output$foo = renderText(input$table_rows_selected)
    #update_server <- reactive({
     # input$fetch
    #  browser()
    #  jsonstring<-paste("http://api.civicapps.org/restaurant-inspections?count=1000&since=", input$date2, sep="")
    #  jsonData <- fromJSON(as.character(jsonstring))
    #  descPoint <- cbind(jsonData$results$location[,c("Longitude", "Latitude")],
    #                   jsonData$results[c("name", "score")])
    #  descPoint$content <- paste(sep = "<br/>",
    #                           descPoint$name, descPoint$score)
    #})
    #makeReactiveBinding("rdescPoint")
    #makeReactiveBinding("mdescPoint")
       output$startdate = renderText({
      input$fetch
      isolate({
        #assemble string to fetch data
        as.character(input$date2)
      })
   })

    dateNewData <- reactive({
      input$fetch
      isolate({
        rdescPoint <- descPoint %>%
          filter(date>=ymd(input$date2)) %>%
          group_by(name, restaurant_id, street, zip) %>%
          summarise(avg_score=mean(score))
      })
    })

    computeDateScore <- eventReactive(input$fetch, {
      isolate({
        foo <- descPoint %>%
          filter(date>=ymd(input$date2)) %>%
          group_by(Longitude, Latitude, name, restaurant_id) %>%
          summarise(ave_score=mean(score)) %>%
          mutate(paste(sep = "<br/>", mdescPoint$name, mdescPoint$ave_score))
        mdescPoint <- foo
      })
    })
    waitIcon <- makeIcon("Food-Waiter-icon.png",24,24)
    output$value <- renderPrint({ input$resName })


    output$mymap <- renderLeaflet({
      leaflet(mdescPoint) %>% setView(lat = 45.5200, lng = -122.6819, zoom = 12) %>%
        setMaxBounds(lng1=-122.2, lat1=45.4, lng2=-122.9, lat2=45.6) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addMarkers(data=computeDateScore(), ~Longitude, ~Latitude, popup=~content,
                   clusterOptions = markerClusterOptions(maxClusterRadius=80, disableClusteringAtZoom = 16),
                   icon=waitIcon)
     #update points of intrest when the map changes
    })

    #observe({
      #mdescPoint <- computeDateScore()
     # leafletProxy("mymap") %>%
      #  addMarkers(data=computeDateScore(), ~Longitude, ~Latitude, popup=~content,
       #            clusterOptions = markerClusterOptions(maxClusterRadius=80, disableClusteringAtZoom = 16),
        #           icon=waitIcon)
    #})
    }
)
