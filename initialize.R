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

numextract <- function(string){ 
  str_extract(string, "\\-*\\d+\\.*\\d*")
}


#### TRY TO ADD FOURTH COLUMN WITH ROUTE RISK AND TRIP RISK
#### SEE IF COLOR CAN BE ASSIGNED BASED ON RISK

api_key = "AIzaSyCvKMqqseTzgReHN4lpsW-Eyl7FMUAFHv4"

set.seed(4) # reproducible 
df <- read_csv("Crashes_in_DC.csv")
df2 <- df[!is.na(df$LATITUDE) & !is.na(df$LONGITUDE),]

temp <- df2[df2$MAJORINJURIES_DRIVER>0,]

if(nrow(temp)>5000){
  temp <- temp[sample(nrow(temp), 5000),]
}

maplims <- c(38.79, 39.01, -77.13, -76.9)

kde_sample <- temp[sample(nrow(temp), (nrow(temp)/5)), ]
silverman <- 1.06 * sd(kde_sample$LATITUDE) * 
  (length(kde_sample$LATITUDE)^(-1/5))
kde_final <- kde2d(kde_sample$LATITUDE, 
                   kde_sample$LONGITUDE, n = 750,
                   h = silverman, lims = maplims)




