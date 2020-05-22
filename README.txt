# (1) Here are the libraries you need 
library(shiny)
library(shinythemes)
library(leaflet)
library(RColorBrewer)
library(leaflet)
library(maptools)
library(leaflet.extras)
library(rgdal)
library(sp)
library(RColorBrewer)
library(readr)
library(ks)
library(MASS)
library(mapsapi)
library(dplyr)
library(rgeos)
library(stringr)
library(here) 

# (2) THE BEST WAY to run the app: 
    #  open the RouteRisk R Project in R Studio,
    # then open the run script (run.R) and select the run app button. 

# (3) The cleanups I made were to separate the scripts,
# remove duplicate code that slowed things down 
# lined up the code to be 80 char compliant and set a seed for reproducibility. 
# I also moved the API key to the initialize script that 
# sources the libraries and some initial random sampling. 
