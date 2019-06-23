# Label the wrangled race metadata
# and transpose to a one-row data frame
label_race_metadata <- function(wrangled_metadata){
  
  # library(dplyr)
  
  # Label the useful values with variable names
  varnames <- c("event_num", rep(NA, 3), "boat_class_name", "race_date",
                "boat_class_short", "race_type_short", "race_num",
                "comp_details", rep(NA, 5), "comp_dates", rep(NA, 2))
  labelled_metadata <- wrangled_metadata %>%
    mutate(varnames = varnames) %>%
    filter(!is.na(varnames))
  
  # Update varnames object with shorter list of variable names
  varnames <- labelled_metadata$varnames
  labelled_metadata <- labelled_metadata %>%
    select(-varnames)
  
  # Transpose and apply labels as column names
  labelled_metadata <- t(labelled_metadata)
  colnames(labelled_metadata) <- varnames
  rownames(labelled_metadata) <- NULL
  
  labelled_metadata <- data.frame(labelled_metadata)
  
  return(labelled_metadata)
  
}