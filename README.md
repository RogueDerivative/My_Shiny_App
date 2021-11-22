# My_Shiny_App
Peer Review Project for JH Data Science Specialization thru Coursera

My_Shiny_App uses the mtcars dataset in R and the caret / parsnip package to display a predicted value for the Miles Per Gallon.

The prediction does have default values - all of which can be adjusted. After changes are made the user can hit the SUBMIT button and a new value is produced.
It is important to note that not all predictors are significant at all values. Therefore some adjustments to the input values may not change the predicted MPG value.

# Radio Buttons
The type of transmission and the shape of the engine have tap buttons, where tapping the options changes the input prior to hitting the submit button.

# Select Dropdowns
The number of cylinders, carburetors and gears are dropdown menus

# Slider Values
The remaining predictors all have individual sliders.
Each predictor can be adjusted to the nearest tenth of a value.
Each predictor has minimum and maximum values according to their summary output on the mtcars dataset
