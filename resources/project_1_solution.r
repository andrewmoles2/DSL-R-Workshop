# to print just run the value or variable
25
(25 * 9/5) + 32

# assign temperature variables
london_temp_c <- 25
new_york_temp_f <- 80

# perform calculations using variables
london_temp_f <- round(
  (london_temp_c * 9/5) + 32
  , 0)

new_york_temp_c <- round(
  (new_york_temp_f - 32) * 5/9
  , 0)

# make text outputs
london_temp_txt <- paste0("The temperature in London is ", 
                          london_temp_c, "°C, which is ", 
                          london_temp_f, "°F")

new_york_txt <- paste0("The temperature in New York is ", 
                       new_york_temp_f, "°F, which is ", 
                       new_york_temp_c, "°C")

# print result
london_temp_txt
new_york_txt