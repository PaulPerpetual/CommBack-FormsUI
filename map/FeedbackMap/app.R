# ============================================================================
# Visualize the distribution of local community monitoring issues in the map
# ============================================================================

# ============================================================================
# ============================================================================

############## 1) CLEAR WORKSPACE ############################################


rm(list=ls())
if (length(dev.list()["RStudioGD"]) > 0) {
  dev.off(dev.list()["RStudioGD"])
}


########## 2) LOAD LIBRARIES #####################################################

library(shiny)
library(rsconnect)
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(profvis)
library(here)
library(leaflet)
library(leaflet.extras)
library(rsconnect)
library(imager)


######### 3) LOAD FILE ######################################################
here::here()

monitoring_formats <- read.csv('data/monitoring_formats.csv')
local_image_dir <- "data/picture"

######### 4) R Shiny WEB APP ######################################################

ui <- fluidPage(
  titlePanel("Monitoring Feedback Map"),
  theme = shinythemes::shinytheme("readable"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("basemap", "Select Basemap", 
                  choices = c("World Imagery", "OpenStreetMap", "CartoDB.Positron")
                  # Add more basemap options here if needed
      )
    ),
    mainPanel(
      leafletOutput("map", height = "90vh")
    )
  )
)




server <- function(input, output, session) {

  output$map <- renderLeaflet({
    state_popup2 <- paste0("<img src='", monitoring_formats$pic_url, "' width='200px' height='auto'>", "<br>", "<br>",
                           "<strong>Project ID: </strong>", "<br>", monitoring_formats$Project_ID, "<br>", "<br>",
                           "<strong>Monitoring feedback: </strong>", "<br>", monitoring_formats$description, "<br>", "<br>",
                           "<strong>How aware are you of the project: </strong>", "<br>", monitoring_formats$Q1, "<br>", "<br>",
                           "<strong>Can you briefly explain your understanding of how the project works and its goals?: </strong>", "<br>", monitoring_formats$Q2, "<br>", "<br>",
                           "<strong>How beneficial do you think the project is for you and your community?: </strong>", "<br>", monitoring_formats$Q3, "<br>", "<br>",
                           "<strong>How concerned are you about the project?: </strong>", "<br>", monitoring_formats$Q4, "<br>", "<br>",
                           "<strong>How interested are you to get involved in the project?: </strong>", "<br>", monitoring_formats$Q5,"<br>", "<br>"
    )

    basemap_provider <- switch(input$basemap,
                               "OpenStreetMap" = providers$OpenStreetMap,
                               "CartoDB.Positron" = providers$CartoDB.Positron,
                               "World Imagery" = providers$Esri.WorldImagery)
    

    m_feedback <- leaflet(monitoring_formats) %>%
      addProviderTiles(basemap_provider) %>%
      setView(8.054822, 46.811010, 8) %>%
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        radius = 5,
        color = "red",
        stroke = FALSE, fillOpacity = 0.5,
        popup = state_popup2
      )
    return(m_feedback)
  })
}





shinyApp(ui = ui, server = server)