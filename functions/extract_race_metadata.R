# Extract race metadata from split time PDF
extract_race_metadata <- function(source_pdf){
  
  library(tabulizer)
  
  unlist(
    extract_tables(
    source_pdf,
    pages = 1,
    area = list(c(126, 35, 201, 577)),
    guess = FALSE,
    output = "data.frame")
    )
  
}