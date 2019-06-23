# A wrapper function that:
# 1) Extracts metadata and race results from PDF
# 2) Tidies metadata
# 3) Tidies race results
# 4) Merges tidied metadata and race results into one dataframe

get_race_results_1x <- function(source_pdf){
  
  # Extract metadata about the race
  race_metadata <- extract_race_metadata(source_pdf)
  
  # Wrangle metadata
  columnised_metadata <- wrangle_to_column(race_metadata)
  labelled_metadata <- label_race_metadata(columnised_metadata)
  
  # Clean metadata
  cleaner_metadata <- clean_metadata_data_types(labelled_metadata)
  cleaner_with_comp_details <- clean_metadata_comp_details(cleaner_metadata)
  tidy_metadata <- clean_metadata_comp_dates(cleaner_with_comp_details)
  
  # Extract race times and ranks data
  race_results <- extract_race_results(source_pdf)
  
  # Clean race results to populate to a rectangular data set
  cleaned_race_results <- populate_race_results(race_results)
  
  # Wrangle cleaned race results
  wrangled_race_results <- wrangle_race_results(cleaned_race_results)
  
  # Subset to race times and ranks
  tidy_data_race_merged <- subset_to_race(wrangled_race_results)
  
  # Subset to split times and ranks
  tidy_data_splits_merged <- subset_to_splits(wrangled_race_results)
  
  # Merge race and split times and ranks
  tidy_race_results <- tidy_race_results(
    tidy_data_race_merged, tidy_data_splits_merged)
  
  # Merge metadata race results to create final tidy data set
  tidy_data_final <- merge_race_results_metadata(
    tidy_metadata, tidy_race_results)
  
  return(tidy_data_final)
  
}