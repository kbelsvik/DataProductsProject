library(shiny)

shinyServer(function(input, output){
   output$mandelbrot <- renderPlot({
      step <- 50
      reps <- 100
      upper <- 0
      n <- 400
      x <- input$x
      y <- input$y
      w <- 4/input$zoom
      h <- 4/input$zoom
      
      
      C <- complex(imag=rep(seq(y - h/2, y + h/2, length.out=n), each=n),
                   real=rep(seq(x - w/2, x + w/2, length.out=n), n))
      #C <- matrix(C, n, n)
      Z <- rep(0, n*n)
      diverge <- rep(0, n*n)
      j <- 0
      while(j < reps){
         upper <- ifelse(upper+step < reps, upper+step, reps)
         empty <- diverge==0
         diverge.temp <- diverge[empty]
         Z.temp <- Z[empty]
         C.temp <- C[empty]
         for(i in (j+1):upper){
            Z.temp <- Z.temp^2+C.temp
            diverge.temp[diverge.temp == 0 & Mod(Z.temp) >= 2] <- i
            
         }
         diverge[empty] <- diverge.temp
         Z[empty] <- Z.temp
         j <- upper
      }
      diverge[diverge!=0] <- diverge[diverge!=0] - min(diverge[diverge!=0]) + 1
      diverge <- diverge+1
      maxD <- max(diverge)
      diverge.m <- matrix(diverge, n, n)
      image(seq(x - w/2, x + w/2, length.out=n), seq(y - h/2, y + h/2, length.out=n), diverge.m, col=c("black", topo.colors(maxD)), xlab="", ylab="")
      
   })
   
})