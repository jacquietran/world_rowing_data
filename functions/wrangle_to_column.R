# Wrangle the extracted race metadata to
# a data frame of one column
wrangle_to_column <- function(race_metadata){
 
  # library(dplyr)
  
  # Convert extracted race metadata to data frame
  wrangled_metadata <- data.frame(race_metadata)
  
  # Wrangle the metadata into one column of values
  column_values <- data.frame(rownames(wrangled_metadata))
  colnames(column_values) <- "column_values"
  
  rownames(wrangled_metadata) <- NULL
  
  wrangled_metadata <- wrangled_metadata %>%
    rename(column_values = race_metadata)
  
  wrangled_metadata <- rbind(wrangled_metadata, column_values)
  
  return(wrangled_metadata)
   
}
