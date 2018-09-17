library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Body Fat Tracking (Male)"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      h4("User input:"),
      
      # Dates
      fluidRow(
        column(width=6,
               dateInput(inputId="dob", label="DOB:", value="1984-02-21")),
        column(width=6,
               dateInput(inputId="date", label="Date:", value=Sys.Date(), max=Sys.Date()))),
      
      # Measurements 1
      fluidRow(h5("Measurements 1 (mm)"),
               column(width=4,
                      numericInput(inputId="cPinch1", label="Chest:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="aPinch1", label="Abdomen:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="tPinch1", label="Thigh:", 
                                   value=100, min=0, max=100))),
      
      # Measurements 2
      fluidRow(h5("Measurements 2 (mm)"),
               column(width=4,
                      numericInput(inputId="cPinch2", label="Chest:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="aPinch2", label="Abdomen:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="tPinch2", label="Thigh:", 
                                   value=100, min=0, max=100))),
      
      # Measurements 3
      fluidRow(h5("Measurements 3 (mm)"),
               column(width=4,
                      numericInput(inputId="cPinch3", label="Chest:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="aPinch3", label="Abdomen:", 
                                   value=100, min=0, max=100)),
               column(width=4,
                      numericInput(inputId="tPinch3", label="Thigh:", 
                                   value=100, min=0, max=100))),

      actionButton("Submit", ("Submit"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
    ),
    
    # Main panel
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Results", 
                           fluidRow(
                             column(width=3, 
                                    h3("Current results:"),
                                    textOutput("age"),
                                    textOutput("bodyfat"),
                                    br(),
                                    h3("Recent values:"),
                                    tableOutput("dataframe")),
                             column(width=9,
                                    h3("Body fat chart:"),
                                    plotOutput("plot1", width="100%"))),
                           h4("Source files: ", a("https://github.com/stevebachmeier/maleBodyFatShinyApp", href="https://github.com/stevebachmeier/maleBodyFatShinyApp"))),
                  
                  tabPanel("Help", 
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
