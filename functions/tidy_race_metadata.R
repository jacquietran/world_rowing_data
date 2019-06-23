# A wrapper function to tidy race metadata in one step,
# combining wrangling and cleaning custom functions
tidy_race_metadata <- function(race_metadata){
  
  # Wrangle
  columnised_metadata <- wrangle_to_column(
    race_metadata)
  labelled_metadata <- label_race_metadata(
    columnised_metadata)
  
  # Clean
  cleaner_metadata <- clean_metadata_data_types(
    labelled_metadata)
  cleaner_with_comp_details <- clean_metadata_comp_details(
    cleaner_metadata)
  cleaned_with_comp_dates <- clean_metadata_comp_dates(
    cleaner_with_comp_details
  )
    
  return(cleaned_with_comp_dates)
  
}