#' View authorities
#'
#' @description
#'     List taxonomic authorities supported by the `taxonomyCleanr`.
#'
#' @usage
#'     view_authorities()
#'
#' @details
#'     This is a wrapper function to `taxize::gnr_datasources`.
#'
#' @return
#'     A data frame and view of taxonomic authorities and corresponding
#'     identifiers supported by `get_authorities`.
#'
#' @export
#'


view_authorities <- function(){

  # Get GNR datasources -----------------------------------------------------

  gnr_list <- gnr_datasources()

  # Mark supported databases ------------------------------------------------

  gnr_list$supported <- NA

  use_i <- gnr_list[ , 'title'] == 'ITIS'
  gnr_list[use_i, 'supported'] <- 'itis'
  gnr_list[use_i, 'title'] <- 'Integrated Taxonomic Information System (ITIS)'

  use_i <- gnr_list[ , 'title'] == 'NCBI'
  gnr_list[use_i, 'supported'] <- 'ncbi'

  use_i <- gnr_list[ , 'title'] == 'EOL'
  gnr_list[use_i, 'supported'] <- 'eol'
  gnr_list[use_i, 'title'] <- 'Encyclopedia of Life (EOL)'

  use_i <- gnr_list[ , 'title'] == 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'supported'] <- 'tropicos'

  use_i <- gnr_list[ , 'title'] == 'GBIF Backbone Taxonomy'
  gnr_list[use_i, 'supported'] <- 'gbif'
  gnr_list[use_i, 'title'] <- 'Global Biodiversity Information Facility'

  use_i <- gnr_list[ , 'title'] == 'Catalogue of Life'
  gnr_list[use_i, 'supported'] <- 'get_colid'

  use_i <- gnr_list[ , 'title'] == 'IUCN Red List of Threatened Species'
  gnr_list[use_i, 'supported'] <- 'get_iucn'

  use_i <- gnr_list[ , 'title'] == 'Open Tree of Life Reference Taxonomy'
  gnr_list[use_i, 'supported'] <- 'get_tolid'

  use_i <- gnr_list[ , 'title'] == 'World Register of Marine Species'
  gnr_list[use_i, 'supported'] <- 'get_wormsid'
  gnr_list[use_i, 'title'] <- 'World Register of Marine Species (WORMS)'

  View(gnr_list[complete.cases(gnr_list), c('id', 'title')])





}
