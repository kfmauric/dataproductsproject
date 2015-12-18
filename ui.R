library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("data science for the win"),
  sidebarPanel(
    h3('Sidebar text')
  ),
  mainPanel(
    h3('Main Panel text')
  )
))
