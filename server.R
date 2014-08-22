library(shiny)

shinyServer(function(input, output, session){
   output$x <- renderUI({
      x <- ifelse(!is.null(input$x), input$x, 0)
      zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
      from <- x-2/2^zoom
      to <- x+2/2^zoom
      sliderInput("x", "X", min=from, max=to, value=x, step=.025/2^zoom)      
   })
   output$y <- renderUI({
      y <- ifelse(!is.null(input$y), input$y, 0)
      zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
      from <- y-2/2^zoom
      to <- y+2/2^zoom
      sliderInput("y", "Y", min=from, max=to, value=y, step=.025/2^zoom)
   })
   output$zoom <- renderUI({
      zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
      if(zoom < 10){
         from <- 0
         to <- 20
      } else if(zoom > 30){
         from <- 20
         to <- 40
      } else {
         from <- zoom - 10
         to <- zoom + 10
      }
      sliderInput("zoom", "Zoom", from, to, value=zoom, step=.25)
   })
   output$mandelbrot <- renderPlot({
      step <- 25
      reps <- 400
      n <- 400
      x <- ifelse(!is.null(input$x), input$x, 0)
      y <- ifelse(!is.null(input$y), input$y, 0)
      zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
      w <- 4/2^zoom
      h <- 4/2^zoom
      
      
      C <- complex(imag=rep(seq(y - h/2, y + h/2, length.out=n), each=n),
                   real=rep(seq(x - w/2, x + w/2, length.out=n), n))
      Z <- rep(0, n*n)
      diverge <- rep(0, n*n)
      
      j <- 0
      upper <- 0
      while(j < reps){
         upper <- ifelse(upper+step < reps, upper+step, reps)
         empty <- diverge==0
         diverge.temp <- diverge[empty]
         Z.temp <- Z[empty]
         C.temp <- C[empty]
         for(i in (j+1):upper){
            Z.temp <- Z.temp^2+C.temp
            diverge.temp[diverge.temp == 0 & Mod(Z.temp) >= 2] <- i+1
            
         }
         diverge[empty] <- diverge.temp
         Z[empty] <- Z.temp
         j <- upper
      }
      diverge[diverge!=0] <- 1 + diverge[diverge!=0] - min(diverge[diverge!=0])
      diverge <- diverge+1
      maxD <- max(diverge)
      diverge.m <- matrix(diverge, n, n)
      par(mar=c(2, 2, .5, .5))
      image(seq(x - w/2, x + w/2, length.out=n), seq(y - h/2, y + h/2, length.out=n), 
            diverge.m, col=c("black", topo.colors(maxD-1)), xlab="", ylab="")
      
   })
   
})