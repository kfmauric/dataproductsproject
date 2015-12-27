library(shiny)
library(leaflet)
shinyUI(fluidPage(
  titlePanel("Portland Oregon Restaurant Inspection Reports"),
  sidebarLayout( position = "left",
    sidebarPanel(
      h2("Overview"),
      p("This application provides an interface to the restaurant inspection reports provided by the",a("civic apps API", href="http://api.civicapps.org/"), "in Portland Oregon"),
      p("Restaurant Icon provided courstesy of",
        a("Icon8", href="http://icons8.com"),"."),
      br(),
      br(),
      br(),
      br(),
      img(src = "bigorb.png", height = 72, width = 72),
      "shiny is a product of ",
      span("RStudio", style = "color:blue")
    ),
    mainPanel(
      fluidRow(
        column(12,leafletOutput("mymap")),
        column(1,
               br()
               )
        ),
      # Copy the line below to make a text input box
      fluidRow(
        column(6,
               dateInput('date2',
                         label = 'Start Date',
                         value = as.character(Sys.Date()-365),
                         min = Sys.Date() - 1825, max = Sys.Date(),
                         format = "mm/dd/yy"
                       ),
               p("Current Values:", style = "color:#888888;"),
               verbatimTextOutput("startdate")
        ),
        column(6,
               actionButton("fetch", label = "Fetch Data"),
               p("Current Values:", style = "color:#888888;"),
               verbatimTextOutput("resName")
               )
      ),
      fluidRow(
        column(5,
               verbatimTextOutput("foo")
               )
      ),
      fluidRow(
        column(12,
               dataTableOutput(outputId="table")
        )
      )
    )
  )
))
