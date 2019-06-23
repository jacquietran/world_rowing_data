# Clean up competition dates in wrangled race metadata
# that has had its data classes cleaned
# and has had its competition details cleaned
clean_metadata_comp_dates <- function(cleaner_with_comp_details){
  
  # library(stringr)
  # library(dplyr)
  
  # Tidy up $comp_dates info
  comp_dates_split <- str_split_fixed(
    cleaner_with_comp_details$comp_dates, "\\.", n = 5)
  colnames(comp_dates_split) <- c(
    "comp_start", "dropvar1", "dropvar2", "comp_end", "comp_month")
  comp_dates_split <- data.frame(comp_dates_split)
  comp_dates_split <- comp_dates_split %>%
    select(-starts_with("drop")) %>%
    mutate(
      comp_start = as.numeric(gsub("[^0-9.-]+", "", comp_start)),
      comp_month = gsub('[[:digit:]]+', '', comp_month),
      competition_dates = paste0(
        comp_start, "-", comp_end, " ", comp_month)
    )
  
  # Merge tidied competition dates back into metadata
  cleaned_metadata <- cleaner_with_comp_details %>%
    mutate(
      competition_dates = comp_dates_split$competition_dates) %>%
    select(year, competition, locality, country, competition_dates, event_num,
           boat_class_name, boat_class_short, race_date, race_type_short,
           race_num, -comp_dates)
  
  return(cleaned_metadata)
  
}