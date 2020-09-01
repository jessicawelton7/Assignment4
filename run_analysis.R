library(dplyr)

# read train data 
X_train <- read.table("X_train.txt")
Y_train <- read.table("y_train.txt")
Sub_train <- read.table("subject_train.txt")

# read test data 
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
Sub_test <- read.table("subject_test.txt")

# read data description 
variable_names <- read.table("features.txt")

# read activity labels 
activity_labels <- read.table("activity_labels.txt")

# 1 - Merge the training & test sets 
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, y_test)
Sub_total <- rbind(Sub_train, Sub_test)

#2 - Extract only the mean & SD for each measurement 
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)", variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

#3 - Use descriptive names to name activities 
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,1]

#4 - Appropriately label the data set with descriptive variable names
colnames(X_total) <- variable_names[selected_var[,1],2]

#5 - Create independent tidy data set with the average of each variables for each activity & subject
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "tidydata.txt", row.names = FALSE, col.names = TRUE)
