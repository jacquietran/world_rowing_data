# Function for checking the cumulative sum of
# top 3 rows in cleaned and populated race results
check_row_sum <- function(row_check_data){
  
  row_check_data <- row_check_data %>%
    filter(row_counter == "row3") %>%
    select(cumulative)
  
  row_check_data <- as.vector(row_check_data)
  
  return(ifelse(row_check_data == 3, TRUE, FALSE))
  
}