library(shiny)
library(rCharts)
library(data.table)


shinyUI(fluidPage(
    navbarPage("Storm Database Explorer",
        tabPanel("Plot",
            sidebarPanel(
                sliderInput("range", "Range:", min = 1995, max = 2011, value = c(1995, 2011),sep=""),
                uiOutput("eventsControls"),
                actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
            ),
                      
            mainPanel(tabsetPanel(
                tabPanel("By State",
                    column(3,wellPanel(radioButtons("popImpactType", "Population impact category:",
                        c("Both" = "both", "Injuries" = "injuries", "Fatalities" = "fatalities")))),
                    column(3,wellPanel(radioButtons("ecoImpactType","Economic impact category:",
                        c("Both" = "both", "Property damage" = "property", "Crops damage" = "crops")))),
                    column(11,plotOutput("popImpactByState"),plotOutput("ecoImpactByState"))
                ),
                          
                tabPanel("By Year",
                    h4("Number of events by year", align = "center"),showOutput("eventsByYear", "nvd3"),
                    h4("Population impact by year", align = "center"),showOutput("popImpactByYear", "nvd3"),
                    h4("Economic impact by year", align = "center"),showOutput("ecoImpactByYear", "nvd3")
                ),
                          
                tabPanel('Data',dataTableOutput(outputId="table"),downloadButton('downloadData', 'Download')))
            )
        ),
             
        tabPanel("About",mainPanel(includeMarkdown("README.md")))
    )
)
)