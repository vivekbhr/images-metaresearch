library(shiny)
library(shinyjs)
library(shinychecklist)
library(googlesheets)
## create a google sheet
checklist_data <- gs_new(title = "imaging_review", 
                        ws_title = "imaging_review",
                        row_extent = 1000,
                        col_extent = 100,
                        trim = TRUE, verbose = FALSE)

## prepare the OAuth token and set up the target sheet:
##  - do this interactively
##  - do this EXACTLY ONCE

# shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
# saveRDS(shiny_token, "shiny_app_token.rds")

## if you version control your app, don't forget to ignore the token file!
## e.g., put it into .gitignore

#googlesheets::gs_auth(token = "shiny_app_token.rds")

# Define the storage type
store <- list(type = STORAGE_TYPES$GOOGLE_SHEETS,
              path = "responses",
              key = "19z3LdAO9rhAj7bcoHwjGo_xTGcoLOqXHjVjQElnd1nE")


## get checklist info from yaml
checklist <- getquestions("checklist.yaml")

## create form
basicInfoForm <- list(
  id = "checklist",
  questions = checklist$questions,
  storage = store,
  name = "#eLifeAmbassadors computational reproducibility checklist",
  password = "shinychecklist",
  reset = TRUE)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.panel === "Checklist"',
        helpText("This is the #eLifeAmbassadors imaging meta-research 
                 abstraction form.")
      ),
      conditionalPanel(
        'input.panel === "Results"',
        checkboxGroupInput("show_vars", "Columns in the table to show:",
                           checklist$qtitles, selected = checklist$qtitles[1:2])
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
