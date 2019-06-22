# Clean up data types in wrangled race metadata
clean_metadata_data_types <- function(wrangled_metadata){
  
  library(dplyr)
  library(stringr)
  
  cleaner_metadata <- wrangled_metadata %>%
    mutate(
      event_num = as.numeric(as.character(event_num)),
      year = as.numeric(str_sub(race_date, 8, 11)),
      race_num = as.numeric(gsub("[^0-9.-]+", "", race_num)),
      comp_details = as.character(comp_details),
      comp_dates = as.character(comp_dates)
    )
  
  return(cleaner_metadata)
}