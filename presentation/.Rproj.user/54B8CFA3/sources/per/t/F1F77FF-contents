library(shiny)

shinyServer(function(input, output) {
  
  # ---- BODY FAT CALCULATIONS
  # Age
  age <- reactive({
    as.numeric(difftime(input$date, input$dob)) / 365.25
  })
  
  # Measurements
  cPinchAve <- reactive({
    mean(c(input$cPinch1, input$cPinch2, input$cPinch3))
  })
  aPinchAve <- reactive({
    mean(c(input$aPinch1, input$aPinch2, input$aPinch3))
  })
  tPinchAve <- reactive({
    mean(c(input$tPinch1, input$tPinch2, input$tPinch3))
  })
  sumPinch <- reactive({
    sum(cPinchAve(), aPinchAve(), tPinchAve())
  })
  bodyDensity <- reactive({
    1.10938 - (0.0008267 * sumPinch()) + (0.0000016 * sumPinch()^2) - 0.0002574 * age()
  })
  bodyFat <- reactive({
    (495 / bodyDensity()) - 450
  })
  
  # ---- DATA FRAME ----
  if (file.exists("bodyfat.csv"))
    df0 <- read.csv("bodyfat.csv")[, -1]
  else
    df0 <- data.frame("date"=as.Date(character()), "bodyfat"=as.numeric())
  
  values <- reactiveValues()
  values$df <- df0
  addData <- observe({
    if(input$Submit > 0) {
      newLine <- isolate(c(as.character(input$date), round(bodyFat(), 1)))
      isolate(values$df <- rbind(as.matrix(values$df), unlist(newLine)))
      write.csv(values$df, file = "bodyfat.csv")
    }
  })
  
  # ---- OUTPUTS ----
  output$age <- renderText({
    paste0("    Age: ", round(age(), 1), "years")
    })
  output$bodyfat <- renderText({
    paste0("    Body fat: ", round(bodyFat(), 1), "%")
  })
  output$dataframe <- renderTable({tail(values$df, 5)}, include.rownames=F)
  output$plot1 <- renderPlot({
    plot(as.Date({values$df}[,1]), as.numeric({values$df}[,2]), xlab="Date", ylab="Body fat (%)")
    lines(as.Date({values$df}[,1])[order(as.Date({values$df}[,1]))], as.numeric({values$df}[,2])[order(as.Date({values$df}[,1]))])
  })
})
