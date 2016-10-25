# optimise best model

# create model.data, filtering out epochs with low steps
## drop steps - only want numeric
model.data <- train.summary %>% select(-steps)

training <- model.data[epoch_id < ymd_hms("20160504 183600")][,':='(
  device_id = NULL,
  epoch_id = NULL)]
testing <- model.data[epoch_id >= ymd_hms("20160504 183600")][,':='(
  device_id = NULL,
  epoch_id = NULL)]

# define model training control
init_control <- trainControl(
  method='repeatedcv',
  repeats=5,
  search="random",
  savePredictions=TRUE,
  classProbs=TRUE
)


# train list of models using control spec'd above
set.seed(456798)
first6_model <- train(subj_type ~ ., 
                    data = training, 
                    trControl = init_control,
                    metric = "Kappa",
                    method = "nnet",
                    tuneLength = 10)
# The final values used for the model were size = 5 and decay = 0.006772878
varImp(first6_model)
plot(varImp(first6_model))

# look at validation results 
confusionMatrix(predict(first6_model, testing), testing$subj_type)
