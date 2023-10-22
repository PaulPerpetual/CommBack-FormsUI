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
library(ggplot2)
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
      ),
      selectInput("Project", "Select Project ID", 
                  choices = c("All", sort(monitoring_formats$Project_ID))
      ),
      conditionalPanel(
        condition = "input.Project != 'All'",
        selectInput("Question", 
                    "Select Question to check the statistics (frequency)", 
                    choices = c("How aware are you of the project",
                                "How beneficial do you think the project is for you and your community?",
                                "How concerned are you about the project?",
                                "How interested are you to get involved in the project")
        )
      ),
      conditionalPanel(
        condition = "input.Project != 'All'",
        plotOutput("barChart")
      )
    ),
    mainPanel(
      leafletOutput("map", height = "90vh")

    )
  )
)  


server <- function(input, output, session) {
  filtered_monitoring_formats <- reactive({
    if (input$Project == "All") {
      return(monitoring_formats)
    } else {
      monitoring_formats[monitoring_formats$Project_ID == input$Project, ]
    }
  })
  
  output$map <- renderLeaflet({
    state_popup2 <- paste0("<img src='", filtered_monitoring_formats()$pic_url, "' width='200px' height='auto'>", "<br>", "<br>",
                           "<strong>Project ID: </strong>", "<br>", filtered_monitoring_formats()$Project_ID, "<br>", "<br>",
                           "<strong>Monitoring feedback: </strong>", "<br>", filtered_monitoring_formats()$description, "<br>", "<br>",
                           "<strong>How aware are you of the project: </strong>", "<br>", filtered_monitoring_formats()$Q1, "<br>", "<br>",
                           "<strong>Can you briefly explain your understanding of how the project works and its goals?: </strong>", "<br>", filtered_monitoring_formats()$Q2, "<br>", "<br>",
                           "<strong>How beneficial do you think the project is for you and your community?: </strong>", "<br>", filtered_monitoring_formats()$Q3, "<br>", "<br>",
                           "<strong>How concerned are you about the project?: </strong>", "<br>", filtered_monitoring_formats()$Q4, "<br>", "<br>",
                           "<strong>How interested are you to get involved in the project?: </strong>", "<br>", filtered_monitoring_formats()$Q5,"<br>", "<br>"
    )
    
    basemap_provider <- switch(input$basemap,
                               "OpenStreetMap" = providers$OpenStreetMap,
                               "CartoDB.Positron" = providers$CartoDB.Positron,
                               "World Imagery" = providers$Esri.WorldImagery)
    
    
    m_feedback <- leaflet(filtered_monitoring_formats()) %>%
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

  output$barChart <- renderPlot({
    if (input$Question != "All") {
      question <- switch(input$Question,
                         "How aware are you of the project" = "Q1",
                         "How beneficial do you think the project is for you and your community?" = "Q3",
                         "How concerned are you about the project?" = "Q4",
                         "How interested are you to get involved in the project?" = "Q5"
      )
      
      question_data <- table(filtered_monitoring_formats()[[question]])
      bar_data <- data.frame(Value = as.numeric(names(question_data)), Frequency = as.numeric(question_data))
      bar_data$Question <- question
      bar_data$Value <- factor(bar_data$Value, levels = unique(bar_data$Value))
      
      ggplot(bar_data, aes(x = Value, y = Frequency)) +
        geom_bar(stat = "identity", fill = "lightgreen") +
        theme_minimal()
    }
  })
}



shinyApp(ui = ui, server = server)