# Check whether rank and lane are in
# two separate columns or one merged column
check_rank_lane <- function(race_results){
  
  column_one_name <- names(race_results)[1]
  
  return(ifelse(column_one_name == "Rank", TRUE, FALSE))
  
}