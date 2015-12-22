library(shiny)

#String to display
descrTxt <- HTML("</br>I have choosen 'Motor Trends Analysis' regression models project data to design a Shiny Application as part of 'Developing Data Products using - R' Course Project. </br></br> Left side panel is 'Input selection Panel' to control the information displayed on tabs. It has four sections to change/control the input to update the information displayed on respective tabs. Data Table tab itself has some filters to sort and seach for the data available in mrcars dataset.</br></br></br>Right side panel is having five tabs (except description) to display Cars dataset Analysis, Summary, Data Frame, Data table, and Plots information. User can select any tab to check the information available.</br></br><p align='jestify' style='background-color:#c6c6f7'><b>Tabs - Description</b></br></br> <b>Analysis Tab</b> Enter some text in 'Enter New Header' and check the Analysis tab for header change.</br></br><b>Data Summary Tab</b><br>Select Transmission Type Automatic or Manual and check the summary</br></br><b>Data Table Tab</b></br> Data table has sort filder, limit number of rows to display, pagination, and search features (dataTableOutput default features).</br></br><b>Data Frame</b></br> This tab controlled by 'Number of observations' and 'Choose Filter' to limit/filter the data display.</br></br><b>Plots Tab</b></br> This tab has hide/display selection. Selected plot will be displayed on this tab.</p>")

