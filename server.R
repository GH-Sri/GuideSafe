# Server 


server <- function(input, output, session) {
  
  palette.function = colorRampPalette(rev(brewer.pal(11, 'Spectral')))
  heat.colors = palette.function(64)
  
  
  output$mymap <- renderLeaflet({
    
    leaflet(temp) %>% 
      addProviderTiles(providers$OpenStreetMap) %>% 
      fitBounds(min(temp$LONGITUDE), min(temp$LATITUDE), max(temp$LONGITUDE),
                max(temp$LATITUDE)) %>% 
      hideGroup("Display Threat Zones") %>% 
      addWebGLHeatmap(lng = temp$LONGITUDE, 
                      lat = temp$LATITUDE,
                      size = 500, opacity = .5, 
                      group = "Display Threat Zones") %>% 
      addLayersControl(
        overlayGroups = c("Display Threat Zones"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  observeEvent(input$go, {
    
    directions <- mp_directions(origin = input$origin,
                                destination = input$destination, 
                                alternatives = T, key = api_key)
    
    # DEPRECATED 
    ###     HARD CODE TIME OF DAY
    ###     directions <- mp_directions(origin = input$origin,
    ### destination = input$destination, alternatives = T, key = api_key)
    
    routes <- mp_get_routes(directions)
    
    # Get the origin and destination coordinates
    a <- 1
    b <- (length(routes$geometry[[1]])/2)+1
    
    c <- (length(routes$geometry[[1]])/2)
    d <- length(routes$geometry[[1]])/1
    
    routes_list <- as.list(routes$alternative_id)
    
    kde <- data.frame(Lat = kde_final$x, Lon = kde_final$y)
    
    RiskScore <- c()
    
    for(k in routes_list){
      lat <- c()
      lon <- c()
      
      i <- 1
      j <- 1
      
      total <- length(routes$geometry[[k]])
      half <- total / 2
      
      for(i in 1:half){
        lon[[i]] <- routes$geometry[[k]][[i]]
      }
      
      for(i in (half+1):total){
        lat[[j]] <- routes$geometry[[k]][[i]]
        j <- j + 1
      }
      
      route_coords <- data.frame(Lat = lat, Lon = lon)
      
      set1sp <- SpatialPoints(kde)
      set2sp <- SpatialPoints(route_coords)
      route_coords$idx <- apply(gDistance(set1sp,
                                          set2sp, byid = TRUE),
                                MARGIN =  1,FUN = which.min)
      
      score <- route_coords %>% 
        mutate(Risk = log(kde_final$z[route_coords$idx], .01))
      
      RiskScore[[k]] <- sum(score$Risk)/total
    }
    
    results <- data.frame("Route" = routes$alternative_id, 
                          "Description" = routes$summary,
                          "Distance" = routes$distance_text, 
                          "Duration" = routes$duration_text, 
                          "Risk Score" = RiskScore, stringsAsFactors = FALSE)
    
    colnames(results) <- c("Route", "Summary", 
                           "Distance", "Duration", "Trip Risk")
    
    results <- results %>% 
      mutate("Route Risk" = `Trip Risk` / 
               as.numeric(numextract(results$Distance))) %>% 
      select(Route, Summary, Distance, 
             Duration, `Route Risk`, `Trip Risk`) %>% 
      arrange(-desc(`Trip Risk`))
    
    tripRisk <- rev(results$Route)
    
    pal <- c("red", "yellow", "green")
    
    leafletProxy("mymap") %>%
      clearMarkers() %>% 
      clearShapes() %>% 
      addMarkers(routes$geometry[[1]][a], 
                 routes$geometry[[1]][b]) %>% 
      addMarkers(routes$geometry[[1]][c], 
                 routes$geometry[[1]][d]) %>% 
      addPolylines(data = routes[tripRisk, ], 
                   opacity = 1, weight = 5, color = pal, 
                   label = paste0("#", 
                                  routes$alternative_id[tripRisk],
                                  " ", routes$summary[tripRisk]),
                   labelOptions = labelOptions(textsize = "16px"))    
    
    output$riskTable <- renderTable({
      results %>% 
        arrange(-desc(`Trip Risk`))
    }
    )
    
  })
  
}