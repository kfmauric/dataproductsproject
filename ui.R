library(shiny)
library(leaflet)
shinyUI(fluidPage(
  titlePanel("Portland Oregon Restaurant Inspection Reports"),
  sidebarLayout( position = "left",
    sidebarPanel(
      h2("Overview"),
      p("This application provides an interface to the restaurant inspection reports provided by the",a("civic apps API", href="http://api.civicapps.org/"), "in Portland Oregon. The date selection widget allows you to modify the start date for the data collection. The average inspection score for the time period is comp[uted and displayed in the table. Failing inspections are scored zero, so there is an adverse effect of failing inspections on the mean. The table is searchable and sortable to find your favorite resteraunts"),
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
#      could not get map updates working
#      fluidRow(
#        column(12,leafletOutput("mymap")),
#        column(1,
#               br()
#               )
#        ),
      # Copy the line below to make a text input box
      fluidRow(
        column(6,
               dateInput('date2',
                         label = h4('Start Date'),
                         value = as.character(Sys.Date()-365),
                         min = Sys.Date() - 1825, max = Sys.Date(),
                         format = "mm/dd/yy"
                       )
        ),
        column(6,
               p(h4("Data Since:"), style = "color:#888888;"),
               verbatimTextOutput("startdate")
               )
      ),
      fluidRow(
        column(5,
               actionButton("fetch", label = "Update Table")
               ),
        column(12,
               br()
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
