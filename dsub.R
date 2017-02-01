# Script: dsub.R
# Author: Maurício Collaça
# Date: 24/Jan/2017
# Description: Data Frame Pattern Matching and Replacement

dsub <- function(dfname, colname, grepPattern, subPattern, replacement, explain = TRUE, verbose = TRUE) {
    envir = where(dfname)
    subset <- grep(grepPattern, get(dfname)[[colname]])
    rows <- length(subset)
    if (rows == 0){
        message("No match(es) for grep pattern \"", escapeBS(grepPattern) ,"\"\n")
        return(invisible(rows))
    }
    replacePatterns <- unique(sub(grepPattern, subPattern, get(dfname)[subset, colname])) # Unique replacement patterns by replacing the match pattern with the match memory
    replacePatternCount <- length(replacePatterns)
    if (replacePatternCount > 1) {
        message("Grep pattern \"", escapeBS(grepPattern), "\" matches ", rows, " row(s)")
        message("Sub pattern \"", escapeBS(subPattern), "\" results in ", replacePatternCount, " distinct replacement patterns:\n")
        print(paste0("\"", replacePatterns, "\"", collapse=", "), quote = FALSE)
        message("\nOnly the first replacement pattern \"", replacePatterns[1], "\" will be used, discarding:\n")
        print(paste0("\"", replacePatterns[2:replacePatternCount], "\"", collapse = ", "), quote = FALSE)
        message("\nIt's a misuse of dsub() and recommended to review the grep and sub patterns\n")
    }
    replacePattern <- replacePatterns[1]
    subset.string <- deparse(subset, width.cutoff = 500L, control = "warnIncomplete")
    sentence <- paste0(dfname,"[",subset.string,", \"",colname,"\"] <- sub(\"",
                              replacePattern,"\", \"", escapeBS(replacement), "\", ",dfname,"[",subset.string,", \"",colname,"\"])")
    expression <- parse(text = sentence)
    before <- get(dfname)[subset, colname]
    after <-  sub(replacePattern, replacement, before)
    if (explain) {
        message("It would affect ", rows, " row(s) with the sentence: ", sentence, "\n")
        if (verbose) {
            message("The detailed value changes would be:\n")
            print(paste(paste0('"', before, '"'), paste0('"', after, '"'),sep = " <- "), quote = FALSE)
        }
        return(invisible(after))
    } else {
        eval(expression, envir)
        if (verbose) {
            message("It was affected ", rows, " row(s) with the sentence: ", sentence, "\n")
            message("The detailed value changes were:\n")
            print(paste(paste0('"', before, '"'), paste0('"', get(dfname, envir)[subset, colname] , '"'),sep = " <- "), quote = FALSE)
        } 
        return(invisible(get(dfname, envir)[subset, colname]))
    }
}

escapeBS <- function(string) {
    gsub('\\\\', '\\\\\\\\\\', string)
}

escapeRegex <- function(string) {
    gsub('([.|()\\^{}+$*?]|\\[|\\])', '\\\\\\1', string)
}

to_env <- function(x, quiet = FALSE) {
    if (is.environment(x)) {
        x
    } else if (is.list(x)) {
        list2env(x)
    } else if (is.function(x)) {
        environment(x)
    } else if (length(x) == 1 && is.character(x)) {
        if (!quiet) message("Using environment ", x)
        as.environment(x)
    } else if (length(x) == 1 && is.numeric(x) && x > 0) {
        if (!quiet) message("Using environment ", search()[x])
        as.environment(x)
    } else {
        stop("Input can not be coerced to an environment", call. = FALSE)
    }
}

where <- function(name, env = parent.frame()) {
    stopifnot(is.character(name), length(name) == 1)
    env <- to_env(env)
    
    if (identical(env, emptyenv())) {
        stop("Can't find ", name, call. = FALSE)
    }
    
    if (exists(name, env, inherits = FALSE)) {
        env
    } else {
        where(name, parent.env(env))
    }
}
