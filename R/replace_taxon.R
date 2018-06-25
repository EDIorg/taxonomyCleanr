#' Replace taxon
#'
#' @description
#'     Replace a taxon name with another.
#'
#' @usage
#'     update_taxon_name(path, input, output)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#' @param input
#'     A character string specifying an existing taxon name.
#' @param output
#'     A character string specifying a replacement taxon name.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with new taxa names.
#'         \item{2.} A data frame of taxa_map.csv with new taxa names.
#'     }
#'
#' @export
#'

replace_taxon <- function(path, input, output){


  # Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "x" is missing!')
  }
  if (missing(input)){
    stop('Input argument "input" is missing!')
  }
  if (missing(output)){
    stop('Input argument "output" is missing!')
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

  x <- suppressMessages(
    as.data.frame(
      read_csv(
        paste0(
          path,
          '/taxa_map.csv'
        )
      )
    )
  )

  # Update taxon ------------------------------------------------------------

  use_i <- x[ , 'taxa_raw'] == input

  if (sum(use_i) == 0){
    stop(
      paste0(
        '"',
        input,
        '"',
        'does not match any taxa. Check your spelling.'
      )
    )
  } else {
    x[use_i, 'taxa_replacement'] <- output
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
