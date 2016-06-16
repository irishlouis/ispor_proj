# test model on same subjects different data
table(predict(final_model_id, eval1.summary), eval1.summary$device_id )
confusionMatrix(predict(init_model_id,eval1.summary), ifelse(eval1.summary$device_id == "TAS1E35150289", "louis", "not_louis"))
confusionMatrix(predict(final_model_id,eval1.summary), ifelse(eval1.summary$device_id == "TAS1E35150289", "louis", "not_louis"))

# test model on different subjects
table(predict(final_model_id, eval2.summary), eval2.summary$device_id)
l <- as.factor(c("louis", rep("not_louis", nrow(eval2.summary))))
confusionMatrix(predict(init_model_id, eval2.summary), l[-1] )
confusionMatrix(predict(final_model_id, eval2.summary), l[-1] )

