# test model on different subjects
confusionMatrix(predict(final_svm, eval2.summary), eval2.summary$subj_type)


