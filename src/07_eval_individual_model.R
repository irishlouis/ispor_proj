# test model on same subjects different data
table(predict(final_model_id, eval1.summary), eval1.summary$device_id )
message("accuracy = ", (286 + 244 + 285) / sum(table(predict(final_model_id, eval1.summary), eval1.summary$device_id )), "%")



# test model on different subjects
table(predict(final_model_id, eval2.summary), eval2.summary$device_id)
message("accuracy = ", (178+169+173) / sum(table(predict(final_model_id, eval2.summary), eval2.summary$device_id )), "%")
