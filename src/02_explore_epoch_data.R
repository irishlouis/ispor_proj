p3 <- ggplot(epoch[timestamp >= ymd_hms("20160504 183000") & timestamp <= ymd_hms("20160504 185500") & serialnumber != "TAS1E31150005"], 
       aes(timestamp, steps, group = serialnumber)) + 
  geom_line() +
  facet_wrap(~serialnumber, ncol = 1) + 
  labs(title = "Summary of step activity from 5s epochs",
       subtitle = "Steps per epoch data for adult 2 subjects and a dog.\nContinuous walking except for a short break when one of the subjects went for swim in river.",
       caption = "Data filtered to show walking period between 18:30 - 18:55",
       y = "Steps / epoch",
       x = "Time (hh:mm)") + 
  theme_bw() +
  theme(legend.position = "none",
        panel.grid.minor = element_blank())
p3
pdf("graphs/epochStepSummary.pdf", compress = FALSE)
p3
dev.off()