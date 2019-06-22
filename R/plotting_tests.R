library(ggplot2)

p <- ggplot(tidy_data_merged,
            aes(x = distance, y = race_rank,
                group = crew_names, colour = crew_names))
p <- p + geom_line(size = 3)
p <- p + scale_y_reverse()

p <- ggplot(tidy_data_merged,
            aes(x = distance, y = race_time,
                group = crew_names, colour = crew_names))
p <- p + geom_line()
p <- p + coord_flip()

p <- ggplot(tidy_data_merged,
            aes(x = distance, y = split_rank,
                group = crew_names, colour = crew_names))
p <- p + geom_line()
p <- p + scale_y_reverse()

p <- ggplot(tidy_data_merged,
            aes(x = crew_names, y = split_time,
                group = crew_names, fill = crew_names))
p <- p + facet_wrap(~distance)
p <- p + geom_bar(stat = "identity")
p <- p + coord_flip()