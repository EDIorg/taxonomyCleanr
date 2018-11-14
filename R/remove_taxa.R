#' Remove taxa
#'
#' @description
#'     Remove a taxon, and the associated record, from a data frame.
#'
#' @usage
#'     remove_taxa(input, x = NULL, col = NULL, path = NULL)
#'
#' @param input
#'     (character) A character string specifying the taxon to be removed.
#' @param x
#'     (character vector or data frame) Data containing taxa to be removed.
#' @param col
#'     (character) A character string specifying the column in x containing
#'     taxa names to be cleaned. NOTE: Don't use this argument if x is a
#'     vector of character strings.
#' @param path
#'     (character) A character string specifying the path to taxa_map.csv.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with removed taxa names.
#'         \item{2.} A data frame of taxa_map.csv with removed taxa names, if
#'         the path argument is supplied.
#'     }
#'
#' @export
#'

remove_taxa <- function(input, x = NULL, col = NULL, path = NULL){


  # Check arguments ---------------------------------------------------------

  if (missing(input)){
    stop('Input argument "input" is missing.')
  }

  if (!is.null(x)){
    if ((class(x) != 'data.frame') & (class(x) != 'character')){
      stop('Input argument "x" must be a data frame or of character class!')
    }
    if (class(x) == 'data.frame'){
      if (is.null(col)){
        stop('Input argument "col" is missing!')
      }
    } else if ((is.character(x))){
      x <- data.frame(
        taxa = x,
        stringsAsFactors = F
      )
      col <- 'taxa'
      }
    }

  # Read taxa_map.csv ---------------------------------------------------------

  if (!is.null(path)){
    EDIutils::validate_path(path)
    use_i <- file.exists(
      paste0(
        path,
        '/taxa_map.csv'
      )
    )
    if (!isTRUE(use_i)){
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }

    x <- utils::read.table(
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

  } else {

    # If character vector or data frame ---------------------------------------

    if (input == 'NA'){
      x[is.na(x[ , col]), col] <- 'NA'
    }

    use_i <- x[ , col] == input

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
      x <- x[!use_i, col]

    }

  }

  # Return ------------------------------------------------------------------

  x

}
