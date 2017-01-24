# Script: dsub.R
# Author: Maurício Collaça Ramos
# Date: 24/Jan/2017
# Description: Data Frame Pattern Matching and Replacement

dsub <- function(df, col, matchPattern, replacement, explain = TRUE, verbose = TRUE, matchMemory = "\\1") {
    # subset data frame using the matchPattern argument
    subset <- grep(matchPattern, df[[col]])
    rows <- length(subset)
    if (rows == 0){
        message(paste0("No match(es) for the match pattern \"", matchPattern ,"\"\n"))
        return(invisible(rows))
    }
    # Unique replacement patterns for each df[subset,col] by replacing the match pattern with the match memory
    replacePatterns <- unique(sub(matchPattern, matchMemory, df[subset,col]))
    # If the match pattern contains "|" (OR operator), e.g. 
    # "(pattern1|pattern2)", and the replacement uses match memories that address that, e.g. 
    # "\\1", that likely results in multiple replacement patterns.  Multiple replacement patterns are assumed a
    # misuse use of dsub().  Rather than raise an error but still for the sake of a 
    # safer replacement, a warning is raised and only the first replacement pattern
    # is used.  That replicates the {base} sub() behaviour for a non scalar
    # replacement argument.
    replacePatternCount <- length(replacePatterns)
    if (replacePatternCount > 1) {
        warning(paste0("The match pattern \"", matchPattern,
                       "\" matches ", rows,
                       " rows but results in ", replacePatternCount,
                       " distinct replacement patterns:\n\n", paste0("\"", replacePatterns, "\"", collapse=", "), "\n\n",
                       "Only the first replacement pattern, \"", replacePatterns[1],
                       "\", would be used, discarding:\n\n",
                       paste0("\"", replacePatterns[2:replacePatternCount], "\"", collapse = ", "), "\n\n",
                       "It's assumed a misuse of dsub() and it's strongly recommended to review the match pattern, for instance, ending it with \".*\" or \"$\"\n"
        ),
        appendLF=TRUE)
    }
    replacePattern <- replacePatterns[1]
    # escapes all further parenthesis to avoid conflicts
    escapedPattern <- gsub("([\\(\\)])","\\\\\\1", replacePattern)
    # prepare the final replacement, replacing substrings, escape characters and match memories
    finalReplacement <- sub(paste0("(",escapedPattern,")"), replacement, replacePattern)
    # prepare the eval.parent() expression
    expressionParseTree <- substitute(df[subset, col] <- sub(escapedPattern, finalReplacement, df[subset, col]))
    friendlyExpression <- paste(expressionParseTree[2], expressionParseTree[1], expressionParseTree[3])
    if (explain) {
        message("It would affect ", rows, " row(s) with the sentence: \n\n", friendlyExpression, "\n")
        explainResults <- sub(escapedPattern, finalReplacement, df[subset, col])
        if (verbose)
            print(paste(paste0('"', df[subset, col], '"'),
                        paste0('"', explainResults, '"'),
                        sep = " <- "), quote = FALSE)
        return(invisible(explainResults))
    } else {
        eval.parent(expressionParseTree)
        if (verbose) {
            message("It was affected ", rows, " row(s) with the sentence: \n\n", friendlyExpression, "\n")
            return(eval.parent(substitute(df[subset, col])))
        } else
            return(invisible(eval.parent(substitute(df[subset, col]))))
    }
}
