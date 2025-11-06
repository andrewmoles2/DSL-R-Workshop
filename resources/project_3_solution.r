# making vectors using c()
temps <- c(16.5, 15.5, 14.3, 13.7, 12.4, 12, 12.6, 14.1, 16, 
           18.2, 19.7, 21.1, 21.8, 22.6, 23.4, 24.3, 23.3, 
           23.6, 23.1, 23.4, 23.4, 21.6, 20.7, 19.5)
dates <- c("03/07/2025 00:00:00", "03/07/2025 01:00:00", 
           "03/07/2025 02:00:00", "03/07/2025 03:00:00",
           "03/07/2025 04:00:00", "03/07/2025 05:00:00", 
           "03/07/2025 06:00:00", "03/07/2025 07:00:00", 
           "03/07/2025 08:00:00", "03/07/2025 09:00:00", 
           "03/07/2025 10:00:00", "03/07/2025 11:00:00", 
           "03/07/2025 12:00:00", "03/07/2025 13:00:00", 
           "03/07/2025 14:00:00", "03/07/2025 15:00:00", 
           "03/07/2025 16:00:00", "03/07/2025 17:00:00", 
           "03/07/2025 18:00:00", "03/07/2025 19:00:00", 
           "03/07/2025 20:00:00", "03/07/2025 21:00:00",
           "03/07/2025 22:00:00", "03/07/2025 23:00:00")

# Substring using position. Again, other methods can be used.
dmy <- substr(dates[1], 1, 10)
hour <- substr(dates, 12, 13)

# get F values for temp
temps_f <- (temps * 9/5) + 32

# make message for just one hour
paste0("Temperature at ", hour[1], ": ",  temps[1], "°C (", temps_f[1], "°F)")

# classic print-paste method
print(paste0("Hourly temperatures on: ", dmy))
for (i in 1:length(temps)) {
  print(
    paste0("Temperature at ", hour[i], ": ",  temps[i], "°C (", temps_f[i], "°F)")
  )
}

# using cat instead of print-paste (personal fav)
for (i in 1:length(temps)) {
  cat("Temperature at ", hour[i], ": ",  temps[i], "°C (", temps_f[i], "°F)\n",
      sep = "")
}

# the same but using the seq_along method (recommended for reliability when looping as detailed in this chapter - https://r4ds.had.co.nz/iteration.html#for-loops)
cat("Hourly temperatures on: ", dmy, sep = "")
for (i in seq_along(temps)) {
    cat("Temperature at ", hour[i], ": ",  temps[i], "°C (", temps_f[i], "°F)\n",
      sep = "")
}

# naming the temperature variable with the hours
names(temps) <- hour
temps
# boolean indexing values greater than 20
temps[temps > 20]
