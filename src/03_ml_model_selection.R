
# create model.data, filtering out epochs with low steps
model.data <- summary[steps != "0-2.5"]

# run models to select best performing
set.seed(98315)
# set how many runs to do
n_resamples <- 30
seeds <- round(rep(runif(n_resamples, 1, 10000000)), 0)

# generate models using 30 different seeds to split training / testing and store Kappa values
resample.results <- do.call(rbind, 
                            lapply(seeds, function(s) {
                              print(which(seeds ==s))
                              return(check.model.perf(s, model.data))
                              })
                            )

# summary of kappa values for each model method for the 30 runs
summary(resample.results)

# plot resultant Kappa values
p4 <- ggplot(melt(resample.results, value.name = "kappa") %>% 
         mutate(Var2 = str_replace(Var2, ".Kappa", "")),
       aes(x=Var2, y=kappa)) + 
  geom_violin() +
  geom_boxplot(fill = "grey", alpha = 0.25) + 
  geom_point(alpha = 0.25) +
  theme_bw() +
  labs(title = "Kappa Results from Models - 30 Data Partitions",
       subtitle = "The evaluation results of models show some variation in performance depending on the data split.
       In general models are showing strong predictive power.",
       caption = "Grey box represents IQR with Median\nViolin plot shows distribution",
       x="",
       y="") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
        panel.grid.major.x = element_blank()) +
  scale_y_continuous(labels = percent)

p4
pdf("graphs/modelResampleKappa.pdf", compress = FALSE)
p4
dev.off()
