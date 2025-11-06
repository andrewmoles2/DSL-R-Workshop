# make vectors using c() 
temps <- c(20.8, 19.6, 18.7, 17.8, 17.7, 19.1, 21.4, 22.8, 24.1, 26.5, 27.8, 
           29.4, 30.7, 31.8, 32.4, 32.0, 31.8, 31.5, 31.2, 29.9, 28.3, 27.1, 26.2)
dates <- c("30/06/2025 01:00:00", "30/06/2025 02:00:00", "30/06/2025 03:00:00", 
           "30/06/2025 04:00:00", "30/06/2025 05:00:00", "30/06/2025 06:00:00",
           "30/06/2025 07:00:00", "30/06/2025 08:00:00", "30/06/2025 09:00:00",
           "30/06/2025 10:00:00", "30/06/2025 11:00:00", "30/06/2025 12:00:00",
           "30/06/2025 13:00:00", "30/06/2025 14:00:00", "30/06/2025 15:00:00",
           "30/06/2025 16:00:00", "30/06/2025 17:00:00", "30/06/2025 18:00:00",
           "30/06/2025 19:00:00", "30/06/2025 20:00:00", "30/06/2025 21:00:00",
           "30/06/2025 22:00:00", "30/06/2025 23:00:00")

# index first element
dmy <- dates[1]
# Substring based on position 
dmy <- substr(dmy, 1, 10)
# regex version (regex code means a space followed by any characters, repeated any number of times)
#sub(" .*", "", dates[1])
# use vectorisation to get F for each temperature value
temps_f <- (temps * 9/5) + 32

# calculate the min, max, and average
low <- min(temps)
high <- max(temps)
avg_daily <- round(mean(temps), 2)

low_f <- min(temps_f)
high_f <- max(temps_f)
avg_daily_f <- round(mean(temps_f), 2)

# make text output
paste0("Temperature on: ", dmy)
paste0("Low: ", low, "°C (",low_f, "°F) | High: ", high, "°C (",high_f, "°F)")
paste0("Daily average: ", avg_daily, "°C (", avg_daily_f, "°F)")
