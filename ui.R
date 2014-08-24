library(shiny)
shinyUI(pageWithSidebar(
   headerPanel("Mandelbrot"),
   sidebarPanel(
      h3("Welcome to the Shiny Mandelbrot app!"),
      p(paste("Notice the slider below, this controls the zoom of the view.",
                 "Move it to the right to zoom in, or the left to zoom out. ",
                 "The x and y coordinates of the center of the view are printed",
                 "below the zoom slider.  To control the x and y coordinates ",
                 "click anywhere on the image, the coordinates will be set to",
                 "the location clicked!")),
      p("When you are ready, click the Update! button to re-render the image with the new parameters."),
      div(HTML("<hr>")),
      uiOutput("zoom"),
      div(HTML("<hr>")),
      textOutput("x"),
      textOutput("y"),
      div(HTML("<hr>")),
      actionButton("update", "Update!")
   ),
   mainPanel(
      plotOutput("mandelbrot", width="450", height="450", clickId="click")
   )
))