#' Get taxonomic identifiers
#'
#' @description
#'     Get a taxonomic identifier from a taxon name and corresponding authority
#'     system listed in taxa_map.csv.
#'
#' @usage
#'     get_id(path)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with resolved taxa
#'         identification numbers.
#'         \item{2.} A data frame of taxa_map.csv with resolved taxa
#'         identification numbers.
#'     }
#'
#' @export
#'

get_id <- function(path){

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

  # Get ID and rank from taxon and authority -----------------------------------

  for (i in 1:nrow(taxa_map)){

    # Get taxon

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

    # Get authority and query for ID and rank

    # Catalogue of Life
    if (taxa_map[i, 'authority'] == 'Catalogue of Life'){
      response <- get_ids_(
        taxon,
        'col'
        )
      if (nrow(response[[1]][[1]]) > 0){
        response <- as.data.frame(response$col)
        response <- response[complete.cases(response), ]
        use_i <- response[ , 2] == taxon
        response <- response[use_i, ]
        if (nrow(response) > 0){
          taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
          taxa_map[i, 'rank'] <- response[1, 3]
        }
      }
    }

    # ITIS
    if (taxa_map[i, 'authority'] == 'ITIS'){
      response <- get_ids_(
        taxon,
        'itis'
      )
      if (nrow(response[[1]][[1]]) > 0){
        response <- as.data.frame(response[[1]][[1]])
        response <- response[complete.cases(response), ]
        use_i <- response[ , 2] == taxon
        response <- response[use_i, ]
        if (nrow(response) > 0){
          taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
          taxa_map[i, 'rank'] <- itis_taxrank(as.numeric(taxa_map[i, 'authority_id']))
        }
      }
    }

    # World Register of Marine Species
    if (taxa_map[i, 'authority'] == 'World Register of Marine Species'){
      response <- get_wormsid_(
        taxon,
        searchtype = 'scientific',
        accepted = F,
        ask = F,
        messages = F
      )
      if (!is.null(response[[1]])){
        response <- as.data.frame(response[[1]])
        response <- response[complete.cases(response), ]
        use_i <- response[ , 2] == taxon
        response <- response[use_i, ]
        if (nrow(response) > 0){
          taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
          response <- classification(as.character(response[1, 1]), db = 'worms')
          response <- as.data.frame(response[[1]])
          taxa_map[i, 'rank'] <- response[nrow(response), 2]
        }
      }
    }

    # GBIF Backbone Taxonomy
    if (taxa_map[i, 'authority'] == 'GBIF Backbone Taxonomy'){
      response <- get_ids_(
        taxon,
        'gbif'
      )
      if (nrow(response[[1]][[1]]) > 0){
        response <- as.data.frame(response[[1]][[1]])
        response <- response[complete.cases(response), ]
        use_i <- response[ , 2] == taxon
        response <- response[use_i, ]
        if (nrow(response) > 0){
          taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
          taxa_map[i, 'rank'] <- response[1, 3]
        }
      }
    }

    # Tropicos - Missouri Botanical Garden
    if (taxa_map[i, 'authority'] == 'Tropicos - Missouri Botanical Garden'){
      response <- get_ids_(
        taxon,
        'tropicos'
      )
      if (nrow(response[[1]][[1]]) > 0){
        response <- as.data.frame(response[[1]][[1]])
        use_i <- response[ , 2] == taxon
        response <- response[use_i, ]
        if (nrow(response) > 0){
          taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
          response <- tax_rank(taxa_map[i, 'authority_id'], db = 'tropicos')
          taxa_map[i, 'rank'] <- response[[1]]
        }
      }
    }



  }

}
