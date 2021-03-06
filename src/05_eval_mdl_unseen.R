# test model on same subjects different data
confusionMatrix(predict(init_model, eval1.summary), eval1.summary$subj_type)
confusionMatrix(predict(final_model, eval1.summary), eval1.summary$subj_type)


# test model on different subjects
confusionMatrix(predict(init_model, eval2.summary), eval2.summary$subj_type)
confusionMatrix(predict(final_model, eval2.summary), eval2.summary$subj_type)



