
library(shiny)

shinyServer(function(input, output) {
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
})
