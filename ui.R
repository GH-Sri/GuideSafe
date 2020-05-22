# UI 
source("initialize.R")

ui <- fluidPage(titlePanel("GuideSight Route Risk Visualization"),
                theme = shinytheme("journal"),
        fluidRow(
            column(4,
                fluidRow(
                  column(12,
                    wellPanel(
                    helpText(
                    h3("Determine the safest route to your 
                     destination based on historical traffic data.")),
                
                   textInput("origin", label = h4("Origin:"),
                      value = "1730 Pennsylvania Avenue NW, Washington, DC"),
                   
                   textInput("destination", label = h4("Destination:"), 
                      value = ""),
                                    
                   actionButton("go", 
                      "Calculate Route Risk Assessment", 
                      class="btn btn-primary")
                                  )),
                fluidRow(
                  column(12, 
                      tableOutput("riskTable")
                             )
                           )
                         )),
                  column(8,
                         leafletOutput("mymap", height = "800px")
                  )
                ))