############################
######## Libraries #########
############################

# Load packages used by the app. Install missing packages, if needed.
library(shiny)
library(bslib)
library(thematic)
library(tidyverse)
library(gitlink)
library(shinyBS)
library(shinythemes)
library(googlesheets4)
set.seed(666)

############################
######### Script ###########
############################

# source('myui.R', local = TRUE)
# source('myserver.R')

gs4_auth(cache = ".secrets", email = "afraderasola@gmail.com")

sheet_id <- "https://docs.google.com/spreadsheets/d/1HBo4QRtaiSEl8UA0PHhWbxBtg4BpTKf_7KF1Bny9tRs/edit?gid=0#gid=0"

#### UI ####

ui <- navbarPage(title = "Game board database",
                 theme = shinytheme("lumen"),
                 windowTitle = "Game board database",
                 tabPanel("Chess",
                          fluidRow(column(2,
                                          textInput(
                                            inputId = "chess_date",
                                            label = "Input Date (YYYYMMDD):"
                                          )),
                                   column(2,
                                          selectInput(inputId = "chess_dayeperiod", 
                                                      label = "Select Day period:", 
                                                      choices = c("Morning", "Afternoon", "Evening", "Night")
                                          )),
                                   column(2,
                                          selectInput(inputId = "chess_player", 
                                                      label = "Select Player:", 
                                                      choices = c("Albert", "Emily")
                                          )),
                                   
                                   column(2,
                                          selectInput(inputId = "chess_set", 
                                                      label = "Select Set:", 
                                                      choices = c("White", "Black")
                                          )),
                                   column(2,
                                          selectInput(inputId = "chess_victory", 
                                                      label = "Did you win?", 
                                                      choices = c(T, F)
                                          ))),
                          fluidRow(column(2,
                                          actionButton("submit",
                                                       "Submit"))),
                          fluidRow(column(12,
                                          dataTableOutput("chess_df")))))

server <- function(input, output) {
  
  results <- eventReactive(input$submit, {
    
    data <- data.frame(
      Date = input$chess_date,
      Day_Period = input$chess_dayeperiod,
      Player = input$chess_player,
      Set = input$chess_set,
      Victory = input$chess_victory
    )
    
    sheet_append(sheet_id, data, "Chess")
    
  })
  
  output$chess_df <- renderDataTable({
    results()
    read_sheet(sheet_id)
  })

}


shinyApp(
  ui = ui,
  server = server
)

