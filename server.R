
library(shiny)
data(mtcars)

mtcars$am <- factor(mtcars$am, labels = c("Automatic", "Manual"))

# Define server logic for random distribution application
shinyServer(function(input, output) {

        output$plot1 <- renderPlot({
              boxplot(mpg ~ am, data = mtcars, xlab = "Transmission Type", ylab = "MPG (miles per gallon)",
              main="MPG for Transmission Type")
        })

        output$plot2 <- renderPlot({
                fit1 <- lm(mpg ~. , data=mtcars)
                fit2 <- step(fit1, direction = "both", trace=0)
                par(mfrow = c(2,2))
                plot(fit2)
        })

        output$sctr <- renderPlot({
        suppressWarnings(library(car))
        scatterplot.matrix(~mpg + cyl + disp + hp + drat + wt + qsec + vs + am + gear +
                                   carb, data = mtcars, main = "Scatterplot Matrix")
        })

        # # Generate a summary of the data
        output$autosmry <- renderPrint({
                summary(mtcars[mtcars$am == 'Automatic',])
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

        # # Generate an HTML table view of the data
        # output$table <- renderTable({
        #         data.frame(x=mtcars)
        # })
        output$table <- renderDataTable({
                mtcars
        }, options = list(aLengthMenu = c(5, 20, 30), iDisplayLength = 5))
})
