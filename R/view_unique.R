#' View unique occurence and counts
#'
#' @description
#'     View unique occurences and counts of taxa to help identify misspelled
#'     taxon.
#'
#' @usage
#'     view_unique(x)
#'
#' @param x
#'     A character string, or vector of character strings, representing taxa
#'     names to be analyzed.
#'
#' @return
#'     A data frame with taxa and associated counts found in the input, sorted
#'     alphabetically by taxa.
#'
#' @export
#'


view_unique <- function(x){

  unique_taxa <- table(x)

  View(unique_taxa)

  # Return --------------------------------------------------------------------

  unique_taxa

}
