#' Get taxonomic authorities
#'
#' @description
#'     Use fuzzy searching in the Global Names Resolver to correct spelling
#'     and locate appropriate authorities.
#'
#' @usage
#'     get_authorities(path, preferred.data.sources)
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


get_authorities <- function(path, preferred.data.sources){


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

  # Resolve taxa to preferred authorities -----------------------------------

  for (i in 1:nrow(taxa_map)){

    # Get taxon from taxa_map.csv

    taxon <- taxa_map[i, 'taxa_raw']

    if (!is.na(taxa_map[i, 'taxa_trimmed'])){
      taxon <- taxa_map[i, 'taxa_trimmed']
    }
    if (!is.na(taxa_map[i, 'taxa_replacement'])){
      taxon <- taxa_map[i, 'taxa_replacement']
    }
    if (!is.na(taxa_map[i, 'taxa_removed'])){
      taxon <- 'unresolvable_taxa'
    }

    # Call Global Names Resolver (GNR)

    query <- suppressWarnings(
      gnr_resolve(
        paste0(
          taxon,
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

    query <- as.data.frame(query)

    # Update taxa_map.csv

    if (length(query) != 0){
      taxa_map[i, 'taxa_clean'] <- query[1, 'matched_name2']
      taxa_map[i, 'authority'] <- query[1, 'data_source_title']
      taxa_map[i, 'score'] <- query[1, 'score']
    }
  }

  # Document provenance -----------------------------------------------------

  # Write to file

  write_taxa_map(
    x = taxa_map,
    path = path
  )

# Return output -----------------------------------------------------------

  taxa_map

}
