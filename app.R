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

# source('myui.R', local = TRUE)
# source('myserver.R')

gs4_auth(cache = ".secrets", email = "afraderasola@gmail.com")

sheet_id <- "https://docs.google.com/spreadsheets/d/1HBo4QRtaiSEl8UA0PHhWbxBtg4BpTKf_7KF1Bny9tRs/edit?gid=0#gid=0"

#### UI ####

ui <- navbarPage(title = "Game board database",
                 theme = shinytheme("lumen"),
                 windowTitle = "Game board database",
                 tabPanel("Chess",
                          tabsetPanel(
                            tabPanel("Overview",
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;"))),
                                     fluidRow(column(12,
                                                     HTML("<h4><b>Victory barplot</b></h4>"))),
                                     fluidRow(column(4,
                                                     plotlyOutput("chess_victoryBarplot",height = "1000px")
                                                     ),
                                              column(8,
                                                     plotlyOutput("chess_bwBarplot",height = "1000px")
                                              )),
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
                                                     actionButton("chess_submit",
                                                                  "Submit"))),
                                     fluidRow(column(12,
                                                     dataTableOutput("chess_df"))),
                                     fluidRow(column(12,
                                                     tags$hr(style="border-color: darkgrey;")))))))

server <- function(input, output) {
  
  chess_inputData <- eventReactive(input$chess_submit, {
    
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
    chess_inputData()
    read_sheet(sheet_id)
  })
  
  chess_Data <- reactive({
    read_sheet(sheet_id,sheet = "Chess")
  })
  
  output$chess_victoryBarplot <- renderPlotly({
    
    chess_df <- chess_Data()
    
    chess_bp_df <- chess_df |> 
      group_by(Player, Victory) |> 
      tally()
    
    chess_bp_df$Victory <- factor(x = chess_bp_df$Victory, levels = c("FALSE", "TRUE"))
    
    chess_max <- chess_df |> 
      group_by(Player) |> 
      tally()
    
    chess_max <- max(chess_max$n)
    
    chess_bp <- ggplot(chess_bp_df, aes(fill=Victory, y=n, x=Player)) + 
      geom_bar(position="stack", stat="identity")+
      ylab("Number of matches")+
      scale_fill_brewer(palette = "Accent",
                        direction = -1,
                        name="",
                        labels=c("Loss", "Victory"))+
      scale_y_continuous(limits = c(0,chess_max),breaks = seq(0, chess_max, by = 1))+
      theme_minimal()+
      theme(axis.text=element_text(size=18),axis.title=element_text(size=20,face="bold"))+
      theme(legend.title = element_text(size = 16, face = "bold"),
            legend.text = element_text(size = 14),
            legend.key.size = unit(1, 'cm'),
            legend.position = "none")
    
    
    print(chess_bp)
    
  })
  
  output$chess_bwBarplot <- renderPlotly({
    
    chess_df <- chess_Data()
    
    chess_bp_df <- chess_df |> 
      group_by(Player, Set, Victory) |> 
      tally()
    
    chess_bp_df$Victory <- factor(x = chess_bp_df$Victory, levels = c("FALSE", "TRUE"))
    
    chess_max <- chess_df |> 
      group_by(Player) |> 
      tally()
    
    chess_max <- max(chess_max$n)
    
    chess_bp <- ggplot(chess_bp_df, aes(fill=Victory, y=n, x=Player)) +
      facet_wrap(~Set)+
      geom_bar(position="stack", stat="identity")+
      ylab("Number of matches")+
      scale_fill_brewer(palette = "Accent",
                        direction = -1,
                        name="",
                        labels=c("Loss", "Victory"))+
      scale_y_continuous(limits = c(0,chess_max),breaks = seq(0, chess_max, by = 1))+
      theme_minimal()+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            strip.text = element_text(size = 20), face = "bold")+
      theme(legend.title = element_text(size = 16, face = "bold"),
            legend.text = element_text(size = 14),
            legend.key.size = unit(1, 'cm'),
            legend.position = "none")
    
    
    print(chess_bp)
    
  })

}


shinyApp(
  ui = ui,
  server = server
)

