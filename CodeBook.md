Codebook for Activity\_Tidy.txt
===============================

Human Activity Recognition Using Smartphones Data Set

Author: Thomas Berger
(<https://github.com/bergertom/GetDataProject.git>)

This codebook was generated on 2015-12-30 09:24:30 by running the script
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

    # calculate average for each value and document what is done
    col_documentation <- c("The Subjects are assigned numbers from 1 to 30.", "The Activity description")
    for (col_name in columns_data) {
        # loop through the column names
        col_numbers <- numeric()
        col_temp <- "mean of ("
        for (col_counter in 1:68) {
            acolumn_name  <- colnames(data_filtered)[col_counter]
            if (unlist(strsplit(acolumn_name, "-"))[1] == col_name) {
                # and add all matching names to the vector
                col_numbers <- c(col_numbers, col_counter)
                col_temp <- paste(col_temp, acolumn_name)
            }
        }
        # calculate the average for the given subset of columns
        data_tidy[[col_name]] <- rowMeans(data_filtered[, col_numbers])
        col_temp <- paste(col_temp, ")")
        col_documentation <- c(col_documentation, col_temp)
    }

    # write the dataset to a file
    write.table(data_tidy, file="Activity_Tidy.txt", quote = FALSE, sep = "\t", row.names = FALSE)

Dimensions
==========

The data-set `Activity_Tidy.txt` has a total of 10299 rows.

<table>
<thead>
<tr class="header">
<th align="left">column.name</th>
<th align="left">explanation</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Subject</td>
<td align="left">The Subjects are assigned numbers from 1 to 30.</td>
</tr>
<tr class="even">
<td align="left">Activity</td>
<td align="left">The Activity description</td>
</tr>
<tr class="odd">
<td align="left">tBodyAcc</td>
<td align="left">mean of ( tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z )</td>
</tr>
<tr class="even">
<td align="left">tGravityAcc</td>
<td align="left">mean of ( tGravityAcc-mean()-X tGravityAcc-mean()-Y tGravityAcc-mean()-Z tGravityAcc-std()-X tGravityAcc-std()-Y tGravityAcc-std()-Z )</td>
</tr>
<tr class="odd">
<td align="left">tBodyAccJerk</td>
<td align="left">mean of ( tBodyAccJerk-mean()-X tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z tBodyAccJerk-std()-X tBodyAccJerk-std()-Y tBodyAccJerk-std()-Z )</td>
</tr>
<tr class="even">
<td align="left">tBodyGyro</td>
<td align="left">mean of ( tBodyGyro-mean()-X tBodyGyro-mean()-Y tBodyGyro-mean()-Z tBodyGyro-std()-X tBodyGyro-std()-Y tBodyGyro-std()-Z )</td>
</tr>
<tr class="odd">
<td align="left">tBodyGyroJerk</td>
<td align="left">mean of ( tBodyGyroJerk-mean()-X tBodyGyroJerk-mean()-Y tBodyGyroJerk-mean()-Z tBodyGyroJerk-std()-X tBodyGyroJerk-std()-Y tBodyGyroJerk-std()-Z )</td>
</tr>
<tr class="even">
<td align="left">tBodyAccMag</td>
<td align="left">mean of ( tBodyAccMag-mean() tBodyAccMag-std() )</td>
</tr>
<tr class="odd">
<td align="left">tGravityAccMag</td>
<td align="left">mean of ( tGravityAccMag-mean() tGravityAccMag-std() )</td>
</tr>
<tr class="even">
<td align="left">tBodyAccJerkMag</td>
<td align="left">mean of ( tBodyAccJerkMag-mean() tBodyAccJerkMag-std() )</td>
</tr>
<tr class="odd">
<td align="left">tBodyGyroMag</td>
<td align="left">mean of ( tBodyGyroMag-mean() tBodyGyroMag-std() )</td>
</tr>
<tr class="even">
<td align="left">tBodyGyroJerkMag</td>
<td align="left">mean of ( tBodyGyroJerkMag-mean() tBodyGyroJerkMag-std() )</td>
</tr>
<tr class="odd">
<td align="left">fBodyAcc</td>
<td align="left">mean of ( fBodyAcc-mean()-X fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAcc-std()-X fBodyAcc-std()-Y fBodyAcc-std()-Z )</td>
</tr>
<tr class="even">
<td align="left">fBodyAccJerk</td>
<td align="left">mean of ( fBodyAccJerk-mean()-X fBodyAccJerk-mean()-Y fBodyAccJerk-mean()-Z fBodyAccJerk-std()-X fBodyAccJerk-std()-Y fBodyAccJerk-std()-Z )</td>
</tr>
<tr class="odd">
<td align="left">fBodyGyro</td>
<td align="left">mean of ( fBodyGyro-mean()-X fBodyGyro-mean()-Y fBodyGyro-mean()-Z fBodyGyro-std()-X fBodyGyro-std()-Y fBodyGyro-std()-Z )</td>
</tr>
<tr class="even">
<td align="left">fBodyAccMag</td>
<td align="left">mean of ( fBodyAccMag-mean() fBodyAccMag-std() )</td>
</tr>
<tr class="odd">
<td align="left">fBodyBodyAccJerkMag</td>
<td align="left">mean of ( fBodyBodyAccJerkMag-mean() fBodyBodyAccJerkMag-std() )</td>
</tr>
<tr class="even">
<td align="left">fBodyBodyGyroMag</td>
<td align="left">mean of ( fBodyBodyGyroMag-mean() fBodyBodyGyroMag-std() )</td>
</tr>
<tr class="odd">
<td align="left">fBodyBodyGyroJerkMag</td>
<td align="left">mean of ( fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std() )</td>
</tr>
</tbody>
</table>

The Subjects are defined in `X__test.txt` (rows=2947) and `Y_train.txt`
(rows=7352).

The Activity code was mapped using the file `activity_labels.txt`
(rows=6).

The original data contains 561 different measurement values; which are
explained in the given file `features.txt`. The data for this database
come from combining the files `Y_test.txt` and `Y_train.txt` files. Then
only columns for mean and average are filtered. Then all data points
(X,Y,Z) are combined using the mean() function to create the 17 tidy
data-set.

    dim(data_tidy)

    ## [1] 10299    19

    str(data_tidy)

    ## 'data.frame':    10299 obs. of  19 variables:
    ##  $ Subject             : int  2 2 2 2 2 2 2 2 2 2 ...
    ##  $ Activity            : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
    ##  $ tBodyAcc            : num  -0.384 -0.456 -0.466 -0.469 -0.47 ...
    ##  $ tGravityAcc         : num  -0.276 -0.358 -0.363 -0.363 -0.362 ...
    ##  $ tBodyAccJerk        : num  -0.461 -0.475 -0.481 -0.47 -0.476 ...
    ##  $ tBodyGyro           : num  -0.404 -0.472 -0.498 -0.495 -0.498 ...
    ##  $ tBodyGyroJerk       : num  -0.537 -0.523 -0.523 -0.526 -0.524 ...
    ##  $ tBodyAccMag         : num  -0.786 -0.961 -0.978 -0.976 -0.976 ...
    ##  $ tGravityAccMag      : num  -0.786 -0.961 -0.978 -0.976 -0.976 ...
    ##  $ tBodyAccJerkMag     : num  -0.913 -0.957 -0.976 -0.979 -0.988 ...
    ##  $ tBodyGyroMag        : num  -0.779 -0.905 -0.955 -0.959 -0.963 ...
    ##  $ tBodyGyroJerkMag    : num  -0.91 -0.959 -0.986 -0.987 -0.99 ...
    ##  $ fBodyAcc            : num  -0.856 -0.963 -0.976 -0.978 -0.98 ...
    ##  $ fBodyAccJerk        : num  -0.929 -0.968 -0.979 -0.98 -0.986 ...
    ##  $ fBodyGyro           : num  -0.872 -0.941 -0.976 -0.971 -0.974 ...
    ##  $ fBodyAccMag         : num  -0.751 -0.957 -0.98 -0.978 -0.978 ...
    ##  $ fBodyBodyAccJerkMag : num  -0.896 -0.94 -0.971 -0.975 -0.989 ...
    ##  $ fBodyBodyGyroMag    : num  -0.784 -0.921 -0.975 -0.974 -0.973 ...
    ##  $ fBodyBodyGyroJerkMag: num  -0.899 -0.945 -0.984 -0.986 -0.991 ...
