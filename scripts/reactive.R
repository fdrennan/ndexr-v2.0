library(shiny)
library(scales)
library(cli)
library(fs)
library(shinycssloaders)
library(shinyBS)
library(scales)
library(jsonlite)
library(DT)
library(dplyr)
library(uuid)
library(dbplyr)
library(dplyr)
library(readxl)



# Define UI for application that draws a histogram
ui <- fluidPage(
  h1("Input Data"),
  fileInput("file1", "Choose CSV File",
    accept = ".csv"
  ),
  checkboxInput("header", "Header", TRUE),
  actionButton("submit", "Submit"),
  dataTableOutput("contents"),
  uiOutput("columnNames")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  input_data <- eventReactive(input$submit, {
    file <- req(input$file1)
    ext <- tools::file_ext(file$datapath)
    req(file)
    # browser()
    readxl::read_excel(file$datapath)
  })

  output$contents <- renderDT({
    input_data()
  })


  output$columnNames <- renderUI({
    req(input_data())
    data <- input_data()
    nd <- names(data)
    fluidRow(
      h1("Analysis"),
      selectizeInput(
        "colNames", "Column Names",
        selected = nd,
        choices = nd,
        options = list(create = TRUE),
        multiple = TRUE
      ),
      plotOutput("plots"),
      downloadButton("downloadData", "Download")
    )
  })


  editedData <- eventReactive(input$colNames, {
    input_data() %>%
      select(input$colNames)
  })
  output$plots <- renderPlot({
    req(input$colNames)
    editedData() %>%
      plot()
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("export_", as.integer(Sys.time()), ".csv")
    },
    content = function(file) {
      write.csv(editedData(), file, row.names = FALSE)
    }
  )

  # eventReactive(input$email, {
  #     send.mail(from = "drennanfreddy@gmail.com",
  #               to = "drennanfreddy@gmail.com",
  #               subject = "Hello from R",
  #               body = "This message was \nsent from R",
  #               smtp = list(host.name = "smtp.gmail.com", port = 465,
  #                           user.name = "drennanfreddy@gmail.com",
  #                           passwd = "AeliaEmerson32",
  #                           ssl = TRUE),
  #               authenticate = TRUE,
  #               send = TRUE,
  #               attach.files = c('C:/Users/Redbock/Documents/gmailr/gmailsend.R', 'C:/Users/Redbock/Documents/gmailr/hello.txt'))
  #
  #
  # })
}

# Run the application
shinyApp(ui = ui, server = server)
