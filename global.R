# nr <- 1000
# nc <- 100
# filler <- matrix("-", nrow = n, ncol = n,
#                 dimnames = list(NULL, paste0("V", seq_len(n))))
## create a google sheet
#checklist_data <- gs_new(title = "imaging_review", 
#                        ws_title = "imaging_review",
#                        row_extent = nr,
#                        col_extent = nc,
#                        trim = TRUE, verbose = FALSE)

## prepare the OAuth token and set up the target sheet:
##  - do this interactively
##  - do this EXACTLY ONCE

# shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
# saveRDS(shiny_token, "shiny_app_token.rds")

## if you version control your app, don't forget to ignore the token file!
## e.g., put it into .gitignore

googlesheets::gs_auth(token = "shiny_app_token.rds")
sheet_key <- "19z3LdAO9rhAj7bcoHwjGo_xTGcoLOqXHjVjQElnd1nE"
ss <- googlesheets::gs_key(sheet_key)