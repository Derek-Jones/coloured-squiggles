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
      selectInput("dev_id", label = h3("Device id"), 
        choices = list("Auditorium" = 0,
		       "Mid 1" = 1, "Mid 2" = 2,
                       "Mid 3" = 3, "Standup zone" = 4,
                       "Upper Mezz" = 5, "Joe's desk" = 6,
                       "B Bay 7 7" = 7, "Anastasia's desk" = 8,
                       "B entrance" = 9, "Ground; coffee mac 11" = 10,
                       "Reception" = 11, "B Bay 11" = 12,
                       "Ground: show space 14" = 13, "Maker space" = 14,
                       "Lower mezz" = 15
                       ), selected = 1))
   ),


    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("distLegend")
    )
))

