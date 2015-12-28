#This script kicks off the whole process

#setwd("~/GitHub/GetDataProject")

#install.packages("rmarkdown")
require(rmarkdown)

file <- "getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(file)) {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    message(sprintf("start downloaded from '%s'", url))
    download.file(url, file.path(getwd(), file))
    message(sprintf("downloaded '%s' from '%s'", file, url))
}

datadir <- "UCI HAR Dataset"
if (!dir.exists(datadir))
    stop(sprintf("'%s' folder not found in working directory", datadir))

render("Tidy_Data.Rmd", "all")
