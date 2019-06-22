# Extract and clean split times data from PDFs

# This script is the start-to-finish process for one PDF
# and will be the basis for creating a function to make this
# process more efficient.

# TODO: Create boat-class-specific functions for extracting data from PDFs?

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)
library(stringr)
library(tidyr)

# Call functions from source ---------------------------------------------------

source(here("functions/extract_race_metadata.R"))
source(here("functions/extract_race_results.R"))
source(here("functions/wrangle_to_column.R"))
source(here("functions/label_race_metadata.R"))
source(here("functions/clean_metadata_data_types.R"))
source(here("functions/clean_metadata_comp_details.R"))
source(here("functions/clean_metadata_comp_dates.R"))
source(here("functions/tidy_race_metadata.R"))

# Extract tables from PDF ------------------------------------------------------

source_pdf <- here("pdfs/20180914_2018_Worlds_LM1x_Final_A_Splits.pdf")

# Interactively locate table areas to extract
# locate_areas(source_pdf, 1)

# Extract metadata about the race
race_metadata <- extract_race_metadata(source_pdf)

# Extract race times and ranks data
race_results <- extract_race_results(source_pdf)

# Tidy the metadata ------------------------------------------------------------

tidy_metadata <- tidy_race_metadata(race_metadata)

# TODO: Continue from here with turning the one-off script into functions
# First tidy-up of the race data -----------------------------------------------

tidy_data <- extracted_race_data

# Rename columns
colnames(tidy_data) <- c(
  "rank_final", "lane", "country_code", "seat", "crew_names", "time_500m",
  "rank_500m", "time_1000m", "rank_1000m", "time_1500m", "rank_1500m",
  "time_2000m", "rank_2000m", "dropvar")

# Remove unneeded column
tidy_data <- tidy_data %>%
  select(-dropvar)

# Replace empty strings with NA
tidy_data[tidy_data == ""] <- NA

# Remove parentheses from rank values
tidy_data <- tidy_data %>%
  mutate(
    rank_500m = gsub("\\D", "", rank_500m),
    rank_1000m = gsub("\\D", "", rank_1000m),
    rank_1500m = gsub("\\D", "", rank_1500m),
    rank_2000m = gsub("\\D", "", rank_2000m))

# Wrangle the data -------------------------------------------------------------

# Create row-wise meta-data about type of split time
split_time_type <- c(
  "cumulative", "split",
  rep(c("cumulative", "split", "gap_to_first"),
      times = sum(!is.na(tidy_data$lane)) - 1))

# Create row-wise meta-data about type of split rank
split_rank_type <- c(
  "race", "split",
  rep(c("race", "split", NA),
      times = sum(!is.na(tidy_data$lane)) - 1))

# Add row-wise meta-data into tidy data set
tidy_data <- tidy_data %>%
  mutate(
    split_time_type = split_time_type,
    split_rank_type = split_rank_type) %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         split_rank_type, everything()) %>%
  filter(split_rank_type != "gap_to_first") %>%
  mutate(
    rank_final = zoo::na.locf(rank_final, na.rm = FALSE),
    lane = zoo::na.locf(lane, na.rm = FALSE),
    country_code = zoo::na.locf(country_code, na.rm = FALSE),
    crew_names = zoo::na.locf(crew_names, na.rm = FALSE),
    time_500m = zoo::na.locf(time_500m, na.rm = FALSE),
    rank_500m = zoo::na.locf(rank_500m, na.rm = FALSE))

# Subset to race times and ranks -----------------------------------------------

# Subset and tidy up cumulative race times
tidy_data_race_times <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         time_500m, time_1000m, time_1500m, time_2000m) %>%
  filter(split_time_type == "cumulative") %>%
  gather(split_time_name, race_time, time_500m:time_2000m) %>%
  separate(split_time_name, c("dropvar", "distance"), sep = "_") %>%
  select(-dropvar, -split_time_type)

# Subset and tidy up race ranks
tidy_data_race_ranks <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_rank_type,
         rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
  filter(split_rank_type == "race") %>%
  gather(split_rank_name, race_rank, rank_500m:rank_2000m) %>%
  separate(split_rank_name, c("dropvar", "distance"), sep = "_") %>%
  select(-dropvar, -split_rank_type) %>%
  mutate(
    race_rank = case_when(
      distance == "2000m" ~ as.numeric(as.character(rank_final)),
      TRUE                ~ as.numeric(as.character(race_rank))))

# Subset to split times and ranks ----------------------------------------------

# Subset and tidy up split times
tidy_data_split_times <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_time_type,
         time_500m, time_1000m, time_1500m, time_2000m) %>%
  filter(split_time_type == "split") %>%
  gather(split_time_name, split_time, time_500m:time_2000m) %>%
  separate(split_time_name, c("dropvar", "distance"), sep = "_") %>%
  select(-dropvar, -split_time_type)

# Subset and tidy up split ranks
tidy_data_split_ranks <- tidy_data %>%
  select(rank_final, lane, country_code, seat, crew_names, split_rank_type,
         rank_500m, rank_1000m, rank_1500m, rank_2000m) %>%
  filter(split_rank_type == "split") %>%
  gather(split_rank_name, split_rank, rank_500m:rank_2000m) %>%
  separate(split_rank_name, c("dropvar", "distance"), sep = "_") %>%
  select(-dropvar, -split_rank_type)

# Merge race and split times and ranks -----------------------------------------

# Merge race times and ranks
tidy_data_race_merged <- left_join(
  tidy_data_race_times, tidy_data_race_ranks)

# Merge split times and ranks
tidy_data_split_merged <- left_join(
  tidy_data_split_times, tidy_data_split_ranks)

# Then, merge race and split data
tidy_data_merged <- left_join(
  tidy_data_race_merged, tidy_data_split_merged)

# Tidy up merged data ----------------------------------------------------------

tidy_data_merged <- tidy_data_merged %>%
  mutate(
    seat = as.character(seat),
    distance = case_when(
      distance == "500m" ~ as.numeric(as.character("500")),
      distance == "1000m" ~ as.numeric(as.character("1000")),
      distance == "1500m" ~ as.numeric(as.character("1500")),
      TRUE               ~ as.numeric(as.character("2000"))),
    race_time = (as.numeric(as.POSIXct(strptime(    # Convert to seconds
      race_time,format = "%M:%OS"))) - as.numeric(  # with milliseconds
        as.POSIXct(strptime("0", format = "%S")))), # intact!
    split_time = (as.numeric(as.POSIXct(strptime(
      split_time,format = "%M:%OS"))) - as.numeric(
        as.POSIXct(strptime("0", format = "%S")))),
    split_rank = as.numeric(as.character(split_rank))
    )

# Merge race results and metadata ----------------------------------------------

# Create duplicates row-wise in metadata to
# match the number of rows in the race results data
metadata_dup <- tidy_metadata[rep(
  seq_len(nrow(tidy_metadata)), each = length(tidy_data_merged)), ]

# Merge race results and metadata
tidy_data_final <- cbind(tidy_metadata, tidy_data_merged)