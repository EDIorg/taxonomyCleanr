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

  gnr_list$return_to_user <- NA

  use_i <- gnr_list[ , 'title'] == 'ITIS'
  gnr_list[use_i, 'return_to_user'] <- 'Integrated Taxonomic Information System (ITIS)'

  # # Can not query via get_ids_.R. Key required.
  # use_i <- gnr_list[ , 'title'] == 'NCBI'
  # gnr_list[use_i, 'return_to_user'] <- 'National Center for Biotchnology Information (NCBI)'

  # # Difficulty securing accurate ranks
  # use_i <- gnr_list[ , 'title'] == 'EOL'
  # gnr_list[use_i, 'return_to_user'] <- 'Encyclopedia of Life (EOL)'

  use_i <- gnr_list[ , 'title'] == 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'return_to_user'] <- 'Tropicos - Missouri Botanical Garden'

  use_i <- gnr_list[ , 'title'] == 'GBIF Backbone Taxonomy'
  gnr_list[use_i, 'return_to_user'] <- 'Global Biodiversity Information Facility (GBIF)'

  use_i <- gnr_list[ , 'title'] == 'Catalogue of Life'
  gnr_list[use_i, 'return_to_user'] <- 'Catalogue of Life (COL)'

  # # Authentication required
  # use_i <- gnr_list[ , 'title'] == 'IUCN Red List of Threatened Species'
  # gnr_list[use_i, 'return_to_user'] <- 'International Union for Conservation of Nature and Natural Resources (IUCN) Red List of Threatened Species'

  # # No support for this resource
  # use_i <- gnr_list[ , 'title'] == 'Open Tree of Life Reference Taxonomy'
  # gnr_list[use_i, 'return_to_user'] <- 'Open Tree of Life Reference Taxonomy'

  use_i <- gnr_list[ , 'title'] == 'World Register of Marine Species'
  gnr_list[use_i, 'return_to_user'] <- 'World Register of Marine Species (WORMS)'

  taxonomic_authorities <- gnr_list[complete.cases(gnr_list), c('id', 'return_to_user')]
  View(taxonomic_authorities)

}
