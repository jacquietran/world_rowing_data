# Subset set to running race times and race ranks
# using cleaned and wrangled race results data
subset_to_race <- function(wrangled_race_results){
  
  # Subset and tidy up cumulative race times
  tidy_data_race_times <- wrangled_race_results %>%
    select(rank_final, lane, country_code, seat, crew_names, split_time_type,
           time_500m, time_1000m, time_1500m, time_2000m) %>%
    filter(split_time_type == "cumulative") %>%
    gather(split_time_name, race_time, time_500m:time_2000m) %>%
    separate(split_time_name, c("dropvar", "distance"), sep = "_") %>%
    select(-dropvar, -split_time_type)
  
  # Subset and tidy up race ranks
  tidy_data_race_ranks <- wrangled_race_results %>%
    select(rank_final, lane, country_code, seat, crew_names, split_rank_type,
           rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
    filter(split_rank_type == "race") %>%
    gather(split_rank_name, race_rank, rank_500m:rank_2000m) %>%
    separate(split_rank_name, c("dropvar", "distance"), sep = "_") %>%
    select(-dropvar, -split_rank_type) %>%
    mutate(
      race_rank = case_when(
        distance == "2000m" ~ as.numeric(as.character(rank_final)),
        TRUE                ~ as.numeric(as.character(race_rank))))
  
  # Merge race times and ranks
  tidy_data_race_merged <- left_join(
    tidy_data_race_times, tidy_data_race_ranks)
  
  return(tidy_data_race_merged)
  
}