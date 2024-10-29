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
library(plotly)
set.seed(666)

############################
######### Script ###########
############################

gs4_auth(cache = ".secrets", email = "afraderasola@gmail.com")

sheet_id <- "https://docs.google.com/spreadsheets/d/1HBo4QRtaiSEl8UA0PHhWbxBtg4BpTKf_7KF1Bny9tRs/edit?gid=0#gid=0"

ui <- navbarPage(title = "Game board database",
                 theme = shinytheme("lumen"),
                 windowTitle = "Game board database",
                 tabPanel("Chess",
                          tabsetPanel(
                            tabPanel("Overview",
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))),
                                     fluidRow(column(12,
                                                     HTML("<h4><b>Victory barplots</b></h4>"))),
                                     fluidRow(column(12,
                                                     plotlyOutput("chess_victoryBarplot",height = "750px")
                                     )),
                                     fluidRow(column(4,
                                                     plotlyOutput("chess_bwBarplot",height = "1000px")),
                                              column(8,
                                                     plotlyOutput("chess_dpBarplot",height = "1000px"))),
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;")))),
                            tabPanel("Data input",
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))),
                                     fluidRow(column(2,
                                                     textInput(
                                                       inputId = "chess_date",
                                                       label = "Input Date (YYYYMMDD):"
                                                     )),
                                              column(2,
                                                     selectInput(inputId = "chess_dayperiod", 
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
                                                     actionButton("chess_submit",
                                                                  "Submit"))),
                                     fluidRow(column(12,
                                                     dataTableOutput("chess_df"))),
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;")))))),
                 tabPanel("Calico",
                          tabsetPanel(
                            tabPanel("Overview",
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))),
                                     fluidRow(column(12,
                                                     HTML("<h4><b>Victory barplots</b></h4>"))),
                                     fluidRow(column(12,
                                                     plotlyOutput("calico_victoryBarplot",height = "750px")
                                     )),
                                     fluidRow(column(8,
                                                     plotlyOutput("calico_dpBarplot",height = "1000px"))),
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;")))),
                            tabPanel("Data input",
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))),
                                     fluidRow(column(2,
                                                     textInput(
                                                       inputId = "calico_date",
                                                       label = "Input Date (YYYYMMDD):"
                                                     )),
                                              column(2,
                                                     selectInput(inputId = "calico_dayperiod", 
                                                                 label = "Select Day period:", 
                                                                 choices = c("Morning", "Afternoon", "Evening", "Night")
                                                     )),
                                              column(2,
                                                     selectInput(inputId = "calico_player", 
                                                                 label = "Select Player:", 
                                                                 choices = c("Albert", "Emily")
                                                     )),
                                              column(2,
                                                     textInput(
                                                       inputId = "calico_hexagon",
                                                       label = "Input Hexagon points:"
                                                     )),
                                              column(2,
                                                     textInput(
                                                       inputId = "calico_katze",
                                                       label = "Input Katze points:"
                                                     )),
                                              column(2,
                                                     textInput(
                                                       inputId = "calico_button",
                                                       label = "Input Button points:"
                                                     ))),
                                     fluidRow(column(2,
                                                     actionButton("calico_submit",
                                                                  "Submit"))),
                                     fluidRow(column(12,
                                                     dataTableOutput("calico_df"))),
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))))))
                 )
