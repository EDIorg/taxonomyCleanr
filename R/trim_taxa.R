#' Trim taxa
#'
#' @description
#'     Trim excess text from taxa names. Doing this before querying a taxonomic
#'     authority reduces the frequency of mismatches.
#'
#' @usage
#'     trim_taxa(path = NULL, x = NULL)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#' @param x
#'     (character) A vector of taxa to be trimmed.
#'
#' @details
#'     List of conditions `trim_taxa` addresses:
#'     \itemize{
#'         \item{'White spaces, trailing and leading'} White spaces are common.
#'         \item{'Species abbreviations trailing a genus value'} E.g. "Sp.",
#'         "Spp.", "Cf.", "Cf...", etc.
#'     }
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with trimmed taxa strings.
#'         \item{2.} A data frame of taxa_map.csv with trimmed taxa strings.
#'     }
#'
#' @export
#'


trim_taxa <- function(path = NULL, x = NULL){


# Check arguments ---------------------------------------------------------

  if (!is.null(path)){
    use_i <- file.exists(
      paste0(
        path,
        '/taxa_map.csv'
      )
    )
    if (!isTRUE(use_i)){
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }
  }

  if (!is.null(x)){
    if (!is.character(x)){
      stop('Input argument "x" must be a character vector.')
    }
  }


# Read taxa_map.csv -------------------------------------------------------

  if (!is.null(path)){
    x <- utils::read.table(
      paste0(
        path,
        '/taxa_map.csv'
      ),
      header = T,
      sep = ',',
      stringsAsFactors = F
    )
  }

  # Replace underscores with blank spaces -------------------------------------

  if (!is.null(path)){
    x[ , 'taxa_trimmed'] <- stringr::str_replace_all(
      x[ , 'taxa_raw'],
      '_',
      ' '
    )
  } else {
    x <- stringr::str_replace_all(x, '_', ' ')
  }

# Trim white space --------------------------------------------------------


  if (!is.null(path)){
    x[ , 'taxa_trimmed'] <- stringr::str_trim(
      x[ , 'taxa_trimmed'],
      'both'
    )
  } else {
    x <- stringr::str_trim(x, 'both')
  }

# Remove common species abbreviations at the genus level ------------------

  if (!is.null(path)){
    x[ , 'taxa_trimmed'] <- stringr::str_remove(
      x[ , 'taxa_trimmed'],
      paste0(
        '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*)+$',
        '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$')
    )
  } else {
    x <- stringr::str_remove(
      x,
      paste0(
        '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
        '|[:space:]+(?i)[s|c]+([f|p]*)+$',
        '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$')
      )
  }

# Document provenance -----------------------------------------------------

  if (!is.null(path)){
    # Only list taxa names in taxa_trimmed that are different than taxa_raw
    use_i <- x[ , 'taxa_raw'] == x[ , 'taxa_trimmed']
    x[ , 'taxa_trimmed'][use_i] <- NA_character_

    # Write to file
    lib_path <- system.file('test_data.txt', package = 'taxonomyCleanr')
    lib_path <- substr(lib_path, 1, nchar(lib_path) - 14)
    if (!is.null(path)){
      if (path != lib_path){
        write_taxa_map(x = x, path = path)
      }
    }
  }

# Return output -----------------------------------------------------------

  x

}
