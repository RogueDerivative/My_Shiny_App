library(shiny)

ui <- fluidPage(
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
        mainPanel(
            h2("Predicted MPG using a Random Forest:"),
            h3("Make adjustments in the input values in the side panel."),
            h3("Hit the SUBMIT button to see how your changes affect MPG."),
            verbatimTextOutput("randf_pred"),
        )
    )
)

server <- function(input,output) {
    # This is the getting and cleaning the data
    data(mtcars)
    df <- mtcars
    library(tidyverse)
    library(caret)
    library(parsnip)
    library(recipes)#*
    library(workflows)
    library(mboost)
    norm_recipe <-
        recipe(mpg ~ ., data = df) %>%
        step_nzv(all_predictors()) %>%
        step_normalize(all_numeric_predictors())
    randf_model <-
        rand_forest(mtry = 5, trees = 10) %>%
        set_engine("ranger", importance = "impurity") %>%
        set_mode("regression")
    randf_workflow <-
        workflow() %>%
        add_model(randf_model) %>%
        add_recipe(norm_recipe)
    # Fit
    set.seed(234)
    randf_fit <-
        randf_workflow %>%
        fit(data=df)
    #Predict
    randf_pred <- reactive({
        disp_input <- input$sliderDISP
        hp_input <- input$sliderHP
        cyl_input <- as.numeric(input$selectCYL)
        drat_input <- input$sliderDRAT
        wt_input <- input$sliderWT
        qsec_input <- input$sliderQSEC
        vs_input <- as.numeric(input$radioVS)
        am_input <- as.numeric(input$radioAM)
        gear_input <- as.numeric(input$selectGEAR)
        carb_input <- as.numeric(input$selectCARB)
        predict(randf_fit,
                new_data = data.frame(
                    disp = disp_input,
                    hp = hp_input,
                    cyl = cyl_input,
                    drat = drat_input,
                    wt = wt_input,
                    qsec = qsec_input,
                    vs = vs_input,
                    am = am_input,
                    gear = gear_input,
                    carb = carb_input))
    })

    output$randf_pred <- renderPrint({
        randf_pred()$.pred

    })
}

shinyApp(ui = ui, server = server)
