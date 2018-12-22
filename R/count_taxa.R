#' Get counts of unique taxa
#'
#' @description
#'     View unique occurences and counts of taxa to help identify misspelled
#'     taxon.
#'
#' @usage
#'     count_taxa(x, col = NULL, path = NULL)
#'
#' @param x
#'     (data frame or character) A data frame or vector of taxa names to be
#'     cleaned.
#' @param col
#'     (character) A character string specifying the column in x containing
#'     taxa names to be cleaned. NOTE: Don't use this argument if x is of
#'     character class.
#' @param path
#'     (character) A character string specifying the path to taxa_map.csv.
#'     This table tracks relationships between your raw and cleaned data and
#'     is used by this function.
#'
#' @return
#'     (data frame) A data frame with taxa and associated counts found in the
#'     input, sorted alphabetically by taxa.
#'
#' @export
#'

count_taxa <- function(x, col = NULL, path = NULL){

  # Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  } else {
    if ((class(x) != 'data.frame') & (class(x) != 'character')){
      stop('Input argument "x" must be a data frame or of character class!')
    } else {
      if (class(x) == 'data.frame'){
        if (is.null(col)){
          stop('Input argument "col" is missing!')
        }
      }
    }
  }

  if (!is.null(path)){
    if (!isTRUE(file.exists(paste0(path, '/taxa_map.csv')))){
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }
  }



  # Read taxa_map.csv -----------------------------------------------------------

  if (!is.null(path)){
    taxa_map <- utils::read.table(
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

    unique_taxa <- as.data.frame(
      table(
        x[ , col]
      ),
      stringsAsFactors = F
    )

    rownames(unique_taxa) <- c()
    colnames(unique_taxa) <- c('Taxa', 'Count')

  } else {

    if (is.data.frame(x)){
      unique_taxa <- as.data.frame(
        table(x[, col]),
        stringsAsFactors = F
      )
    } else {
      unique_taxa <- as.data.frame(
        table(x),
        stringsAsFactors = F
      )
    }

    rownames(unique_taxa) <- c()
    colnames(unique_taxa) <- c('Taxa', 'Count')

  }

# Return output -----------------------------------------------------------

  unique_taxa

}
