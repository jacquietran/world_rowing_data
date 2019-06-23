# Extract race results from split time PDF
extract_race_results <- function(source_pdf){
  
  library(tabulizer)
  
  as.data.frame(
    extract_tables(
      source_pdf,
      pages = 1,
      area = list(c(245, 34, 651, 579)),
      guess = FALSE,
      output = "data.frame")
    )
  
}