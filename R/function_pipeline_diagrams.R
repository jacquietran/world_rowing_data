# Diagrams of function pipelines

# Load libraries ---------------------------------------------------------------

library(DiagrammeR)

# Function pipeline: Race results ----------------------------------------------

grViz("digraph {

graph [layout = dot, rankdir = TB]

# define the global styles of the nodes. We can override these in box if we wish
node [shape = rectangle, style = filled, fillcolor = Linen]

# extract from pdf
extract_race_metadata [label = 'extract_race_metadata()',
                       fillcolor = Orange]

extract_race_results [label = 'extract_race_results()',
                      fillcolor = Orange]

# tidy metadata
wrangle_to_column [label = 'wrangle_to_column()',
                   fillcolor = OrangeRed]
label_race_metadata [label = 'label_race_metadata()',
                     fillcolor = OrangeRed]
clean_metadata_data_types [label = 'clean_metadata_data_types()',
                           fillcolor = OrangeRed]
clean_metadata_comp_details [label = 'clean_metadata_comp_details()',
                             fillcolor = OrangeRed]
clean_metadata_comp_dates [label = 'clean_metadata_comp_dates()',
                           fillcolor = OrangeRed]
clean_metadata_comp_dates [label = 'clean_metadata_comp_dates()',
                           fillcolor = OrangeRed]
                           
# tidy race results
populate_race_results [label = 'populate_race_results()',
                       fillcolor = OrangeRed]
wrangle_race_results [label = 'wrangle_race_results()',
                      fillcolor = OrangeRed]
subset_to_race [label = 'subset_to_race()',
                fillcolor = LightSeaGreen]
subset_to_splits [label = 'subset_to_splits()',
                  fillcolor = LightSeaGreen]
tidy_race_results [label = 'tidy_race_results()',
                  fillcolor = LightSeaGreen]

# merge tidied metadata and race results
merge_race_results_metadata [label = 'merge_race_results_metadata()',
                             fillcolor = LimeGreen]

# edge definitions with the node IDs
extract_race_metadata -> wrangle_to_column -> label_race_metadata -> clean_metadata_data_types -> clean_metadata_comp_details -> clean_metadata_comp_dates -> merge_race_results_metadata
extract_race_results -> populate_race_results -> wrangle_race_results -> {subset_to_race subset_to_splits} -> tidy_race_results -> merge_race_results_metadata

                                  }")