library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
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
))
