# optimise best model

# create model.data, filtering out epochs with low steps
model.data <- train.summary

set.seed(456456)
s <- createDataPartition(model.data$subj_type, p = 0.6, list = FALSE)
training <- model.data[s][,':='(
  device_id = NULL,
  epoch_id = NULL)]
testing <- model.data[-s][,':='(
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
init_model <- train(subj_type ~ ., 
                    data = training, 
                    trControl = init_control,
                    metric = "Kappa",
                    method = "svmRadial",
                    tuneLength = 10)
#The best random values are sigma = 1.956941 and C = 9.940983

# look at validation results 
confusionMatrix(predict(init_model, testing), testing$subj_type)
init_model

###############################################
#
# can we improve model performance with tuning paramters

# new simpler ctrl func
optimise_ctrl <- trainControl(method = "repeatedcv", repeats = 5)

# function to opt model
svm_fit_bayes <- function(C, sigma) {
  ## Use the same model code but for a single (C, sigma) pair. 
  txt <- capture.output(
    mod <- train(subj_type ~ ., data = training,
                 method = "svmRadial",
                 metric = "Kappa",
                 trControl = optimise_ctrl,
                 tuneGrid = data.frame(C = C, sigma = sigma))
  )
  list(Score = getTrainPerf(mod)[, "TrainKappa"], Pred = 0)
}
# set bounds for search
bounds <- list(
  C = c(C = 0, C = 200),
  sigma = c(sigma = 0, sigma = 25))

# search for optimum model parameters
set.seed(8606)
ba_search <- BayesianOptimization(FUN = svm_fit_bayes, 
                                  bounds = bounds,
                                  init_points = 5, 
                                  n_iter = 50,
                                  acq = "ucb", 
                                  kappa = 1, 
                                  eps = 0.0,
                                  verbose = TRUE)
cache("ba_search")
#' Best Parameters Found: 
#' Round = 15	C = 123.7352	sigma = 0.7303	Value = 0.9896 

set.seed(456798)
final_svm <- train(subj_type ~ ., 
                      data = training,
                      method = "svmRadial",
                      tuneGrid = data.frame(C = exp(ba_search$Best_Par["C"]),
                                            sigma = exp(ba_search$Best_Par["sigma"])),
                      metric = "Kappa",
                      trControl = optimise_ctrl)

confusionMatrix(predict(final_svm, testing), testing$subj_type)
confusionMatrix(predict(init_model, testing), testing$subj_type)

# no difference in performance 
compare_models(final_svm, init_model)

cache("final_svm")
