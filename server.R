library(shiny)
library(ggplot2)
library(data.table)
library(dplyr)
library(maps)
library(rCharts)
library(tidyr)
library(markdown)
library(mapproj)

states_map <- map_data("state")
dt <- read.csv('./data/aggStormData.csv')
dt$EVENT <- tolower(dt$EVENT)
events <<- sort(unique(dt$EVENT))


shinyServer(function(input, output) 
  {
    
    aggByState <- reactive({
        data <- subset(dt, YEAR >= input$range[1] & YEAR <= input$range[2] & EVENT %in% input$events)
        data %>% group_by(STATE) %>% summarise(COUNT=sum(COUNT), INJURIES=sum(INJURIES), FATALITIES=sum(FATALITIES),
                                           PROPDMG=round(sum(PROPDMG), 2), CROPDMG=round(sum(CROPDMG), 2))
  })
  
    aggByYear <- reactive({
        data <- subset(dt, YEAR >= input$range[1] & YEAR <= input$range[2] & EVENT %in% input$events)
        data %>% group_by(YEAR) %>% summarise(COUNT=sum(COUNT), INJURIES=sum(INJURIES), FATALITIES=sum(FATALITIES),
                                           PROPDMG=round(sum(PROPDMG), 2), CROPDMG=round(sum(CROPDMG), 2))  
  })
  
  values <- reactiveValues()
  values$events <- events  

  output$eventsControls <- renderUI({
      checkboxGroupInput('events', 'Event types', events, selected=values$events)
  })  
    
  observe({
      if(input$clear_all == 0) return()
        values$events <- c()
  })
    
  observe({
      if(input$select_all == 0) return()
        values$events <- events
  })
  
  dataTable <- reactive(
    {
    data <- aggByState()
    data$STATE <- state.abb[match(data$STATE, tolower(state.name))]
    data
  })
  
  output$popImpactByState <- renderPlot(
    {
    data <- aggByState()
    if(input$popImpactType == 'both') {
      data$Affected <- data$INJURIES + data$FATALITIES
    } else if(input$popImpactType == 'fatalities') {
      data$Affected <- data$FATALITIES
    } else {
      data$Affected <-data$INJURIES
    }
    
    title <- paste("Population impact between years ", input$range[1], "-", input$range[2], "(number of affected)")
    p <- ggplot(data, aes(map_id = STATE))
    p <- p + geom_map(aes(fill = Affected), map = states_map, colour='black') + expand_limits(x = states_map$long, y = states_map$lat)
    p <- p + coord_map() + theme_bw()
    p <- p + labs(x = "Long", y = "Lat", title = title)
    p <- p + scale_fill_gradient(low = "#FFE5CC", high = "#CC6600")
    print(p)
  })
  
  output$ecoImpactByState <- renderPlot({
    data <- aggByState()
    
    if(input$ecoImpactType == 'both') {
      data$Damages <- data$PROPDMG + data$CROPDMG
    } else if(input$ecoImpactType == 'crops') {
      data$Damages <- data$CROPDMG
    } else {
      data$Damages <- data$PROPDMG
    }
    
    title <- paste("Economic impact between years ", input$range[1], "-", input$range[2], "(Million USD)")
    p <- ggplot(data, aes(map_id = STATE))
    p <- p + geom_map(aes(fill = Damages), map = states_map, colour='black') + expand_limits(x = states_map$long, y = states_map$lat)
    p <- p + coord_map() + theme_bw()
    p <- p + labs(x = "Long", y = "Lat", title = title)
    p <- p + scale_fill_gradient(low = "#FFE5CC", high = "#CC6600")
    print(p)
  })
   
  output$table <- renderDataTable(
  {
    dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 50))

    output$eventsByYear <- renderChart({
        data <- aggByYear() %>% group_by(YEAR) %>% summarise(COUNT=sum(COUNT))
        setnames(data, c('YEAR', 'COUNT'), c("Year", "Count"))
  
    eventsByYear <- nPlot(Count ~ Year,data = data,type = "lineChart", dom = 'eventsByYear', width = 650)
  
    eventsByYear$chart(margin = list(left = 100))
    eventsByYear$yAxis( axisLabel = "Count", width = 80)
    eventsByYear$xAxis( axisLabel = "Year", width = 70)
    return(eventsByYear)
  })

  output$popImpactByYear <- renderChart({
    data <- aggByYear()[, c("YEAR", "INJURIES", "FATALITIES")] %>% gather(variable, value, -YEAR)
    popImpactByYear <- nPlot(value ~ YEAR, group = 'variable', data = data[with(data, order(-YEAR, variable)),],
                type = 'stackedAreaChart', dom = 'popImpactByYear', width = 650)
  
    popImpactByYear$chart(margin = list(left = 100))
    popImpactByYear$yAxis( axisLabel = "Affected", width = 80)
    popImpactByYear$xAxis( axisLabel = "Year", width = 70)
  
    return(popImpactByYear)
  })

  output$ecoImpactByYear <- renderChart({
    data <- aggByYear()[, c("YEAR", "PROPDMG", "CROPDMG")] %>% gather(variable, value, -YEAR)
    ecoImpactByYear <- nPlot(
                value ~ YEAR, group = 'variable', data = data[with(data, order(-YEAR, variable)),],
                type = 'stackedAreaChart', dom = 'ecoImpactByYear', width = 650
    )
    ecoImpactByYear$chart(margin = list(left = 100))
    ecoImpactByYear$yAxis( axisLabel = "Total damage (Million USD)", width = 80)
    ecoImpactByYear$xAxis( axisLabel = "Year", width = 70)
  
    return(ecoImpactByYear)
  })

  output$downloadData <- downloadHandler(filename = './data/data.csv',
    content = function(file) 
    {
        write.csv(dataTable(), file, row.names=FALSE)
    }
  )
})

