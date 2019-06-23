# Extract and clean split times data from PDFs

# Load libraries ---------------------------------------------------------------

library(here)
library(tabulizer)
library(dplyr)
library(stringr)
library(zoo)
library(tidyr)

# Call functions from source ---------------------------------------------------

R.utils::sourceDirectory(here("functions"))

# Extract tables from PDF ------------------------------------------------------

a_final <- here("pdfs/race_results/20180914_2018_Worlds_LM1x_Final_A_Results.pdf")
b_final <- here("pdfs/race_results/20180914_2018_Worlds_LM1x_Final_B_Results.pdf")
c_final <- here("pdfs/race_results/20180914_2018_Worlds_LM1x_Final_C_Results.pdf")
d_final <- here("pdfs/race_results/20180914_2018_Worlds_LM1x_Final_D_Results.pdf")

lw1x_a_final <- here("pdfs/race_results/20180914_2018_Worlds_LW1x_Final_A_Results.pdf")
lw1x_b_final <- here("pdfs/race_results/20180914_2018_Worlds_LW1x_Final_B_Results.pdf")
lw1x_c_final <- here("pdfs/race_results/20180914_2018_Worlds_LW1x_Final_C_Results.pdf")
lw1x_d_final <- here("pdfs/race_results/20180914_2018_Worlds_LW1x_Final_D_Results.pdf")

tidy_a_final <- get_race_results_1x(a_final)
tidy_b_final <- get_race_results_1x(b_final)
tidy_c_final <- get_race_results_1x(c_final)
tidy_d_final <- get_race_results_1x(d_final)

tidy_lw1x_a_final <- get_race_results_1x(lw1x_a_final)
tidy_lw1x_b_final <- get_race_results_1x(lw1x_b_final)
tidy_lw1x_c_final <- get_race_results_1x(lw1x_c_final)
tidy_lw1x_d_final <- get_race_results_1x(lw1x_d_final)

# Adapting functions for use with semi-finals data -----------------------------

semifinal_ab1 <- here("pdfs/race_results/20180913_2018_Worlds_LM1x_Semifinal_AB1_Results.pdf")
semifinal_ab2 <- here("pdfs/race_results/20180913_2018_Worlds_LM1x_Semifinal_AB2_Results.pdf")

race_results <- extract_race_results(semifinal_ab2)