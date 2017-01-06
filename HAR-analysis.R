# Script: HAR-analysis.R
# Author: Maurício Collaça Ramos
# Date: 05/Jan/2017
# Description: a set of common functions for the HAR data set analysis V1.0

read_features <- function(path, file) {read_id_label(path, file)}
read_activity_labels <- function(path, file) {read_id_label(path, file)}
read_X_train <- function(path, file) {read_X(path, file)}
read_y_train <- function(path, file) {read_y(path, file)}
read_subject_train <- function(path, file) {read_subject(path, file)}
read_X_test <- function(path, file) {read_X(path, file)}
read_y_test <- function(path, file) {read_y(path, file)}
read_subject_test <- function(path, file) {read_subject(path, file)}

read_id_label <- function(path, file) {
    read.table(file.path(path,file), col.names = c("id", "label"),
               stringsAsFactors = FALSE)    
}

read_y <- function(path, file) {
    read.table(file.path(path,file), header = FALSE, col.names = "activity")
}

read_subject <- function(path, file) {
    read.table(file.path(path,file), header = FALSE, col.names = "subject")
}

read_X<- function(path, file) {
    read.table(file.path(path,file), header = FALSE, col.names = 1:561,
               check.names = FALSE, colClasses = "numeric")
}

