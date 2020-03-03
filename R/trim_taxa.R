#' Trim taxa
#'
#' @description
#'     Trim excess text from taxa names. Doing this before querying a taxonomic
#'     authority improves matching.
#'
#' @param x
#'     (character) A list of taxa names
#' @param path
#'     (character) The path to the directory containing taxa_map.csv
#'
#' @details
#'     Characters trimmed by this function:
#'     \itemize{
#'         \item{White spaces (trailing and leading)}
#'         \item{Species abbreviations following a genus value (e.g. "Sp.",
#'         "Spp.", "Cf.", "Cf...", etc.)}
#'     }
#'
#' @return
#'     \itemize{
#'         \item{If using \code{x}, then an updated list of taxa is returned.}
#'         \item{If using \code{path}, then an updated version of taxa_map.csv
#'         is written to file and returned as a data frame.}
#'     }
#'
#' @examples
#' # Input a list of names
#'
#' my_taxa <- c("Koeleria_cristata", "Cyperus sp.", "Poa Cf.   ")
#' my_taxa <- trim_taxa(x = my_taxa)
#' my_taxa
#'
#' # Input taxa_map.csv
#'
#' data <- data.table::fread(system.file("example_data.txt", package = 'taxonomyCleanr'))
#' my_path <- tempdir()
#' tm <- create_taxa_map(path = my_path, x = data, col = "Species")
#' tm <- trim_taxa(path = my_path)
#' tm
#'
#' @export
#'


trim_taxa <- function(x = NULL, path = NULL){


# Check arguments -------------------------------------------------------------

  if (!is.null(path)) {
    if (!file.exists(paste0(path, '/taxa_map.csv'))) {
      stop('taxa_map.csv is missing! Create it create_taxa_map().')
    }
  }

  if (!is.null(x)){
    if (!is.character(x)){
      stop('Input argument "x" must be a character vector.')
    }
  }

# Read taxa_map.csv -----------------------------------------------------------

  if (!is.null(path)) {
    x <- read_taxa_map(path)
  }

  # Replace underscores with blank spaces -------------------------------------

  if (!is.null(path)) {
    x[ , 'taxa_trimmed'] <- stringr::str_replace_all(
      x[ , 'taxa_raw'],
      '_',
      ' ')
  } else {
    x <- stringr::str_replace_all(x, '_', ' ')
  }

  # Trim white space ----------------------------------------------------------

  if (!is.null(path)) {
    x[ , 'taxa_trimmed'] <- stringr::str_trim(
      x[ , 'taxa_trimmed'],
      'both')
  } else {
    x <- stringr::str_trim(x, 'both')
  }

  # Remove common species abbreviations at the genus level --------------------

  if (!is.null(path)) {
    x[ , 'taxa_trimmed'] <- stringr::str_remove(
      x[ , 'taxa_trimmed'],
      paste0(
        '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*)+$',
        '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$'))
  } else {
    x <- stringr::str_remove(
      x,
      paste0(
        '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*)+$',
        '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$'))
  }

  # Document provenance -------------------------------------------------------
  # If input is taxa_map.csv, then list corrected names in the taxa_trimmed
  # column.

  if (!is.null(path)){
    x[ , 'taxa_trimmed'][x[ , 'taxa_raw'] == x[ , 'taxa_trimmed']] <-
      NA_character_
    if (!is.null(path)){
      if (path !=
          dirname(system.file('test_data.txt', package = 'taxonomyCleanr'))){
        write_taxa_map(x, path)
      }
    }

  }

  # Return object -------------------------------------------------------------

  x

}
