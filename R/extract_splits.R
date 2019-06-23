# Extract and clean split times data from PDFs

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)
library(stringr)
library(tidyr)

# Call functions from source ---------------------------------------------------

R.utils::sourceDirectory(here("functions"))

# Extract tables from PDF ------------------------------------------------------

a_final <- here("pdfs/20180914_2018_Worlds_LM1x_Final_A_Splits.pdf")
b_final <- here("pdfs/20180914_2018_Worlds_LM1x_Final_B_Splits.pdf")
c_final <- here("pdfs/20180914_2018_Worlds_LM1x_Final_C_Splits.pdf")
d_final <- here("pdfs/20180914_2018_Worlds_LM1x_Final_D_Splits.pdf")

tidy_a_final <- get_race_results_1x(a_final)
tidy_b_final <- get_race_results_1x(b_final)
tidy_c_final <- get_race_results_1x(c_final)
tidy_d_final <- get_race_results_1x(d_final)