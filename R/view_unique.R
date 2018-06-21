#' View unique occurence and counts
#'
#' @description
#'     View unique occurences and counts of taxa to help identify misspelled
#'     taxon.
#'
#' @usage
#'     view_unique(x, col)
#'
#' @param x
#'     A data frame containing the vector of taxa names to be cleaned.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be cleaned.
#'
#' @return
#'     A data frame with taxa and associated counts found in the input, sorted
#'     alphabetically by taxa.
#'
#' @export
#'

view_unique <- function(x, col){

# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'data.frame'){
    stop('Input argument "x" must be a data frame!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }

# Count unique taxa -------------------------------------------------------

  unique_taxa <- table(x[ , col])

  View(unique_taxa)

# Return output -----------------------------------------------------------

  unique_taxa

}
