#!/bin/bash

today=$(date +%Y%m%d)
weather_report="raw_data_$today"
city="Casablanca"
curl wttr.in/$city --output $weather_report

# 3.1.1. Extract the current temperature, and store it in a shell variable called `obs_tmp`
grep °C $weather_report | sed -E 's/\x1B\[[0-9;]*[a-zA-Z]//g' > temperatures.txt
obs_tmp=$(head -1 temperatures.txt | 
          grep -oE '[0-9]+ °C')
echo "Observed temperature = $obs_tmp"

# 3.1.2. Extract tomorrow's temperature forecast for noon, and store it in a shell variable called `fc_tmp`
fc_temp=$(head -3 temperatures.txt | tail -1 | 
          grep -oP '\+?\d+(\(\d+\))? °C' |
          head -2 | tail -1)
echo "Tomorrow's temperature at noon = $fc_temp"

# 3.2. Store the current hour, day, month, and year in corresponding shell variables
TZ='Morocco/Casablanca'
hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d) 
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

# 3.3. Merge the fields into a tab-delimited record, corresponding to a single row in Table 1
record=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_temp")
echo $record >> rx_poc.log
