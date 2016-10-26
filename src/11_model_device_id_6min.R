# optimise best model

# create model.data, filtering out epochs with low steps
## drop steps - only want numeric
model.data <- train.summary %>% 
  select(-steps, -subj_type) 

training <- model.data[epoch_id < ymd_hms("20160504 183600")][,':='(
  epoch_id = NULL)]
testing <- model.data[epoch_id >= ymd_hms("20160504 183600")][,':='(
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
set.seed(748159)
init_model_dev_id_first_6min <- train(device_id ~ ., 
                    data = training, 
                    trControl = init_control,
                    metric = "Kappa",
                    method = "nnet",
                    tuneLength = 10)
# The final values used for the model were size = 5 and decay = 0.006772878
varImp(init_model_dev_id_first_6min)
plot(varImp(init_model_dev_id_first_6min))

# look at validation results 
confusionMatrix(predict(init_model_dev_id_first_6min, testing), testing$device_id)
init_model_dev_id_first_6min
cache("init_model_dev_id_first_6min")

# beyond test data
## same subjects different day
table(predict(init_model_dev_id_first_6min, eval1.summary), eval1.summary$device_id)
## different subjects different day
table(predict(init_model_dev_id_first_6min, eval2.summary), eval2.summary$device_id)

