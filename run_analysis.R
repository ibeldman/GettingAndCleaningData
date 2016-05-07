## Getting and cleaning data course project
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Install required packages.
install.packages("data.table")

install.packages("reshape2")


# Load: activity labels and column names
activity_labels <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")[,2]

# Extracts only the measurements on the mean and standard deviation for each measurement (step 2).
features <- grepl("mean|std", features)

## TEST data
# Load x_test, y_test & subject_test data files.
x_test <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

names(x_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement (step 2).
x_test = x_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Binding data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

## TRAIN data
# Load and process x_train, y_train & subject_train data.
x_train <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset//train/y_train.txt")
subject_train <- read.table("C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

names(x_train) = features

# Extracts only the measurements on the mean and standard deviation for each measurement (step 2).
x_train = x_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)

# Merge test and train data (step 1)
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "C:/Users/IBeldman/Documents/Learning/Personal Learning/Coursera/3. Getting and Cleaning Data/Week 4/tidy_data.txt")

