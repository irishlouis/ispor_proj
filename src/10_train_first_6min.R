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
first6_model_type <- train(subj_type ~ ., 
                    data = training, 
                    trControl = init_control,
                    metric = "Kappa",
                    method = "nnet",
                    tuneLength = 10)
# The final values used for the model were size = 5 and decay = 0.006772878
varImp(first6_model_type)
plot(varImp(first6_model_type))

# look at validation results 
confusionMatrix(predict(first6_model_type, testing), testing$subj_type)
cache("first6_model_type")

# beyond test data
## same subjects different day
confusionMatrix(predict(first6_model_type, eval1.summary), eval1.summary$subj_type)
## different subjects different day
confusionMatrix(predict(first6_model_type, eval2.summary), eval2.summary$subj_type)
