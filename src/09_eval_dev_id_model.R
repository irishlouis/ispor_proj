# test model on same subjects different data
table(predict(final_model_dev_id, eval1.summary), eval1.summary$device_id )
l <- ifelse(eval1.summary$device_id == "TAS1E31150030", 
            "TAS1E31150003",
            ifelse(eval1.summary$device_id == "TAS1E35150289",
                   "TAS1E31150028",
                   "TAS1E31150059"))
confusionMatrix(predict(init_model_dev_id, eval1.summary), l)
confusionMatrix(predict(final_model_dev_id, eval1.summary), l)

# test model on different subjects
table(predict(init_model_dev_id, eval2.summary), eval2.summary$device_id)
table(predict(final_model_dev_id, eval2.summary), eval2.summary$device_id)