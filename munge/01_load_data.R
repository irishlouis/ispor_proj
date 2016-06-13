# get csv files from /data
csv.files <- paste0("data/", list.files("data"))

# get the summary files
epoch <- fread(csv.files[str_detect(csv.files, "summary")], header = TRUE, stringsAsFactors = FALSE)
epoch <- epoch[,':='(
  timestamp = ymd_hms(timestamp))][,
                                   .(timestamp, serialnumber, steps),][,
                                                                       steps :=bin_steps(steps),]
setkey(epoch, serialnumber, timestamp)

# empty list to hold raw data
data <- list()
# allow for milliseconds
options(digits.secs=3)

for (i in csv.files[str_detect(csv.files, "RAW.csv")]){
  dt <- fread(i, header = T, stringsAsFactors = F)
  
  device_id <- strsplit(strsplit(i, " ")[[1]][1], "/")[[1]][2]
  dt[,':='(
    device_id = device_id,
    datetime = dmy_hms(Timestamp),
    Timestamp = NULL,
    vec.mag = sqrt(`Accelerometer X`^2 + `Accelerometer Y`^2 + `Accelerometer Z`^2),
    `Accelerometer X` = NULL,
    `Accelerometer Y` = NULL,
    `Accelerometer Z` = NULL
  ),][,':='(
      time_minute = floor_date(datetime, "minute"),
      second = 5 * floor(second(datetime)/5)
      ),][,':='(
        epoch_id = time_minute + seconds(second),
        time_minute = NULL,
        second = NULL
      ),]
  
  data[[which(csv.files[str_detect(csv.files, "RAW.csv")] == i)]] <- dt
}
rm(dt)
# collapse to single file
data <- rbindlist(data)
setkey(data, device_id, epoch_id)

# join epoch steps to raw
data <- data[epoch] 
rm(epoch)

# bin steps
data[,steps := bin_steps(steps),]