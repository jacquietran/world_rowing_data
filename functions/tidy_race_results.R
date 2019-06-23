# Merge race and splits data and complete final tidying
tidy_race_results <- function(race_data, splits_data){
  
  # Merge race and split data
  tidy_data_merged <- left_join(
    race_data, splits_data)
  
  # Complete final tidy up
  tidy_data_merged <- tidy_data_merged %>%
    mutate(
      seat = as.character(seat),
      distance = case_when(
        distance == "500m" ~ as.numeric(as.character("500")),
        distance == "1000m" ~ as.numeric(as.character("1000")),
        distance == "1500m" ~ as.numeric(as.character("1500")),
        TRUE               ~ as.numeric(as.character("2000"))),
      split_rank = as.numeric(as.character(split_rank))
    )
  
  return(tidy_data_merged)
  
}