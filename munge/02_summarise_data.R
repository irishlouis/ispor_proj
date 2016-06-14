
# summarise maries evalusation data
train.summary <- summarise.data(data = train.data[device_id != "TAS1E31150005"], 
                                human.devices = c("TAS1E31150003", "TAS1E31150028"))
## filter to walk period
train.summary <- train.summary[epoch_id >= ymd_hms("2016-05-04 18:30:00") & 
                                  epoch_id < ymd_hms("2016-05-04 18:55:00")]
cache("train.summary")






# summarise maries evalusation data
eval2.summary <- summarise.data(data = eval2.data, human.devices = "TAS1E31150005")
## filter to walk period
eval2.summary <- eval2.summary[epoch_id > ymd_hms("20160614 064500") & 
                                 epoch_id < ymd_hms("20160614 070030")]
cache("eval2.summary")
