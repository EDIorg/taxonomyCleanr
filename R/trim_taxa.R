#' Trim taxa
#'
#' @description
#'     Trim excess text from taxa names. Doing this before querying a taxonomic
#'     authority reduces the frequency of mismatches.
#'
#' @usage
#'     trim_raw_taxa_str(path)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
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


trim_taxa <- function(path){


# Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
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

  # Replace underscores with blank spaces -------------------------------------

  x[ , 'taxa_trimmed'] <- str_replace_all(
    x[ , 'taxa_raw'],
    '_',
    ' '
  )

# Trim white space --------------------------------------------------------

  x[ , 'taxa_trimmed'] <- str_trim(
    x[ , 'taxa_trimmed'],
    'both'
    )

# Remove common species abbreviations at the genus level ------------------

  x[ , 'taxa_trimmed'] <- str_remove(
    x[ , 'taxa_trimmed'],
    paste0(
      '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*)+$',
      '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$')
  )

# Document provenance -----------------------------------------------------

  # Only list taxa names in taxa_trimmed that are different than taxa_raw

  use_i <- x[ , 'taxa_raw'] == x[ , 'taxa_trimmed']
  x[ , 'taxa_trimmed'][use_i] <- NA_character_

  # Write to file

  write_taxa_map(
    x = x,
    path = path
    )

# Return output -----------------------------------------------------------

  x

}
