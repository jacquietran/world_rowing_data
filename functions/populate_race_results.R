# Populate extracted race results data
# to create a rectangular data set
populate_race_results <- function(race_results){
  
  # library(dplyr)
  # library(tidyr)
  # library(zoo)
  
  # Use custom function separate_rank_lane()
  # to check if 'Rank.Lane' exists, and if so,
  # separate data into two separate columns.
  # If not, race_results is returned with no changes.
  race_results <- separate_rank_lane(race_results)
  
  # Remove rows with progression and legend descriptions
  race_results <- race_results %>%
    filter(!Rank %in% c("Progression System:", "Legend:")) %>%
    filter(Name != "delete_row")
  
  # Rename columns
  colnames(race_results) <- c(
    "rank_final", "lane", "country_code", "seat", "crew_names", "time_500m",
    "rank_500m", "time_1000m", "rank_1000m", "time_1500m", "rank_1500m",
    "time_2000m", "rank_2000m", "progression_code")
  
  # Replace empty strings with NA
  race_results[race_results == ""] <- NA
  
  race_results <- race_results %>%
    mutate(                                     # Remove parentheses from
      rank_500m = gsub("\\D", "", rank_500m),   # rank values
      rank_1000m = gsub("\\D", "", rank_1000m),
      rank_1500m = gsub("\\D", "", rank_1500m),
      rank_2000m = gsub("\\D", "", rank_2000m),
      progression_code = gsub(                  # Remove total rank values
        "\\([0-9]\\)", NA, progression_code))   # from $progression_code
  
  # Fill NAs from preceding value, using na.locf
  race_results <- race_results %>%
    mutate(
      rank_final = na.locf(rank_final, na.rm = FALSE),
      lane = na.locf(lane, na.rm = FALSE),
      country_code = na.locf(country_code, na.rm = FALSE),
      crew_names = na.locf(crew_names, na.rm = FALSE),
      time_500m = na.locf(time_500m, na.rm = FALSE),
      rank_500m = na.locf(rank_500m, na.rm = FALSE),
      progression_code = na.locf(progression_code, na.rm = FALSE))
  
  return(race_results)
  
}