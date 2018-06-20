#' Replace taxon
#'
#' @description
#'     Replace a taxon name of a data frame with a user specified name.
#'
#' @usage
#'     update_taxon_name(x, taxa.col, input, output)
#'
#' @param x
#'     The data frame containing a vector of taxa names to be operated on.
#' @param taxa.col
#'     A character string specifying the column name containing taxa names to
#'     be operated on.
#' @param input
#'     A character string specifying the extant taxon name.
#' @param output
#'     A character string specifying the taxon name to replace the extant taxon
#'     name.
#'
#' @return
#'     Your data frame (x) with the updated taxa names.
#'
#' @export
#'

replace_taxon <- function(x, taxa.col, input, output){


# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(input)){
    stop('Input argument "input" is missing!')
  }
  if (missing(taxa.col)){
    stop('Input argument "taxa.col" is missing!')
  }
  if (missing(output)){
    stop('Input argument "output" is missing!')
  }

# Update taxon ------------------------------------------------------------

  use_i <- x[ ,taxa.col] == input

  x[ ,taxa.col][use_i] <- output


# Return ------------------------------------------------------------------

  x

}
