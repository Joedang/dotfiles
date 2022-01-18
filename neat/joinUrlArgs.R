joinUrlArgs <- function(latitude=NULL, longitude=NULL, ...) {
    # This is a neat example of how you could make a function that nicely saves typing for common arguments
    # while also joining together ad-hoc arguments.
    # The imagined use case here would be for generating URLs that are used to query remote databases.
    argNames <- c("latitude", "longitude", ...names()) # create a vector of all the names of the arguments
    argVals_list <- list(latitude, longitude, ...) # make a list of all the argument values

    nonNulls <- !sapply(argVals_list, is.null) # identify the null values
    argNames <- argNames[nonNulls] # remove the names that correspond to a NULL value
    argVals <- sapply(argVals_list[nonNulls], as.character) # remove the NULL values and convert to a vector of characters

    # cat("argNames:", argNames, "\n") # debug
    # cat("argVals:", argVals, "\n")

    paste(argNames, argVals, sep="=", collapse="&") # put = between names and values; put & between arguments
}
