Codebook for Activity\_Tidy.txt
===============================

Human Activity Recognition Using Smartphones Data Set

Author: Thomas Berger
(<https://github.com/bergertom/GetDataProject.git>)

This codebook was generated on 2015-12-29 14:09:42 by running the script
`run_analysis.R`.

**The Codebook Dimensions are described at the end of this document.**

Steps to create
===============

1. Merges the training and the test sets to create one data set
---------------------------------------------------------------

    # read the column names (used for both train and test raw data)
    column_names <- read.table(file.path(getwd(), datadir,"features.txt"), col.names=c("index", "column_name"))

    # read the test data sets
    subject1  <- read.table(file.path(getwd(), datadir, "test" , "subject_test.txt"), col.names=c("Subject"))
    data1     <- read.table(file.path(getwd(), datadir, "test" , "X_test.txt"))
    activity1 <- read.table(file.path(getwd(), datadir, "test" , "Y_test.txt"), col.names=c("Activity"))
    # add column names to data1
    colnames(data1) <- column_names[,2]
    # column merge test data
    test_data <- cbind(subject1,activity1,data1)

    # read train data sets
    subject2  <- read.table(file.path(getwd(), datadir, "train" , "subject_train.txt"), col.names=c("Subject"))
    data2     <- read.table(file.path(getwd(), datadir, "train" , "X_train.txt"))
    activity2 <- read.table(file.path(getwd(), datadir, "train" , "Y_train.txt"), col.names=c("Activity"))
    # add column names to data2
    colnames(data2) <- column_names[,2]
    # column merge train data
    train_data <- cbind(subject2,activity2,data2)

    # row merge the final data frame
    data <- rbind(test_data, train_data)

2. Extracts only the measurements on the mean and standard deviation for each measurement
-----------------------------------------------------------------------------------------

    # filter for column names coainting 'mean()' or 'std()'
    activity_ok <- grepl('mean\\(\\)|std\\(\\)',column_names[,2])

    # add first to columns(Subject,Activity) to boolean vector
    column_filter <- append (c(TRUE,TRUE), activity_ok)

    # filter the columns
    data_filtered <- data[column_filter]

3. Uses descriptive activity names to name the activities in the data set
-------------------------------------------------------------------------

continue at step 4

4. Appropriately labels the data set with descriptive activity names
--------------------------------------------------------------------

    # read activity names
    activity_names<-read.table(file.path(getwd(), datadir, "activity_labels.txt"),sep=" ",col.names=c("activityLabel","Activity"))

    # map the activity code to an Activity_Name (cast because R is too smart, will use factor)
    data_filtered$Activity = as.character(activity_names[data_filtered$Activity,2])

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
-------------------------------------------------------------------------------------------------------------------

    # copy Subject and Activity
    data_tidy <- data_filtered[, 1:2]

    # tBodyAcc = mean (BodyAcc-mean()-X, tBodyAcc-mean()-Y,tBodyAcc-mean()-Z, tBodyAcc-std()-X, tBodyAcc-std()-Y,tBodyAcc-std()-Z)
    # fBodyBodyGyroJerkMag = mean (fBodyBodyGyroJerkMag-mean, fBodyBodyGyroJerkMag-std)

    # here define the new columns for the tidy data-set
    # this list is copied directly from the file "features_info.txt" 
    columns_data <- c( "tBodyAcc","tGravityAcc","tBodyAccJerk", "tBodyGyro","tBodyGyroJerk","tBodyAccMag", "tGravityAccMag","tBodyAccJerkMag",
                       "tBodyGyroMag", "tBodyGyroJerkMag","fBodyAcc", "fBodyAccJerk","fBodyGyro","fBodyAccMag","fBodyBodyAccJerkMag",
                       "fBodyBodyGyroMag", "fBodyBodyGyroJerkMag" )

    # calculate average for each value
    for (col_name in columns_data) {
        # loop through the column names
        col_numbers <- numeric()
        for (col_counter in 1:68) {
            acolumn_name  <- colnames(data_filtered)[col_counter]
            if (unlist(strsplit(acolumn_name, "-"))[1] == col_name) {
                # and add all matching names to the vector
                col_numbers <- c(col_numbers, col_counter)
            }
        }
        # calculate the average for the given subset of columns
        data_tidy[[col_name]] <- rowMeans(data_filtered[, col_numbers])
    }

    # write the dataset to a file
    write.table(data_tidy, file="Activity_Tidy.txt", quote = FALSE, sep = "\t", row.names = FALSE)

Dimensions
==========

<table>
<thead>
<tr class="header">
<th align="left">column name</th>
<th align="left">explanation</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Subject</td>
<td align="left">The Subjects are assigned a number in the range is from 1 to 30. defined in <code>X__test.txt</code> (2947) and <code>Y_train.txt</code> (7352) for a total of 10299 rows</td>
</tr>
<tr class="even">
<td align="left">Activity</td>
<td align="left">The Activity code is mapped using the file <code>activity_labels.txt</code> (rows=6).</td>
</tr>
<tr class="odd">
<td align="left">tBodyAcc</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">tGravityAcc</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">tBodyAccJerk</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">tBodyGyro</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">tBodyGyroJerk</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">tBodyAccMag</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">tGravityAccMag</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">tBodyAccJerkMag</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">tBodyGyroMag</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">tBodyGyroJerkMag</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">fBodyAcc</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">fBodyAccJerk</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">fBodyGyro</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">fBodyAccMag</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">fBodyAccJerkMag</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">fBodyGyroMag</td>
<td align="left">mean value</td>
</tr>
<tr class="odd">
<td align="left">fBodyGyroJerkMag</td>
<td align="left">mean value</td>
</tr>
<tr class="even">
<td align="left">fBodyBodyGyroJerkMag</td>
<td align="left">mean value</td>
</tr>
</tbody>
</table>

The original data contains 561 different measurement values; which are
explained in the given file `features.txt`. The data for this database
come from combining the files `Y_test.txt` and `Y_train.txt` files. Then
only columns for mean and average are filtered. Then all data points
(X,Y,Z) are combined using the mean() function to create the 17 columns
listed above.
