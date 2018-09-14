library(shiny)

# ---- UI ----
ui <- fluidPage(
  titlePanel("Body Fat Tracking (Male)"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      h3("User inputs"),
      dateInput(inputId="dob", label="DOB:", value="1980-01-01",
                min="1900-01-01", max=Sys.Date(), weekstart=0),
      dateInput(inputId="date", label="Date:", value=Sys.Date(),
                min="1900-01-01", max=Sys.Date(), weekstart=0),
      numericInput(inputId="cPinch1", label="Chest measurement 1 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="aPinch1", label="Abdominal measurement 1 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="tPinch1", label="Thigh measurement 1 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="cPinch2", label="Chest measurement 2 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="aPinch2", label="Abdominal measurement 2 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="tPinch2", label="Thigh measurement 2 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="cPinch3", label="Chest measurement 3 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="aPinch3", label="Abdominal measurement 3 (mm):", value=100,
                   min=0, max=100),
      numericInput(inputId="tPinch3", label="Thigh measurement 3 (mm):", value=100,
                   min=0, max=100),
      actionButton("Submit", ("Submit"))
    ),
    
    # Main panel
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Results", br(), 
                           fluidRow(
                             column(width=3, 
                                    h3("Current results:"),
                                    p("Check this before clicking 'Submit'!"),
                                    textOutput("age"),
                                    textOutput("bodyfat"),
                                    br(),
                                    h3("Recent values:"),
                                    p("This shows the previous 5 inputs submitted."),
                                    tableOutput("dataframe")),
                             column(width=9,
                                    h3("Plot"),
                                    plotOutput("plot1", width="100%")))),
                  
                  tabPanel("Help", br(), 
                           h3("Background"),
                           p("This app takes user age and skin fold thickness 
                             data to approximate body fat percentage. It applies 
                             the popular Jackson-Pollock 3-fold method as outlined 
                             in 'Generalized equations for predicting body density 
                             of men' (Jackson, A.S. and Pollock, M.L., Accepted 28 
                             February 1978, British Journal of Nutrition"),
                           p(em("Note that this app is designed specifically for males; 
                                the equation used for females is similar but different.")),
                           
                           h3("Instructions"),
                           p("1. If desired, save an existing data set in the same folder as this app's ui.R and server.R files (note that if no file exists one will be created as the user submits data). This data set must be a comma-separated value file and be named 'bodyfat.csv.' It must contain three columns of data in the following order: an explicit column of indices, a column title 'date' with dates in YYYY-MM-DD format, and a column titled 'bodyfat' with numeric values."), 
                           p("2. Input date of birth."),
                           p("3. Input date of measurements."),
                           p("4. Using body fat calipers, measure the thickness (in millimeters) of a diagonal skin fold at the chest located between the nipple and the upper pectoral muscle. Input this value in the appropriate box."),
                           p("5. Measure the thickness of a vertical skin fold at the abdomen located 25mm right of the navel. Input this value."),
                           p("6. Measure the thickness of a vertical skin fold at the thigh located between the patella (knee cap) and the inguinal crease (where the thigh connects with the hip)."),
                           p("7. Repeat steps 4-6 two more times. You should have a total of nine skin fold measurements (three per location)."),
                           p("8. Double check that your age is correct and that the calculated body fat percentage seems reasonable in the main panel."),
                           p("9. Click the submit button.")
                           )
                  )
    )
  )
)

# ---- SERVER ----
server <- function(input, output) {
  
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
}

shinyApp(ui=ui, server=server)