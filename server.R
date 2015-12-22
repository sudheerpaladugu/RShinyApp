
library(shiny)
library(datasets)
data(mtcars)

mtcars$am <- factor(mtcars$am, labels = c("Automatic", "Manual"))

# Define server logic for random distribution application
shinyServer(function(input, output) {

        output$header <- renderPrint({
                cat(input$header)
        })


        output$plot1 <- renderPlot({
             if(input$box){ boxplot(mpg ~ am, data = mtcars, xlab = "Transmission Type", ylab = "MPG (miles per gallon)",
              main="MPG for Transmission Type")
             }
        })

        output$plot2 <- renderPlot({
                if(input$resid){
                        fit1 <- lm(mpg ~. , data=mtcars)
                        fit2 <- step(fit1, direction = "both", trace=0)
                        par(mfrow = c(2,2))
                        plot(fit2)
                }
        })

        output$sctr <- renderPlot({
        suppressWarnings(library(car))
                if(input$scatter){scatterplot.matrix(~mpg + cyl + disp + hp + drat + wt + qsec + vs + am + gear +
                                   carb, data = mtcars, main = "Scatterplot Matrix")
                }
        })

        #slider data for data frame tab
        radioData <- reactive({
                if(input$dataSummary == 'auto'){
                        summary(mtcars[mtcars$am == 'Automatic',])
                }else {
                        summary(mtcars[mtcars$am == 'Manual',])
                }
        })

        #Generate a summary of the data
        output$autosmry <- renderPrint({
                radioData()
        })
        output$mansmry <- renderPrint({
                summary(mtcars[mtcars$am == 'Manual',])
        })

        #t-test results
        output$ttst <- renderPrint({
                aggres <- aggregate(mpg~am, data = mtcars, mean)
                reslt <- (aggres[2,2] - aggres[1,2])
                reslt
        })

        output$tnd <- renderPrint({
                  t.test(mtcars[mtcars$am == 'Automatic',]$mpg, mtcars[mtcars$am == 'Manual',]$mpg)
        })
        # Generate a summary of the data
        output$dscrtext <- renderPrint({
                dim(mtcars)
        })
        #generating means
        output$mnresults <- renderPrint({
               cat(paste(summary(mtcars[mtcars$am == 'Automatic',])[4,1],"\n",summary(mtcars[mtcars$am == 'Manual',])[4,1]));
        })

        #generating
        output$trnsfm <- renderPrint({
                #converting factor variables for plots and models
                mtcars$cyl <- factor(mtcars$cyl)
                mtcars$vs <- factor(mtcars$vs)
                mtcars$gear <- factor(mtcars$gear)
                mtcars$carb <- factor(mtcars$carb)
                str(mtcars)
        })

        #generating fit2 mean
        output$fitsm <- renderPrint({
                fit1 <- lm(mpg ~. , data=mtcars)
                fit2 <- step(fit1, direction = "both", trace=0)
                summary(fit2)
        })

        output$hypres <- renderPrint({
                fit1 <- lm(mpg ~. , data=mtcars)
                fit2 <- step(fit1, direction = "both", trace=0)
                final_model <- lm(mpg ~ am, data = mtcars)
                anova(fit2, final_model)
        })

        # Generate an HTML table view of the data
        output$dframe <- renderTable({
                data.frame(x=mtcars)
        })

        output$table <- renderDataTable({
                mtcars
        }, options = list(aLengthMenu = c(5, 20, 30), iDisplayLength = 5))

        #slider data for data frame tab
        sliderData <- reactive({
                if(input$datafilter == 'All'){
                        head(data.frame(x=mtcars),input$ndata)
                } else {
                        head(data.frame(x=mtcars[mtcars$am == input$datafilter,]),input$ndata)
                }
        })
        #printing slider data on data frame tab
        output$dframe <- renderTable({
                 sliderData()
         })

})
