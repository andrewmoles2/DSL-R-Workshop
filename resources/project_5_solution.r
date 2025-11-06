# like 4 you can use different approaches. I have not covered base R as aggregation in base R is not as easy as tidyverse or data.table
# dplyr ----
library(readr)
library(dplyr)
# load data
olympics <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-08-06/olympics.csv')
# some set up with filters and palettes
team_filter <- "Great Britain"
medal_palette <- c("#D6AF36", "#A7A7AD", "#A77044", "#333333")
selected_events <- c("Athletics Men's 800 metres", 
                     "Athletics Women's 800 metres", 
                     "Athletics Men's 1,500 metres", 
                     "Athletics Women's 1,500 metres")

# aggregation with filtering and mutation pre-steps in piped chain
relay_sprint_recode <- olympics |>
  filter(team == team_filter) |>
  filter(event %in% selected_events) |>
  mutate(medal = ifelse(is.na(medal), "No medal", medal)) |>
  mutate(medal = factor(medal, 
                        levels = c("Gold", "Silver", 
                                   "Bronze", "No medal"))) |>
  group_by(medal, event) |>
  summarise(n_indiv_medals = n())
relay_sprint_recode

# data.table ----
# https://atrebas.github.io/post/2020-06-17-datatable-introduction/

library(data.table)
olympics_dt <- fread('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-08-06/olympics.csv')

# Using chaining. Can just do this line by line
relay_dt_recode <- olympics_dt[team == team_filter, 
  ][, medal := fifelse(is.na(medal), "No medal", medal)
  ][event %in% selected_events
  ][, medal := factor(medal, levels = c("Gold", "Silver", 
                                      "Bronze", "No medal"))
  ][, .(n_indiv_medals = .N), by = .(medal, event)]

# visual (ggplot) ----
# ggplot is the best and easiest for visuals
# will work with the data.table dataset too. 
library(ggplot2)

ggplot(relay_sprint_recode,
       aes(x = medal, y = n_indiv_medals, fill = medal)) +
  geom_col() +
  facet_wrap(vars(event)) +
  scale_fill_manual("Medal type", values = medal_palette) +
  labs(title = paste0(team_filter, " middle distance (800 & 1500 metres) medals at all Olympics"),
       y = "Total individual medals", x = "") +
  theme_minimal()


