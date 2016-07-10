#
# ui.R
#


shinyUI(fluidPage(

  # Application title
  titlePanel("Building environment history"),

 fluidRow(
    
     column(3,
       dateRangeInput("dates", label = h3("Start/End date"))),
   
    column(3,
      selectInput("dev_id", label = h3("Device location"), 
        choices = list("Auditorium" = 0,
		       "Mid 1" = 1, "Mid 2" = 2,
                       "Mid 3" = 3, "Standup zone" = 4,
                       "Upper Mezz" = 5, "Joe's desk" = 6,
                       "B Bay 7 7" = 7, "Anastasia's desk" = 8,
                       "B entrance" = 9, "Ground; coffee mac 11" = 10,
                       "Reception" = 11, "B Bay 11" = 12,
                       "Ground: show space 14" = 13, "Maker space" = 14,
                       "Lower mezz" = 15
                       ), selected = 1)),

    column(3,
      checkboxGroupInput("sensor_list", label = h3("Sensors"), 
        choices = list(
		"Noise level"= 7,
		"Temperature"= 12,
		"Humidity"= 13,
		"Light level"= 14,
		"Nitrogen dioxide"= 15,
		"Carbon monoxide"= 16,
		"Battery"= 17,
		"Solar panel"= 18,
		"Networks"= 21
                       ), selected = 7))
   ),


    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("distLegend")
    )
))

