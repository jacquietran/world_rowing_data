# Populate extracted race results data
# to create a rectangular data set
populate_race_results <- function(race_results){
  
  library(dplyr)
  
  # Rename columns
  colnames(race_results) <- c(
    "rank_final", "lane", "country_code", "seat", "crew_names", "time_500m",
    "rank_500m", "time_1000m", "rank_1000m", "time_1500m", "rank_1500m",
    "time_2000m", "rank_2000m", "dropvar")
  
  # Replace empty strings with NA
  race_results[race_results == ""] <- NA
  
  race_results <- race_results %>%
    select(-dropvar) %>%                        # Remove unneeded column
    mutate(                                     # Remove parentheses from
      rank_500m = gsub("\\D", "", rank_500m),   # rank values
      rank_1000m = gsub("\\D", "", rank_1000m),
      rank_1500m = gsub("\\D", "", rank_1500m),
      rank_2000m = gsub("\\D", "", rank_2000m))
  
  # Fill NAs from preceding value, using na.locf
  race_results <- race_results %>%
    mutate(
      rank_final = zoo::na.locf(rank_final, na.rm = FALSE),
      lane = zoo::na.locf(lane, na.rm = FALSE),
      country_code = zoo::na.locf(country_code, na.rm = FALSE),
      crew_names = zoo::na.locf(crew_names, na.rm = FALSE),
      time_500m = zoo::na.locf(time_500m, na.rm = FALSE),
      rank_500m = zoo::na.locf(rank_500m, na.rm = FALSE))
  
  return(race_results)
  
}