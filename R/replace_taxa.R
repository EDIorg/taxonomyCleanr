#' Replace taxa
#'
#' @description
#'     Replace a taxon name with another.
#'
#' @usage
#'     replace_taxa(input, output, x = NULL, col = NULL, path = NULL)
#'
#' @param input
#'     A character string specifying an existing taxon name.
#' @param output
#'     A character string specifying a replacement taxon name.
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

replace_taxa <- function(input, output, x = NULL, col = NULL, path = NULL){


  # Check arguments ---------------------------------------------------------

  if (missing(input)){
    stop('Input argument "input" is missing.')
  }
  if (missing(output)){
    stop('Input argument "output" is missing.')
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
    use_i <- file.exists(paste0(path, '/taxa_map.csv'))
    if (!isTRUE(use_i)){
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }

    # Read taxa_map.csv -------------------------------------------------------

    x <- suppressMessages(
      as.data.frame(
        readr::read_csv(
          paste0(
            path,
            '/taxa_map.csv'
          )
        )
      )
    )

    # x <- utils::read.table(paste0(path, '/taxa_map.csv'), header = T,sep = ',',
    #   stringsAsFactors = F)

    # Update taxa ------------------------------------------------------------

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
      x[use_i, 'taxa_replacement'] <- output
    }

    # Document provenance -----------------------------------------------------

    # Write to file
    lib_path <- system.file('test_data.txt', package = 'taxonomyCleanr')
    lib_path <- substr(lib_path, 1, nchar(lib_path) - 14)
    if (!is.null(path)){
      if (path != lib_path){
        write_taxa_map(x = x, path = path)
      }
    }

  } else {

    # If character or data frame ----------------------------------------------

    # Update taxa ------------------------------------------------------------

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
      x[use_i, col] <- output
    }

  }

  # Return ------------------------------------------------------------------

  x

}
