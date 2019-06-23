# Clean up competition details in wrangled race metadata
# that has had its data classes cleaned
clean_metadata_comp_details <- function(cleaner_metadata){
  
  # library(stringr)
  # library(dplyr)
  
  # Split out $comp_details to distinct variables
  comp_details_split <- str_split_fixed(
    cleaner_metadata$comp_details, "\\.", n = 4)
  colnames(comp_details_split) <- c(
    "competition", "locality", "dropvar", "country")
  comp_details_split <- data.frame(comp_details_split)
  comp_details_split <- comp_details_split %>%
    select(-dropvar) %>%
    mutate(
      country = gsub('[[:digit:]]+', '', country))
  
  # Merge split competition details back into metadata
  cleaner_with_comp_details <- cbind(
    cleaner_metadata, comp_details_split)
  cleaner_with_comp_details <- cleaner_with_comp_details %>%
    select(-comp_details)
  
  return(cleaner_with_comp_details)
  
}