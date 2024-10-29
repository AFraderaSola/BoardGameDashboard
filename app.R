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

source('myui.R', local = TRUE)
source('myserver.R')

gs4_auth(cache = ".secrets", email = "afraderasola@gmail.com")

sheet_id <- "https://docs.google.com/spreadsheets/d/1HBo4QRtaiSEl8UA0PHhWbxBtg4BpTKf_7KF1Bny9tRs/edit?gid=0#gid=0"

shinyApp(
  ui = ui,
  server = server
)

