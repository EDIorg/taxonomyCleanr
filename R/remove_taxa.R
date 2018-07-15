#' Remove taxa
#'
#' @description
#'     Remove a taxon, and the associated record, from a data frame.
#'
#' @usage
#'     remove_taxa(x, taxa.col, input)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#' @param input
#'     A character string specifying the taxon to be removed.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with removed taxa names.
#'         \item{2.} A data frame of taxa_map.csv with removed taxa names.
#'     }
#'
#' @export
#'

remove_taxa <- function(path, input){


  # Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(input)){
    stop('Input argument "input" is missing!')
  }
  if (length(input) > 1){
    stop('The argument "input" does not support character vectors!')
  }

  validate_path(path)

  use_i <- file.exists(
    paste0(
      path,
      '/taxa_map.csv'
    )
  )
  if (!isTRUE(use_i)){
    stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
  }

  # Read taxa_map.csv -------------------------------------------------------

  x <- read.table(
    paste0(
      path,
      '/taxa_map.csv'
    ),
    header = T,
    sep = ',',
    stringsAsFactors = F
  )

  # Update taxa ------------------------------------------------------------

  if (input == 'NA'){
    x[is.na(x[ , 'taxa_raw']), 'taxa_raw'] <- 'NA'
  }

  use_i <- x[ , 'taxa_raw'] == input

  if (sum(use_i, na.rm = T) == 0){
    stop(
      paste0(
        '"',
        input,
        '"',
        'does not match any taxa. Check your spelling.'
      )
    )
  } else {
    use_i[is.na(use_i)] <- FALSE
    x[use_i, 'taxa_removed'] <- "TRUE"
  }

  # Document provenance -----------------------------------------------------

  # Write to file

  write_taxa_map(
    x = x,
    path = path
  )

  # Return ------------------------------------------------------------------

  x

}
