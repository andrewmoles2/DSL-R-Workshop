# There are multiple ways of solving this. 
#I have split the solutions into base R, tidyverse, and data.table

# base R (what I used in the materials to get the outputs) ----
kane <- read.csv("harry_kane_stats.csv")

# using the transform function to perform the calculations
kane <- transform(kane,
    # goals plus assists
    goals_assists = goals + assists,
    # goals minus penalties
    goals_no_pens = goals - pens,
    # xG vs goal diff
    # greater means the player is a better finisher, less means not so good.
    goals_xg_diff = goals - expected_goals
  )

# alt methods (which you'd do for each calculation)
#kane$goals_assists <- kane$goals + kane$assists
#kane['goals_no_pens'] <- kane[, 'goals'] - kane[, 'pens']

# summary (not in materials but might be useful to show)
summary(kane)

# player name
player_name <- "Harry Kane"
# total goals
total_goals <- sum(kane$goals)
# total goals + assists
total_goals_assists <- sum(kane[["goals_assists"]])
# average expected goals
avg_exp_goals <- round(mean(kane$expected_goals, na.rm = TRUE), 1)
# average goals xg diff
avg_goal_xg_diff <- mean(kane$goals_xg_diff, na.rm = TRUE)
# total appearances
apps <- sum(kane$matches_played)
# n seasons (need unique as there are duplicates)
n_seasons <- length(unique(kane$age))

# overall stats
paste0("Player: ", player_name, 
       " | Seasons: ", n_seasons,
       " | Appearances: ", apps)

paste0("Goals: ",total_goals,
       " | Goals and assists: ", total_goals_assists,
       " | Average expected goals: ", avg_exp_goals)

# over 30 goals and assists
selected_cols <- c("season", "age", "squad",
                   "goals", "goals_assists", 
                   "goals_xg_diff", "goals_no_pens")
# classic indexing
kane[kane$goals_assists > 30, selected_cols]
kane[kane['goals_assists'] > 30, selected_cols]

# using subset (similar to filter method in dplyr)
kane_best <- subset(kane,
                    goals_assists > 30,
                    select = selected_cols)
kane_best

# dplyr ----
# load dplyr and readr (can also load tidyverse as it is part of it)
library(dplyr)
library(readr)

kane_tidy <- read_csv("harry_kane_stats.csv")

# use mutate, which is based on base R transform function and works the same. Using pipe which is the tidyverse way. 
# also the base R pipe works also which is |> instead of %>%
kane_tidy <- kane_tidy %>%
  mutate(# goals plus assists
    goals_assists = goals + assists,
    # goals minus penalties
    goals_no_pens = goals - pens,
    # xG vs goal diff
    # greater means the player is a better finisher, less means not so good.
    goals_xg_diff = goals - expected_goals)

# making variables for text output same as base R (or at least really similar)

# selecting and filtering
kane_tidy |>
  select(all_of(selected_cols)) |>
  filter(goals_assists > 30)

# data.table ----
library(data.table)

kane_dt <- fread("harry_kane_stats.csv")

# option of multiple assignments
kane_dt[, `:=` (
  goals_assists = goals + assists,
  goals_no_pens = goals - pens,
  goals_xg_diff = goals - expected_goals
)]

# example of single assignment
#kane_dt[, goals_assists := goals + assists]

total_goals <- sum(kane_dt$goals)
total_goals_assists <- sum(kane_dt[["goals_assists"]])
avg_exp_goals <- round(mean(kane_dt$expected_goals, na.rm = TRUE),1)
avg_goal_xg_diff <- mean(kane_dt$goals_xg_diff, na.rm = TRUE)
apps <- sum(kane_dt$matches_played)
n_seasons <- length(unique(kane_dt$age))
player_name <- "Harry Kane"

# making it fancy using cat (very optional)
cat(
  paste0("Player: ", player_name),
  paste0("Seasons: ",n_seasons),
  paste0("Appearances:",apps),
  paste0("Goals:",total_goals),
  paste0("Goals and assists: ", total_goals_assists),
  paste0("Average expected goals: ", avg_exp_goals),
  sep = "\n"
)

selected_cols <- c("season", "age", "squad",
                   "goals", "goals_assists", 
                   "goals_xg_diff", "goals_no_pens")

# option 1 on selecting columns with a filter
kane_dt_filt <- kane_dt[goals_assists > 30, 
                  .(season, age, squad,
                    goals, goals_assists, 
                    goals_xg_diff, goals_no_pens)]

# option 2 using pre named variable with .. prefix
kane_dt[goals_assists > 30 , ..selected_cols]

kane_dt_filt
