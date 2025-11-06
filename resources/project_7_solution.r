# tidyverse approach ----
library(tidyverse)

imdb <- read_csv("resources/imdb.csv")
rotten <- read_csv("resources/rotten_tom_ratings.csv")

# remove the duplicated entries
rotten <- rotten |>
  filter(!duplicated(release_date))

# inner join by title
movies_all <- imdb |>
  inner_join(rotten, by = join_by(title))

# fixing and unifying scores
movies_all <- movies_all |>
  mutate(
    rotten_tom_critic = as.integer(sub("%", "", critic_score)),
    rotten_tom_audience = as.integer(sub("%", "", audience_score)),
    imd = avg_vote * 10
  )

# calculating means across rows (dplyr approach uses rowwise function, see documentation for more info!)
movies_all <- movies_all |>
  rowwise() |>
  mutate(
    avg_ratings = mean(
      c_across(rotten_tom_audience:imd)
    ))

# transforming the data to a longer format (tidyverse call this pivoting)
movies_all_long <- movies_all |>
  select(title, year, rotten_tom_critic:avg_ratings) |>
  pivot_longer(cols = rotten_tom_critic:imd,
               names_to = "rating_type",
               values_to = "ratings")

#---------------------------------------------------------#

# data table approach ----
library(data.table)

imdb_dt <- fread("solutions_R/imdb.csv")
rotten_dt <- fread("solutions_R/rotten_tom_ratings.csv")

# remove duplicates
rotten_dt <- rotten_dt[!duplicated(release_date),]

# inner join (see https://r-datatable.com/articles/datatable-joins.html#inner-join)
movies_all_dt <- imdb_dt[rotten_dt, on = c("title"), nomatch = NULL]

# fix values
movies_all_dt[, ":=" (
  rotten_tom_critic = as.numeric(sub("%", "", critic_score)),
  rotten_tom_audience = as.numeric(sub("%", "", audience_score)),
  imd = avg_vote * 10
)]

# rowwise (using rowMeans function (which is a base R function))
movies_all_dt[, avg_ratings := rowMeans(.SD),
              .SDcols = c("rotten_tom_critic",
                          "rotten_tom_audience",
                          "imd")]
# melt to transform longer
movies_all_long_dt <- melt(
  # select cols
  movies_all_dt[, .(title, year, rotten_tom_critic, 
                    rotten_tom_audience, imd, avg_ratings)],
  # variables to keep and not transform
  id.vars = c("title", "year", "avg_ratings"),
  # variables to transform
  measure.vars = c("rotten_tom_critic", "rotten_tom_audience", "imd"),
  # what to name new variables
  variable.name = "rating_type",
  value.name = "rating"
)

#---------------------------------------------------------#

# base R approach ----
# can do all apart from pivot/melting (it can but it is just easier to use data.table or tidyverse)
imdb_base <- read.csv("solutions_R/imdb.csv")
rotten_base <- read.csv("solutions_R/rotten_tom_ratings.csv")

# subset which is similar to filter in tidyverse
rotten_base <- subset(rotten_base, !duplicated(release_date))
# alt version which is more like data.table
rotten_base[!duplicated(rotten_base$release_date),]

# join using base::merge()
movies_all_base <- merge(imdb_base,
      rotten_base,
      by = "title",
      all = FALSE)

# fix scores (using transform which is similar to mutate function)
movies_all_base <- movies_all_base |>
  transform(
    rotten_tom_critic = as.integer(sub("%", "", critic_score)),
    rotten_tom_audience = as.integer(sub("%", "", audience_score)),
    imd = avg_vote * 10
  )
# alternative method is to assign new column one by one using the dollar sign. Example below for just one. 
movies_all_base$imd <- movies_all_base$avg_vote * 10

# calculate row average
movies_all_base$avg_ratings <- rowMeans(
  movies_all_base[, c("rotten_tom_critic",
                 "rotten_tom_audience",
                 "imd")],
  na.rm = TRUE
)

# transform/melt/pivot using data.table or tidyverse

#---------------------------------------------------------#

# plotting (just ggplot2 as that is the easiest and best) ----

# make vector of films to filter by
top_movies <- c(
  "The Shawshank Redemption",
  "The Godfather",
  "The Dark Knight",
  "The Lord of the Rings: The Return of the King",
  "Schindler's List",
  "The Lord of the Rings: The Fellowship of the Ring",
  "Pulp Fiction",
  "The Good, the Bad and the Ugly",
  "Forrest Gump",
  "The Lord of the Rings: The Two Towers"
)

# filter data to just include selected films
plot_data <- movies_all_long |>
  filter(title %in% top_movies) |> 
  mutate(title = factor(title, levels = top_movies))

# plot set up
average <- round(mean(plot_data$avg_ratings))

pal <- c("#F5C518", "#068098", "#961E06")

# making the visual with ggplot2
plot_data |>
  ggplot(aes(x = title, y = ratings, group = rating_type, colour = rating_type)) +
  geom_hline(yintercept = average,
             linetype = 3) +
  geom_line(linewidth = 2) +
  annotate(geom = "text", x = 8, y = average - 0.75,
           label = "Average rating",
           size = 3) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  scale_y_continuous(limits = c(70, 100), breaks = seq(70, 100, 5)) +
  scale_colour_manual(values = pal) +
  labs(title = "Difference in ratings from IMDB and Rotten Tomatoes\nfor top rated films",
       x = "", y = "",
       colour = "Audience ratings") +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title.position = "plot")


