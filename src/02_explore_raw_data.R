# plot raw data for single epoch
p1 <- data[datetime >= ymd_hms("2016-06-14 06:00:00") & datetime <= ymd_hms("2016-06-14 07:00:00")] %>%
  ggplot(aes(datetime, vec.mag, group = device_id)) + 
  geom_line(aes(col = as.factor(steps))) +
  facet_wrap(~device_id, ncol = 1) + 
  labs(title = "Example of raw data for a single 5 second epoch starting at 2016-05-04 18:45:00",
       subtitle = "The lines are coloured by the number of steps identified by the Actilife software in the epoch.",
       caption = "NOTE: devices times are not 100% synchronous +/- 1s",
       y = "Accel Vector Magnitude (m/s)",
       x = "Time (s)") + 
  theme_bw() +
  scale_colour_discrete(name = "Steps in epoch") + 
  theme(legend.position = "bottom",
        legend.key = element_rect(colour = "white"),
        panel.grid.minor = element_blank())
p1
pdf("graphs/sampleRawPattern1.pdf",compress = FALSE )
p1
dev.off()


# plot raw data for single epoch
p2 <- data[datetime >= ymd_hms("2016-05-04 18:33:30") & datetime < ymd_hms("2016-05-04 18:33:35")& device_id != "TAS1E31150005"] %>%
  ggplot(aes(datetime, vec.mag, group = device_id)) + 
  geom_line(aes(col = as.factor(steps))) +
  facet_wrap(~device_id, ncol = 1) + 
  labs(title = "Example of raw data for a single 5 second epoch starting at 2016-05-04 18:33:30",
       subtitle = "In this plot the algorithm found an equal number of steps for each device.
       However it is apparent that there are significant differences in the raw data profiles.",
       caption = "NOTE: devices times are not 100% synchronous +/- 1s",
       y = "Accel Vector Magnitude (m/s)",
       x = "Time (s)") + 
  theme_bw() +
  scale_colour_discrete(name = "Steps in epoch") + 
  theme(legend.position = "bottom",
        legend.key = element_rect(colour = "white"),
        panel.grid.minor = element_blank())
p2
pdf("graphs/sampleRawPattern2.pdf",compress = FALSE )
p2
dev.off()

data[epoch_id == ymd_hms("2016-05-04 18:33:30"), sd(steps), device_id]