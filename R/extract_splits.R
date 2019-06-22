# Extract and clean split times data from PDFs

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)

# Extract tables from PDF ------------------------------------------------------

source_pdf <- here("pdfs/20180914_2018_Worlds_LM1x_Final_A_Splits.pdf")

# Interactively locate table areas to extract
# locate_areas(source_pdf, 1)

extracted_data <- as.data.frame(extract_tables(
  source_pdf, pages = 1, area = list(c(248, 38, 522, 577)),
  guess = FALSE, output = "data.frame"))

# Tidy the data ----------------------------------------------------------------

tidy_data <- extracted_data

# Rename columns
colnames(tidy_data) <- c(
  "rank_final", "lane", "country_code", "seat", "crew_names",
  "split_time_500m", "split_rank_500m", "split_time_1000m", "split_rank_1000m",
  "split_time_1500m", "split_rank_1500m", "split_time_2000m",
  "split_rank_2000m", "dropvar")

# Remove unneeded column
tidy_data <- tidy_data %>%
  select(-dropvar)

# Add row-wise meta-data about type of split time info
split_time_type <- c(
  "cumulative", "500 m split",
  rep(c("cumulative", "500 m split", "gap to 1st"),
      times = sum(!is.na(tidy_data$lane)) - 1)
)

# Add row-wise meta-data about type of split rank info
split_rank_type <- c(
  "rank in race", "rank for 500 m split",
  rep(c("rank in race", "rank for 500 m split", NA),
      times = sum(!is.na(tidy_data$lane)) - 1)
)

tidy_data <- tidy_data %>%
  mutate(
    split_time_type = split_time_type,
    split_rank_type = split_rank_type) %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         split_rank_type, everything())

# TODO: Create boat-class-specific functions for extracting data from PDFs?