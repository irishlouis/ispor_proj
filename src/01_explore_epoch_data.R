#' summary of steps found for each device / subj type
#' illustrates that this is a problem

# train / test data louis1
train.summary[ ,.(n.steps = sum(steps)), .(device_id, subj_type)]
# eval1 data louis2
eval1.summary[ ,.(n.steps = sum(steps)), .(device_id, subj_type)]
# eval2 data marie1
eval2.summary[ ,.(n.steps = sum(steps)), .(device_id, subj_type)]

# plots
## save as pdf to /graphs
pdf("graphs/trainEpochStepSummary.pdf", compress = FALSE)
print.epoch(train.summary)
dev.off ()

pdf("graphs/eval1EpochStepSummary.pdf", compress = FALSE)
print.epoch(eval1.summary)
dev.off ()

pdf("graphs/eval2EpochStepSummary.pdf", compress = FALSE)
print.epoch(eval2.summary)
dev.off ()
