library(shiny)

shinyUI(fluidPage(
   titlePanel("Mandelbrot"),
   
   sidebarLayout(
      sidebarPanel(
         uiOutput("zoom"),
         uiOutput("x"),
         uiOutput("y"),
         submitButton("Submit")
      ),
      mainPanel(
         plotOutput('mandelbrot', height=425, width=425)
      )
   )
))