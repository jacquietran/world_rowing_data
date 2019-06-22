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

# Extract tables from PDF ------------------------------------------------------

source_pdf <- here("pdfs/20180914_2018_Worlds_LM1x_Final_A_Splits.pdf")

# Interactively locate table areas to extract
# locate_areas(source_pdf, 1)

# Extract metadata about the race
extracted_race_metadata <- unlist(extract_tables(
  source_pdf, pages = 1, area = list(c(126, 35, 201, 577)),
  guess = FALSE, output = "data.frame"))

# Extract race times and ranks data
extracted_race_data <- as.data.frame(extract_tables(
  source_pdf, pages = 1, area = list(c(245, 34, 651, 579)),
  guess = FALSE, output = "data.frame"))

# Wrangle the metadata ---------------------------------------------------------

tidy_metadata <- data.frame(extracted_race_metadata)

# Wrangle the metadata into one column of values
column_values <- data.frame(rownames(tidy_metadata))
colnames(column_values) <- "column_values"

rownames(tidy_metadata) <- NULL
tidy_metadata <- tidy_metadata %>%
  rename(column_values = extracted_race_metadata)

tidy_metadata <- rbind(tidy_metadata, column_values)

# Label the useful values with variable names
varnames <- c("event_num", rep(NA, 3), "boat_class_name", "race_date",
              "boat_class_short", "race_type_short", "race_num",
              "comp_details", rep(NA, 5), "comp_dates", rep(NA, 2))
tidy_metadata <- tidy_metadata %>%
  mutate(
    varnames = varnames) %>%
  filter(!is.na(varnames))

varnames <- tidy_metadata$varnames

tidy_metadata <- tidy_metadata %>%
  select(-varnames)

tidy_metadata <- t(tidy_metadata)
colnames(tidy_metadata) <- varnames
rownames(tidy_metadata) <- NULL
tidy_metadata <- data.frame(tidy_metadata)

# Tidy up the metadata ---------------------------------------------------------

tidy_metadata <- tidy_metadata %>%
  mutate(
    event_num = as.numeric(as.character(event_num)),
    year = as.numeric(str_sub(race_date, 8, 11)),
    race_num = as.numeric(gsub("[^0-9.-]+", "", race_num)),
    comp_details = as.character(comp_details),
    comp_dates = as.character(comp_dates)
  )

# Split out $comp_details to distinct variables
comp_details_split <- str_split_fixed(
  tidy_metadata$comp_details, "\\.", n = 4)
colnames(comp_details_split) <- c(
  "competition", "locality", "dropvar", "country")
comp_details_split <- data.frame(comp_details_split)
comp_details_split <- comp_details_split %>%
  select(-dropvar) %>%
  mutate(
    country = gsub('[[:digit:]]+', '', country))

# Merge split competition details back into metadata
tidy_metadata <- cbind(tidy_metadata, comp_details_split)
tidy_metadata <- tidy_metadata %>%
  select(-comp_details)

# Tidy up $comp_dates info
comp_dates_split <- str_split_fixed(
  tidy_metadata$comp_dates, "\\.", n = 5)
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
tidy_metadata <- tidy_metadata %>%
  mutate(
    competition_dates = comp_dates_split$competition_dates) %>%
  select(year, competition, locality, country, competition_dates, event_num,
         boat_class_name, boat_class_short, race_date, race_type_short,
         race_num, -comp_dates)

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