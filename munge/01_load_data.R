# get csv files from /data

# load training / testing dataset 
## data from louis and triona and 1 dog
train.data <- load.data(datafolder = "louis1")
cache("train.data")




# load final evaluation dataset for unseen subjects
## data from marie and 2 dogs
eval2.data <- load.data(datafolder = "marie")
cache("eval2.data")
