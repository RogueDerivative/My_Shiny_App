#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that produces a slider
shinyUI(fluidPage(
    titlePanel("Predict MPG"),
    sidebarLayout(
        sidebarPanel(
            submitButton("Submit"),
            radioButtons("radioAM",
                         "Automatic or Manual Transmission?",
                         choiceNames = c("Automatic","Manual"),
                         choiceValues = c(0,1)),
            radioButtons("radioVS",
                         "V-Shaped or Straight-Line engine?",
                         choiceNames = c("V-Shaped","Straight-Line"),
                         choiceValues = c(0,1)),
            selectInput("selectCYL",
                        "How many Cylinders?",
                        choices = c(4,6,8)),
            selectInput("selectCARB",
                        "How many Carburetors?",
                        choices = c(1,2,3,4,6,8)),
            selectInput("selectGEAR",
                        "How many GEARS?",
                        choices = c(3,4,5)),
            sliderInput("sliderDISP",
                        "What is the DISPLACEMENT?",
                        71,472,value = 250),
            sliderInput("sliderHP",
                        "What is the HORSEPOWER?",
                        52,335, value= 146),
            sliderInput("sliderDRAT",
                        "What is the REAR AXLE RATIO?",
                        2.7,5.0, value = 3.7),
            sliderInput("sliderWT",
                        "What is the WEIGHT? (in 1000lbs)",
                        1.5,5.5, value = 3.3, step = 0.1),
            sliderInput("sliderQSEC",
                        "What is the 1/4 MILE TIME? (in seconds)",
                        14.0,23.0, value = 17.7, step = 0.1)
        ),

        #
        mainPanel(
            h3("Predicted MPG using a Random Forest:"),
            verbatimTextOutput("randf_pred"),
        )
    )
))
