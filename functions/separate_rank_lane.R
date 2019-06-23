# Separate Rank.Lane variable into two separate columns
# Evaluates if check_rank_lane(x) == FALSe
separate_rank_lane <- function(race_results){
  
  # library(dplyr)
  # library(stringr)
  
  if (check_rank_lane(race_results) == TRUE){
    
    return(race_results)
  
    } else {
    
      race_results <- race_results %>%
        mutate(
          detect_type = str_detect(Rank.Lane, "[0-9] [0-9]"),
          Name = case_when(
            Rank.Lane == "Progression System:" ~ "delete_row",
            Rank.Lane == "Legend:"             ~ "delete_row",
            TRUE                               ~ Name),
          Rank.Lane = case_when(
            detect_type == TRUE ~ Rank.Lane,
            TRUE                ~ NA_character_)) %>%
        separate(Rank.Lane, c("Rank", "Lane"), sep = " ") %>%
        select(-detect_type, -X.2)
      
      return(race_results)
      
    }
}

