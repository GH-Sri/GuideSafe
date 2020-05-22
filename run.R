require(shiny)
require(usethis) # for here, runs the app in browser from this project directory
folder_address = here()   
runApp(folder_address, launch.browser=TRUE)
