# Merge race results and race metadata
merge_race_results_metadata <- function(tidy_metadata, tidy_race_results){
  
  # Create duplicates row-wise in metadata to
  # match the number of rows in the race results data
  metadata_dup <- tidy_metadata[rep(
    seq_len(nrow(tidy_metadata)), each = length(tidy_race_results)), ]
  
  # Merge race results and metadata
  tidy_data_final <- cbind(tidy_metadata, tidy_race_results)
  
  return(tidy_data_final)
  
}