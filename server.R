library(shiny)

shinyServer(function(input, output, session){
    # Get the x coordiate from the click
    x <- reactive({
        if(is.null(input$click)){
            return(0)
        }
        input$click$x
    })
    # Get the y coordinate from the click
    y <- reactive({
        if(is.null(input$click)){
            return(0)
        }
        input$click$y
    })
    # Output x coordinate to UI
    output$x <- renderText({
        paste("x:", x())
    })
    # Output y coordinate to UI
    output$y <- renderText({
        paste("y:", y())
    })
    # Zoom slider, the mix and max values will update when the button is clicked
    # This helps avoid over sensitivity in the slider
    output$zoom <- renderUI({
        input$update
        isolate({
            zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
            if(zoom < 10){
                min.zoom <- 0
                max.zoom <- 20
            } else if(zoom > 30){
                min.zoom <- 20
                max.zoom <- 40
            } else {
                min.zoom <- zoom - 10
                max.zoom <- zoom + 10
            }
            sliderInput("zoom", "Zoom:", min.zoom, max.zoom, value=zoom, step=.25)
        })
    })
    # Output the mandelbrot drawying
    output$mandelbrot <- renderPlot({
        input$update
        isolate({
            #parameters
            step <- 25
            reps <- 400
            n <- 400
            zoom <- ifelse(!is.null(input$zoom), input$zoom, 0)
            x <- x()
            y <- y()
            w <- 4/2^zoom
            h <- 4/2^zoom
            
            #starting point
            C <- complex(imag=rep(seq(y - h/2, y + h/2, length.out=n), each=n),
                         real=rep(seq(x - w/2, x + w/2, length.out=n), n))
            Z <- rep(0, n*n)
            diverge <- rep(0, n*n)
            
            j <- 0
            upper <- 0
            while(j < reps){
                #perform some house keeping after every 'step' repetitions, for performace improvement
                upper <- ifelse(upper+step < reps, upper+step, reps)
                empty <- diverge==0
                diverge.temp <- diverge[empty]
                Z.temp <- Z[empty]
                C.temp <- C[empty]
                
                for(i in (j+1):upper){
                    #do the fractal caluculation
                    Z.temp <- Z.temp^2+C.temp
                    diverge.temp[diverge.temp == 0 & Mod(Z.temp) >= 2] <- i
                }
                
                diverge[empty] <- diverge.temp
                Z[empty] <- Z.temp
                j <- upper
            }
            
            #perform the rendering
            diverge <- diverge+1
            maxD <- max(diverge)
            diverge.m <- matrix(diverge, n, n)
            par(mar=c(2, 2, .5, .5))
            jet.colors = colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", 
                                            "yellow", "#FF7F00", "red", "#7F0000"))
            image(seq(x - w/2, x + w/2, length.out=n), seq(y - h/2, y + h/2, length.out=n), 
                  diverge.m, col=c("black", jet.colors(reps)), xlab="", ylab="")
        })
        
    })

})