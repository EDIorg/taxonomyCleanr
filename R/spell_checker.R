#' Check taxa spelling
#'
#' @description
#'     Check taxa spelling against the Global Names Index (GNI) and get GNI of
#'     corresponding output.
#'
#' @usage
#'     spell_checker(x, pattern)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#' @param preferred.data.sources
#'     An ordered numeric vector of ID's corresponding to data sources (i.e.
#'     taxonomic authorities) you'd like to query, in the order of decreasing
#'     preference. Run `gnr_datasources()` to get valid data source options
#'     and ID's.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with resolved taxa
#'         names.
#'         \item{2.} A data frame of taxa_map.csv with resolved taxa names.
#'     }
#'
#' @export
#'


spell_checker <- function(path, preferred.data.sources){


  # Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(preferred.data.sources)){
    stop('Input argument "preferred.data.sources" is missing!')
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

  taxa_map <- suppressMessages(
    as.data.frame(
      read_csv(
        paste0(
          path,
          '/taxa_map.csv'
        )
      )
    )
  )

  # Update taxa list from taxa_map --------------------------------------------

  # Trim taxa

  use_i <- !is.na(taxa_map[ , 'taxa_trimmed'])

  values_new <- taxa_map[ , 'taxa_trimmed'][use_i]

  taxa_map[use_i, 'taxa_raw'] <- values_new

  # Replace taxa

  use_i <- !is.na(taxa_map[ , 'taxa_replacement'])

  values_new <- taxa_map[ , 'taxa_replacement'][use_i]

  taxa_map[use_i, 'taxa_raw'] <- values_new

  # Remove taxa

  use_i <- !is.na(taxa_map[ , 'taxa_removed'])

  taxa_map <- taxa_map[!use_i, ]

  # List

  x <- taxa_map[ , 'taxa_raw']


  # Call Global Names Resolver (GNR) ----------------------------------------

  for (i in 1:length(x)){

    query <- suppressWarnings(
      gnr_resolve(
        paste0(
          x[i],
          '*'
          ),
        resolve_once = T,
        canonical = T,
        best_match_only = T,
        preferred_data_sources = as.character(
          preferred.data.sources
          )
        )
      )

    if (length(query) == 0){
      data_out[i, 'search_term'] <- x[i]
      data_out[i, 'result'] <- NA_character_
      data_out[i, 'difference'] <- NA_character_
      data_out[i, 'source'] <- NA_character_
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- NA_character_
    } else {
      data_out[i, 'search_term'] <- x[i]
      data_out[i, 'result'] <- query$matched_name2[1]
      if (x[i] == query$matched_name2[1]){
        data_out[i, 'difference'] <- 'no'
      } else {
        data_out[i, 'difference'] <- 'yes'
      }
      data_out[i, 'source'] <- query$data_source_title[1]
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- query$score[1]
    }
  }

# Return output -----------------------------------------------------------

  data_out

}
