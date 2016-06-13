#' checkModelPerf
#' @description run list of models and return Kappa values, to run MC model validation
#'
#' @param seed - seed to split data on 
#' @param model.data - model data to partition
#'
#' @return Kappa values for models run
#' @export
#'
#' @examples
check.model.perf <- function(seed, model.data){
  set.seed(seed)
  # partition data for building model
  s <- createDataPartition(model.data$device_id, p = 0.6, list = FALSE)
  training <- model.data[s][,':='(
    device_id = as.factor(device_id),
    steps = as.factor(steps),
    epoch_id = NULL)]
  testing <- model.data[-s][,':='(
    steps = as.factor(steps),
    device_id = as.factor(device_id),
    epoch_id = NULL)]
  
  # define model training control
  my_control <- caret::trainControl(
    method='repeatedcv',
    number=5,
    savePredictions=TRUE,
    classProbs=TRUE,
    search = "random"
  )
  
  # train list of models using control spec'd above
  model_list <- caretList(device_id ~ ., 
                          data=training, 
                          trControl=my_control,
                          methodList=c('gbm','xgbTree', 'rf', 'svmRadial', 'C5.0'), 
                          tuneLength = 5)
  
  # look at validation results for each 
  return(lapply(model_list, 
                function(x) confusionMatrix(predict(x, testing), testing$device_id)$overall[2]) %>% unlist)
}