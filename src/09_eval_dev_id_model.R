# test model on same subjects different data
table(predict(final_model_dev_id, eval1.summary), eval1.summary$device_id )
message("accuracy = ", sum(diag(table(predict(final_model_dev_id, eval1.summary), eval1.summary$device_id ))) / 
          sum(table(predict(final_model_dev_id, eval1.summary), eval1.summary$device_id )), "%")


# test model on different subjects
table(predict(final_model_dev_id, eval2.summary), eval2.summary$device_id)
