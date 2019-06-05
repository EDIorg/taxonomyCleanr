#' Revise taxonomic data
#'
#' @description
#'     Update the taxonomic information in your data table based on the
#'     mapping containted in \emph{taxa_map.csv}.
#'     function.
#'
#' @usage
#'     revise_taxa(path, x, col, sep)
#'
#' @param path
#'     A path of the directory containing taxa_map.csv and the raw data table.
#' @param x
#'     A data frame containing the vector of taxa names to be updated.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be updated.
#' @param sep
#'     The column delimiter to use when writting the table to file. Can be
#'     comma or tab.
#'
#' @return
#'     A copy of your data table (taxonomyCleanr_output) containing appended
#'     columns containing:
#'     \itemize{
#'         \item{taxa_clean} Both resolved and unresolved taxa.
#'         \item{taxa_rank} Taxonomic rank of resolved taxa, otherwise NA.
#'         \item{taxa_authority} Authority system of resolved taxa, otherwise
#'         NA.
#'         \item{taxa_authority_id} Resolved taxa identifiers from
#'         corresponding authority system.
#'     }
#'     Unresolvable taxa will have NA values for the appended columns.
#'
#' @export
#'

revise_taxa <- function(path, x, col, sep){

  # Check arguments -----------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }
  if (missing(sep)){
    stop('Input argument "sep" is missing!')
  }

  # Check for taxa_map.csv

  if (!isTRUE(file.exists(paste0(path, '/taxa_map.csv')))){
    stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
  }

  # Validate taxon.col

  columns <- colnames(x)
  columns_in <- col
  use_i <- stringr::str_detect(string = columns,
                      pattern = stringr::str_c("^", columns_in, "$", collapse = "|"))
  if (sum(use_i) == 0){
    stop(paste0('Invalid "col" entered: ', columns_in, ' Please fix this.'))
  }

  # Validate sep

  if ((sep != ',') & (sep != '\t')){
    stop('Invalid "sep" value entered. Must be "," or "\\t".')
  }

  # Coerce x to data frame

  x <- as.data.frame(x)

  # Read taxa_map.csv -------------------------------------------------------

  taxa_map <- suppressMessages(
    as.data.frame(
      readr::read_csv(
        paste0(
          path,
          '/taxa_map.csv'
        )
      )
    )
  )

  # Update data ---------------------------------------------------------------

  # Match taxa

  use_i <- match(x[ , col], taxa_map[ , 'taxa_raw'])

  new_df <- taxa_map[use_i, c('taxa_clean', 'rank', 'authority', 'authority_id')]

  use_i <- is.na(new_df[ , 'taxa_clean'])

  new_df[use_i, 'taxa_clean'] <- x[use_i, col]

  # Rename columns

  colnames(new_df) <- c(
    'taxa_clean',
    'taxa_rank',
    'taxa_authority',
    'taxa_authority_id'
  )

  # Append new_df to x

  data_out <- cbind(x, new_df)

  # Write to file -----------------------------------------------------------

  lib_path <- system.file('taxa_map.csv', package = 'taxonomyCleanr')
  lib_path <- substr(lib_path, 1, nchar(lib_path) - 13)
  if (!missing(path)){
    if (path != lib_path){
      if (sep == ','){
        new_file_name <- 'taxonomyCleanr_output.csv'
      } else if (sep == '\t'){
        new_file_name <- 'taxonomyCleanr_output.txt'
      }

      utils::write.table(
        x = data_out,
        file = paste0(
          path,
          "/",
          new_file_name
        ),
        col.names = T,
        row.names = F,
        sep = sep,
        quote = F
      )

    }
  }

  # Return --------------------------------------------------------------------

  data_out

}

