# Script: HAR-utils.R
# Author: Maurício Collaça Ramos
# Date: 05/Jan/2017
# Description: a set of common functions for the HAR data set analysis V1.0

## HAR data set path builder

HARpath <- function(..., path = getwd()) {
    file.path(path, "UCI HAR Dataset", ...)
}

## Read HAR data set wrapper functions

read_features <- function(path = HARpath(), file = "features.txt") {
    read_id_name(path, file)
}

read_activity_labels <- function(path = HARpath(), file = "activity_labels.txt") {
    read_id_name(path, file)
}

read_X_train <- function(path = HARpath("train"), file = "X_train.txt") {
    read_X(path, file)
}

read_y_train <- function(path = HARpath("train"), file = "y_train.txt") {
    read_y(path, file)
}

read_subject_train <- function(path = HARpath("train"), file = "subject_train.txt") {
    read_subject(path, file)
}

read_X_test <- function(path = HARpath("test"), file = "X_test.txt") {
    read_X(path, file)
}

read_y_test <- function(path = HARpath("test"), file = "y_test.txt") {
    read_y(path, file)
}

read_subject_test <- function(path = HARpath("test"), file = "subject_test.txt") {
    read_subject(path, file)
}

## Read.table wrapper functions

read_id_name <- function(...) {
    read.table(file.path(...), col.names = c("id", "name"),
               stringsAsFactors = FALSE)    
}

read_y <- function(...) {
    read.table(file.path(...), col.names = "activity")
}

read_subject <- function(...) {
    read.table(file.path(...), col.names = "subject")
}

read_X<- function(...) {
    read.table(file.path(...), col.names = 1:561,
               check.names = FALSE, colClasses = "numeric")
}

##################################################
## Additional functions not used by run_analysis.R
##################################################

read_signals <- function(path = HARpath(), file = "features_info.txt") {
    read.table(file.path(path, file), col.names = "name",
               stringsAsFactors = FALSE, skip = 12, nrows = 17)
}

read_statistics <- function(path = HARpath(), file = "features_info.txt") {
    read.table(file.path(path, file), col.names = c("name","description"),
               stringsAsFactors = FALSE, skip = 32, nrows = 17,
               sep = ":", strip.white = TRUE)
}

read_angleVectors <- function(path = HARpath(), file = "features_info.txt") {
    read.table(file.path(path, file), col.names = "name",
               stringsAsFactors = FALSE, skip = 52, nrows = 5)
}

## Read.table wrapper function for "features_info.txt"
read_features_info <- function(path, file ="features_info.txt", col.names, 
                               stringAsFactors = FALSE, skip, nrows, ...) {
    read.table(file.path(path,file), col.names, stringAsFactors, skip, nrows,
               ...)
}

## dsub() Experimental Data Frame Pattern Matching and Replacement
## pseudo-call-by-reference function
dsub <- function(df,col,pattern,replacement,explain=TRUE) {
    filter <- grep(pattern, df[[col]])
    rows <- length(filter)
    if (rows == 0){
        message(paste0("No match(es) for pattern '",pattern,"'"), appendLF = TRUE)
        return(invisible(rows))
    }
    replacePattern <- unique(sub(paste0(pattern,".*|.*"),"\\1",df[filter,col]))
    replacements <- length(replacePattern)
    uniqueReplacePattern <- unique(replacePattern)
    uniqueReplacements <- length(uniqueReplacePattern)
    if (replacements > 1) {
        warning(paste0("pattern '",
                       pattern,
                       "' matches ",
                       rows,
                       " rows but there are ",
                       uniqueReplacements,
                       " distinct replacements and only the first '",
                       uniqueReplacePattern,
                       "' will be used, discarding ",
                       paste0("'",replacePattern[2:replacements],"' ", collapse = ",")), appendLF=TRUE)
    }
    substitute <- substitute(df[filter, col] <- sub(uniqueReplacePattern, replacement, df[filter, col]))
    if (!explain) {
        eval.parent(substitute)
        message("Affected ", rows, " row(s): ", substitute[2], substitute[1], substitute[3], appendLF = TRUE)
        return(eval.parent(substitute(df[filter, col])))
    } else{
        message("Would affect ", rows, " row(s): ", substitute[2], substitute[1], substitute[3], appendLF = TRUE)
        return(df[filter, col])
    }
}

bandsEnergyBins <- function() {
    # interval series:
    # 8 in 64: [1,8],[9,16],[17,24],[25,32],[33,40],[41,48],[49,56],[57,64]
    # 4 in 64: [1,16],[17,32],[33,48],[49,64]
    # 2 in 48: [1,24],[25,48]

    list(levels(cut(c(1:64), breaks = 8, dig.lab=2)),
         levels(cut(c(1:64), breaks = 4, dig.lab=2)),
         levels(cut(c(1:48), breaks = 2, dig.lab=2)))
    
    # cut converts numeric vector c(1:n) by cutting it into breaks of either a
    # vector of cutting points > 2 or a number of intervals >=2)

}

