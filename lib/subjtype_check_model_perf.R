#' subjtype.check.model.perf
#' @description run list of models and return Kappa values, to run MC model validation
#'
#' @param seed - seed to split data on 
#' @param model.data - model data to partition
#'
#' @return Kappa values for models run
#' @export
#'
#' @examples
subjtype.check.model.perf <- function(seed, model.data){
  set.seed(seed)
  # partition data for building model
  s <- createDataPartition(model.data$subj_type, p = 0.6, list = FALSE)
  training <- model.data[s][,':='(
    device_id = NULL,
    epoch_id = NULL)]
  testing <- model.data[-s][,':='(
    device_id = NULL,
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
  model_list <- caretList(subj_type ~ ., 
                          data=training, 
                          trControl=my_control,
                          methodList=c('gbm','xgbTree', 'rf', 'svmRadial', 'C5.0'), 
                          tuneLength = 5)
  
  # look at validation results for each 
  return(lapply(model_list, 
                function(x) confusionMatrix(predict(x, testing), testing$subj_type)$overall[2]) %>% unlist)
}