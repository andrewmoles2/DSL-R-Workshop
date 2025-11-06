# this code will generate exactly what is seen in the materials due to the seed, which you can change to show how that works. 

seed <- 4321
set.seed(seed)

colour_palette <- c(
  '#ffc09f','#ffd799','#ffee93','#fef2ad',
  '#fcf5c7','#cee2d0','#a0ced9','#a7e3c8',
  '#adf7b6','#264653','#287271','#2a9d8f',
  '#e9c46a','#f4a261','#e76f51','#e97c61'
)

# sampling without replacement (what happens when we change the size or add replace = TRUE)
# can add replace = TRUE, then re-run the code several times to show when it picks the same colour twice (or more)
col_pal <- sample(colour_palette, size = 4)

# make seq with set length
x <- seq(from = 0,
         to = 100,
         length.out = 30)
# make factor based on number of colours picked
group_var <- factor(1:length(col_pal))

# df based on all combos of vectors
plot_data <- expand.grid(
  x = x,
  group_var = group_var
)
# add random normal distribution
plot_data$y <- rnorm(nrow(plot_data),
                     mean = mean(plot_data$x), 
                     sd = sd(plot_data$x))

library(ggplot2)
library(ggstream)

ggplot(plot_data,
       aes(x, y, fill = group_var, colour = group_var)) +
  geom_stream(
    # can adjust this to mirror or ridge to see what happens
    type = "proportional"
  ) +
  scale_fill_manual(values = col_pal) +
  scale_colour_manual(values = col_pal) +
  guides(colour = "none", fill = "none") +
  theme_void()

