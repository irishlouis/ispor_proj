
# create summary data set 
p <- proc.time()
# get summary data for vector magnitude
vector.summary <- data[(epoch_id >= ymd_hms("2016-05-04 18:30:00") & 
                          epoch_id < ymd_hms("2016-05-04 18:55:00")), 
     get.peak.summary(vec.mag, k = 25, freq = 100), 
     .(device_id, epoch_id) ] %>% setkey(device_id, epoch_id)
# get summary data for peak summary
peak.summary <- data[(epoch_id >= ymd_hms("2016-05-04 18:30:00") & 
                        epoch_id < ymd_hms("2016-05-04 18:55:00")), 
     .(avg.vec = mean(vec.mag),
       sd.vec = sd(vec.mag),
       steps = max(steps)), 
     .(device_id, epoch_id) ] %>% setkey(device_id, epoch_id)
(proc.time() - p)[3]

# join summary data
summary <- vector.summary[peak.summary]

# add label for human / dog
summary[,subj_type:=ifelse(model.data2$device_id %in% c("TAS1E31150059"), 
                           "dog", "human"),]
