# Wrangle race results data that has been cleaned and populated
wrangle_race_results <- function(cleaned_race_results){
  
  # Create an object to identify whether the extracted race data
  # includes 2 rows or 3 rows for the 1st placegetter
  row_check_data <- cleaned_race_results %>%
    select(rank_final) %>%
    mutate(
      cumulative = cumsum(rank_final),
      row_counter = c(
        "row1", "row2", "row3",
        rep(NA, (length(rank_final) - 3)))
    )
  
  # Create an empty row for appending to race results data
  # for 1st placegetters who do not trail at any of the 500-m checkpoints
  # (i.e., row_check_fx() returns FALSE)
  na_row <- data.frame(matrix(ncol = 13, nrow = 1))
  colnames(na_row) <- names(cleaned_race_results)
  na_row <- na_row %>%
    mutate(
      rank_final = 1)
  
  # Conditional rbind: if 1st placegetter has only two rows of data
  # (i.e., did not trail at any of the 500-m checkpoints), then
  # add na_row to the race data being tidied
  cleaned_race_results <- rbind(
    if(check_row_sum(row_check_data) == FALSE) na_row,
    cleaned_race_results)
  wrangled_race_results <- cleaned_race_results %>%
    mutate(
      time_500m = (as.numeric(as.POSIXct(strptime(    # Convert to seconds
        time_500m,format = "%M:%OS"))) - as.numeric(  # with milliseconds
          as.POSIXct(strptime("0", format = "%S")))), # intact!
      time_1000m = (as.numeric(as.POSIXct(strptime(
        time_1000m,format = "%M:%OS"))) - as.numeric(
          as.POSIXct(strptime("0", format = "%S")))),
      time_1500m = (as.numeric(as.POSIXct(strptime(
        time_1500m,format = "%M:%OS"))) - as.numeric(
          as.POSIXct(strptime("0", format = "%S")))),
      time_2000m = (as.numeric(as.POSIXct(strptime(
        time_2000m,format = "%M:%OS"))) - as.numeric(
          as.POSIXct(strptime("0", format = "%S"))))) %>%
    arrange(rank_final, desc(time_1000m))
  
  # Create row-wise meta-data about type of split time
  split_time_type <- c(
    rep(c("cumulative", "split", "gap_to_first"),
        times = sum(!is.na(unique(wrangled_race_results$lane)), na.rm = TRUE)))
  
  # Create row-wise meta-data about type of split rank
  split_rank_type <- c(
    rep(c("race", "split", NA),
        times = sum(!is.na(unique(wrangled_race_results$lane)), na.rm = TRUE)))
  
  # Add row-wise meta-data into tidy data set
  wrangled_race_results <- wrangled_race_results %>%
    mutate(
      split_time_type = split_time_type,
      split_rank_type = split_rank_type) %>%
    select(rank_final, lane, country_code, seat, crew_names, split_time_type,
           split_rank_type, everything()) %>%
    filter(split_rank_type != "gap_to_first")
  
  return(wrangled_race_results)
  
}