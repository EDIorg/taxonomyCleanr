#' Remove taxon
#'
#' @description
#'     Remove a taxon, and the associated record, from a data frame.
#'
#' @usage
#'     remove_taxon(x, taxa.col, input)
#'
#' @param x
#'     The data frame containing a vector of taxa names to be operated on.
#' @param taxa.col
#'     A character string specifying the column name containing taxa names to
#'     be operated on.
#' @param input
#'     A character string specifying the taxon to be removed.
#'
#' @return
#'     Your data frame (x) with the taxon and associated record removed.
#'
#' @export
#'

remove_taxon <- function(x, taxa.col, input){


  # Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(taxa.col)){
    stop('Input argument "taxa.col" is missing!')
  }
  if (missing(input)){
    stop('Input argument "input" is missing!')
  }
  if (length(input) > 1){
    stop('The argument "input" does not support character vectors!')
  }

  # Update taxon ------------------------------------------------------------

  use_i <- x[ ,taxa.col] == input

  x <- x[!use_i, ]


  # Return ------------------------------------------------------------------

  x

}
