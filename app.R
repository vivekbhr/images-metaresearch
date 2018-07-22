library(shiny)
library(shinyjs)
library(shinychecklist)
library(googlesheets)
# Define the storage type
store <- list(type = STORAGE_TYPES$GOOGLE_SHEETS,
              path = "responses",
              key = "19z3LdAO9rhAj7bcoHwjGo_xTGcoLOqXHjVjQElnd1nE")


## get checklist info from yaml
checklist <- getquestions("checklist.yaml")

## create a help text for sidebar panel
helptext <- HTML(readLines("help_text.html"))

## create form
basicInfoForm <- list(
  id = "checklist",
  questions = checklist$questions,
  storage = store,
  name = "#eLifeAmbassadors imaging meta-research abstraction form",
  password = "shinychecklist",
  reset = TRUE)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.panel === "Checklist"',
        helpText(helptext)
      ),
      conditionalPanel(
        'input.panel === "Results"',
        checkboxGroupInput("show_vars", "Columns in the table to show:",
                           checklist$ids, selected = checklist$ids[1:2])
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'panel',
        tabPanel("Checklist", formUI(formInfo = basicInfoForm)),
        tabPanel("Results", DT::dataTableOutput('table'))
      )
    )
  )
)

server <- function(input, output, session) {
  formServer(basicInfoForm)
  
  output$table <- DT::renderDataTable({
    DT::datatable(
      loadData(basicInfoForm$storage)[, input$show_vars, drop = FALSE],
      rownames = FALSE,
      options = list(searching = TRUE,
                     lengthChange = TRUE,
                     scrollX = TRUE,
                     orderClasses = TRUE)
    )
  })
}


## App
shinyApp(ui = ui, server = server)
