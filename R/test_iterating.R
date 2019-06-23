# Test of iteratively applying
# get_race_results_1x() over a vector of
# file paths that point to race results PDFs

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)
library(stringr)
library(tidyr)
library(purrr)

# Call functions from source ---------------------------------------------------

R.utils::sourceDirectory(here("functions"))

# Create vector of files
pdf_results <- data.frame(file_name = list.files(here("pdfs/race_results")))
pdf_results <- pdf_results %>%
  mutate(
    root_dir_path = here(),
    function_call = paste0(
      root_dir_path, '/pdfs/race_results/', file_name)
  )
pdf_results <- as.vector(pdf_results$function_call)

# Use purrr to iterate over each item in the vector
temp_df <- map_dfr(pdf_results, get_race_results_1x) %>% View()