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
      h1("Introducing Shiny"),
      p("Shiny is a new package from R studio that makes it", em("incredibly easy"), " to build interactive web application with R."),
      br(),
      p("For an introuction and live examples visit the",
        a("Shiny homepage.",
          href = "http://www.rstudio.com/shiny")),
      br(),
      h2("Features"),
      p("*Build appplications with aonly a few linbes of code - no javasdcript required."),
      p("*Shiny applications are automatically live in the same way that", strong("spreadsheets"), "are live. Outputs change instantly as users modify inputs, withoput requiring a reload of the browser."),
      leafletOutput("mymap"),
      p(),
      actionButton("recalc", "New points")
    )
  )
))
