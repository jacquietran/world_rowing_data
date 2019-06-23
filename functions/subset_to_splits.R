# Subset set to split times and race ranks
# using cleaned and wrangled race results data
subset_to_splits <- function(wrangled_race_results){
  
  # Subset and tidy up split times
  tidy_data_split_times <- wrangled_race_results %>%
    select(rank_final, lane, country_code, seat, crew_names, split_time_type,
           time_500m, time_1000m, time_1500m, time_2000m) %>%
    filter(split_time_type == "split") %>%
    gather(split_time_name, split_time, time_500m:time_2000m) %>%
    separate(split_time_name, c("dropvar", "distance"), sep = "_") %>%
    select(-dropvar, -split_time_type)
  
  # Subset and tidy up split ranks
  tidy_data_split_ranks <- wrangled_race_results %>%
    select(rank_final, lane, country_code, seat, crew_names, split_rank_type,
           rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
    filter(split_rank_type == "split") %>%
    gather(split_rank_name, split_rank, rank_500m:rank_2000m) %>%
    separate(split_rank_name, c("dropvar", "distance"), sep = "_") %>%
    select(-dropvar, -split_rank_type)
  
  # Merge split times and ranks
  tidy_data_split_merged <- left_join(
    tidy_data_split_times, tidy_data_split_ranks)
  
  return(tidy_data_split_merged)
  
}