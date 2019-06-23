# World Rowing race results

Liberating race data from PDFs supplied by World Rowing.

## Objectives

1. Create functions to efficiently extract data tables from the PDFs supplied by World Rowing and tidy the extracted data.
2. Create a data package to store race data from World Rowing & Olympic rowing regattas in a rectangular and tidy format.

## Constraints

To begin with, I am focusing on the following competitions:

- Olympic Games
- World Rowing Championships
- World Rowing Cups I, II, III

In time, this work could extend to other competitions.

World Rowing provides a range of PDFs related to any particular regatta. I am interested in performance-related data, so will focus on extracting and tidying data as it relates to:

- **Race results**: These PDFs include cumulative race times, running race rank, split times, and split ranks in 500-m increments.
- **Sensor data**: World Rowing calls this 'GPS data'. These PDFs include velocity (m / s) and stroke rate (strokes / min) measures in 50-m increments.

## Development roadmap as a listicle

### Race results

[x] Write one-off script that performs end-to-end processes for extracting data from race results PDF for 1 race. I chose: 2018 World Championships LM1x A Final.
[x] Convert one-off code chunks into functions, with the end-result being a wrapper function, `get_race_results_1x` that performs the end-to-end process of data extraction to tidying.
[x] Check that the wrapper function `get_race_results_1x` works on other race results PDFs of a similar structure. Confirmed to work with all race results PDFs from the 2018 World Championships LM1x Finals races.

### Sensor data

[] Write one-off script that performs end-to-end processes for extracting data from sensor data PDF for 1 race.