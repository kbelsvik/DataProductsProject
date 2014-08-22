library(shiny)

shinyUI(fluidPage(
   titlePanel("Mandelbrot"),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("zoom",
                     "Zoom",
                     min=1,
                     max=10000,
                     value=1),
         sliderInput("x",
                     "X",
                     min=-2,
                     max=2,
                     value=0),
         sliderInput("y",
                     "Y",
                     min=-2,
                     max=2,
                     value=0)
      ),
      mainPanel(
         plotOutput('mandelbrot')
      )
   )
))