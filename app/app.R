#' ---
#' title: "Exercise 5: Build a Shiny App"
#' author: "Gestione Energetica ed Automazione negli Edifici (GEAE) A.A. 2022/2023"
#' ---
#' Tutto il materiale didattico messo a disposizione degli studenti (compresi i video e le Virtual Classroom) e' da utilizzarsi esclusivamente per scopi didattici.
#' E' vietata ogni forma di redistribuzione e pubblicazione on line (ogni violazione sara' perseguita ai sensi di legge).

library(shiny)
library(dplyr)
library(lubridate)
library(magrittr)
library(ggplot2)


ui <- fluidPage(
  h2("PoliTO Electrical Energy Exploration Tool"),
  helpText(
    "This app demonstrate how to actively interact with data and change the type of visualization. The data used refers to the PoliTo substation C electrical loads."
  ),
  
  fluidRow(
    column(
      width = 4,
      selectInput(
        inputId = "variable",
        label = "Select a variable:",
        choices = c("Total Power" = "TotalP", "Chiller" = "ChillerP")
      )
    ),
    column(
      width = 4,
      dateRangeInput(
        inputId = "daterange",
        label = "Date range:",
        start = "2016-03-01",
        end   = "2016-03-31"
      )
    ),
    column(
      width = 4,
      sliderInput(
        inputId = "bins",
        label = "Select the number of bins:",
        min = 10,
        max = 100,
        value = 80
      )
    )
  ),
  
  
  column(width = 8, style = "padding-left:0px; padding-right:0px;",
         plotOutput("lineplot")),
  column(width = 4, style = "padding-left:0px; padding-right:0px;",
         plotOutput("histogram"))
  
)

server <- function(input, output) {
  # load data
  df <-
    read.csv("data.csv", dec = ',', sep = ';') %>%
    mutate(
      DateTime = as.POSIXct(DateTime, format = '%Y-%m-%d %H:%M', tz = 'GMT'),
      Date = as.Date(DateTime)
    )
  
  # define plot 1 histogram
  output$histogram <- renderPlot({
    df %>%
      filter(Date >= input$daterange[1] &
               Date <= input$daterange[2]) %>%
      ggplot() +
      geom_histogram(
        aes_string(y = input$variable),
        color = "white",
        fill = "#69b3a2",
        bins = input$bins
      ) +
      theme_minimal() +
      theme(panel.grid.minor = element_line(size = 0.1, color = "gray")) +
      labs(y = NULL, x = "Count")
  })
  
  # define plot 1 line plot
  output$lineplot <- renderPlot({
    df %>%
      filter(Date >= input$daterange[1] &
               Date <= input$daterange[2]) %>%
      ggplot() +
      geom_line(aes_string(x = "DateTime", y = input$variable),
                color = "#69b3a2",
                size = 0.8) +
      theme_minimal() +
      theme(panel.grid.minor = element_line(size = 0.1, color = "gray")) +
      labs(y = "Electrical load [kW]", x = "Time")
  })
  
}

shinyApp(ui = ui, server = server)
