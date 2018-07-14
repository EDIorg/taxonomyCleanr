#' View unique taxa and counts
#'
#' @description
#'     View unique occurences and counts of taxa to help identify misspelled
#'     taxon.
#'
#' @usage
#'     view_unique(x, col, path)
#'
#' @param x
#'     A data frame of your data containing the vector of taxa names to be
#'     cleaned.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be cleaned.
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is used by
#'     this function.
#'
#' @return
#'     A data frame with taxa and associated counts found in the input, sorted
#'     alphabetically by taxa.
#'
#' @export
#'

view_unique <- function(x, col, path){

# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'data.frame'){
    stop('Input argument "x" must be a data frame!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }

  if (!missing(path)){
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
  }

# Read taxa_map.csv -------------------------------------------------------

  taxa_map <- read.table(
    paste0(
      path,
      '/taxa_map.csv'
    ),
    header = T,
    sep = ',',
    stringsAsFactors = F
  )

  # Update x with taxa_trimmed ----------------------------------------------

  use_i <- !is.na(taxa_map[ , 'taxa_trimmed'])

  values_raw <- taxa_map[ , 'taxa_raw'][use_i]


  values_new <- taxa_map[ , 'taxa_trimmed'][use_i]

  if (sum(use_i) > 0){
    for (i in 1:length(values_raw)){
      use_i2 <- values_raw[i] == x[ , col]
      use_i2[is.na(use_i2)] <- FALSE
      x[use_i2, col] <- values_new[i]
    }
  }

  # Update x with taxa_replacement ------------------------------------------

  use_i <- !is.na(taxa_map[ , 'taxa_replacement'])

  values_raw <- taxa_map[use_i, 'taxa_raw']

  values_new <- taxa_map[use_i, 'taxa_replacement']

  if (sum(use_i) > 0){
    for (i in 1:length(values_raw)){
      use_i2 <- values_raw[i] == x[ , col]
      use_i2[is.na(use_i2)] <- FALSE
      x[use_i2, col] <- values_new[i]
    }
  }

  # Update x with taxa_removed ------------------------------------------

  use_i <- !is.na(taxa_map[ , 'taxa_removed'])

  values_raw <- taxa_map[use_i, 'taxa_raw']

  if (sum(is.na(values_raw)) > 0){
    x[is.na(x[ , col]), col] <- 'NA'
    values_raw[is.na(values_raw)] <- 'NA'
  } #else {
  #   x[is.na(x[ , col]), col] <- 'NA'
  # }

  if (sum(use_i) > 0){
    for (i in 1:length(values_raw)){
      use_i2 <- values_raw[i] == x[ , col]
      use_i2[is.na(use_i2)] <- FALSE
      x <- x[!use_i2, ]
    }
  }

  # Replace NA with 'NA' to make visible --------------------------------------

  x[is.na(x[ , col]), col] <- 'NA'

# Count unique taxa and view ----------------------------------------------

  unique_taxa <- table(x[ , col])

  View(unique_taxa)

# Return output -----------------------------------------------------------

  unique_taxa

}