summaryTxt <- HTML('</br>Motor Tren Magazine performing analysis on Automatic and Manual transmission which is economically best or gives more miles per gallon(MPG). They are particularly interested in the following two questions:</br>
                           "Is an automatic or manual transmission better for MPG"</br>
                   "Quantify the MPG difference between automatic and manual transmissions"</br>')
meanInfo <- HTML("<b>32</b> rows and <b>11</b> columns available in base dataset.</br> Initially we will check the mean MPG (miles per gallon) for automatic and manual transmission</br> 0 - automatic transmission and 1 - manual transmission mean values listed below:")

meanInfo2 <- HTML('Manual transmission mean <b>24.39</b> is heigher than automaic transmission mean <b>17.15</b>. </br> <span style="background-color:#c6c6f7;">Select <b>Plots</b></span> tab to check the Quantifying MPG differences between Manual and Automatic transmissions.')

ttest <- HTML('<h3>t-test</h3>Perfoming t-test to test this hypothesis (as alpha=0.5)</br>aggres <- aggregate(mpg~am, data = mtcars, mean)</br>(aggres[2,2] - aggres[1,2])</br>')

pvaltst <- HTML('<b>P-value = 0.001374</b>, we reject this null hypothesis. It means there exist a major difference between automatic and manual transmission</br></br>Transforming cyl, vs, gear, and carb data elements to proceed with our analysis.</br></br>#converting factor variables for plots and models</br>mtcars$cyl <- factor(mtcars$cyl)</br>mtcars$vs <- factor(mtcars$vs)</br>mtcars$gear <- factor(mtcars$gear)</br>mtcars$carb <- factor(mtcars$carb)</br>str(mtcars)</br>')

sctrtxt <- HTML('We will explore the relationships between the varaibles and outcome using scatterplot matrix:</br><span style="background-color:#c6c6f7;">Select <b>Plots</b></span> tab to check the scatterplot for below code:</br></br>library(car)</br>scatterplot.matrix(~mpg + cyl + disp + hp + drat + wt + qsec + vs + am + gear + </br>carb, data = mtcars, main = "Scatterplot Matrix")</br></br>Based on scatterplot results, mpg has high corelation with few variables.</br>Initially building a model lm(linear regression model) with all variables as predictors. Applying <b>Step</b> method to perform stepwise model selection to select significant predictors for the final model, using both forward selection and backward elimination methods.</br></br>fit1 <- lm(mpg ~. , data=mtcars)</br>fit2 <- step(fit1, direction = "both", trace=0)</br></br>The best model includes cyl, wt, hp and am as predictors for mpg</br>')

resdtxt <- HTML('We will use residual plots of our regression model to compute some of the regression diagnostics for our model and find out some interesting outliers in the data set<br></br>par(mfrow = c(2,2))</br>plot(fit2)</br></br><span style="background-color:#c6c6f7;">Select <b>Plots</b></span> tab to check the Residuals and Diagnostics plots</br></br><b>Residual Plot observations:</b></br>
Residuals vs Fitted plot random points confirms that the independence condition. Normal Q-Q plot the points shows that the residuals are normally distributed. Scale-Location plot the points patterns indicating the constant variance. Residuals vs Leverage plot shows some leverage points are in the top right corner of the plot.</br>')

fit2txt <- HTML('From summary, the adjusted R square value is equal to 0.84 which is the maximum obtained by considering cyl, hp, wt, and am variables. So we could conclude more than 84% of the variability is explained by this model.</br></br>Using NOVA we will compare the base model with only am as predictor to confirm fit2 is the best model.</br></br>')

hyptxt <- HTML('final_model <- lm(mpg ~ am, data = mtcars)</br>anova(fit2, final_model)</br></br>')

hyptxt2 <- HTML('P-value obtained is highly significant. Hence we reject this null hypothesis that the confounder variables cyl, hp and wt do not contribute to get the accuracy of the model.')

contxt <- HTML("Observations from summary(fit2)</br>Motor Trend Analysis concluded that 'Manual' transmission gives 1.80 more miles per gallon (MPG) than 'Automatic' transmission (adjusted by hp, wt, and am).</br>")

#UI application structure
shinyUI(pageWithSidebar(
        headerPanel("Motor Trend Analysis: Manual Vs Automatic Transimission for MPG"),
        sidebarPanel(
                tags$h3("mtcars - Dataset selection crieteria"),tags$br(),
                tags$h4("Update Analysis Tab Heading"),
                textInput("header", "Enter New Header", "Motor Trend Analysis: Manual Vs Automatic Transimission for MPG"),
                tags$br(),
                tags$h4("Select below to change Data Summary Tab data:"),
                radioButtons("dataSummary", "Transmission Type:",
                             list("Automatic" = "auto", "Manual" = "manual")), tags$br(),
                tags$h4("Select below to change Data Frame Tab data:"),
                sliderInput("ndata","Number of observations:",value = 15,min = 1,max = 30),
                selectInput("datafilter", "Choose a filter:",
                            choices = c("All","Automatic","Manual")),tags$br(),
                tags$h4("Select/Unselect to Display/hide plots in Plots Tab:"),
                checkboxInput("box", "Boxplot", TRUE),
                checkboxInput("scatter", "Scatterplot Matrix", TRUE),
                checkboxInput("resid", "Residuals and Diagnostics", TRUE)
        ),
        mainPanel(

                tabsetPanel(
                tabPanel("Description",tags$h2("Project Description"), descrTxt
                        ),
                tabPanel(
                        "Analysis",h2(verbatimTextOutput("header")),
                        tags$h2("Summary"), summaryTxt,tags$h2("Analysis"),
                        tags$h5("dim(mtcars)"),verbatimTextOutput("dscrtext"),meanInfo,tags$br(),
                        verbatimTextOutput("mnresults"),tags$br(),meanInfo2,tags$br(),ttest,tags$br(),
                        verbatimTextOutput("ttst"),tags$br(),verbatimTextOutput("tnd"),pvaltst,verbatimTextOutput("trnsfm"),
                        tags$h2('Exploratory Data Analysis'),tags$br(),sctrtxt,tags$br(),
                        tags$h2('Residuals and Diagnostics'),tags$br(),resdtxt,tags$br(),verbatimTextOutput("fitsm"),
                        tags$br(),fit2txt,tags$h2('Hypothesis'),tags$br(),hyptxt,verbatimTextOutput("hypres"),hyptxt2,
                        tags$br(),tags$h2('Conclusion'),tags$br(),contxt,tags$br()
                        ),
                tabPanel(
                        "Data Summary", verbatimTextOutput("autosmry")
                        ),
                tabPanel(
                        "Data Table", dataTableOutput("table")
                        ),
                tabPanel(
                         "Data Frame", tableOutput("dframe")
                        ),
                tabPanel(
                        "Plots",
                        tags$h2("Quantifying MPG differences using boxplot"),
                        plotOutput("plot1"),
                        tags$h2("Scerplot Matrix"),
                        plotOutput("sctr"),
                        tags$h2("Residuals and Diagnostics"),
                        plotOutput("plot2")
                        )

                )
        )
))
