#' View taxonomic authorities
#'
#' @description
#'     List taxonomic authorities supported by the `taxonomyCleanr`.
#'
#' @usage
#'     view_taxa_authorities()
#'
#' @details
#'     View taxonomic authorities supported by `resolve_taxa` and
#'     `resolve_common`.
#'
#' @return
#'     A data frame and view of taxonomic authorities and corresponding
#'     identifiers supported by `resolve_taxa` and `resolve_common`.
#'
#' @export
#'


view_taxa_authorities <- function(){

  # Get GNR datasources -----------------------------------------------------

  gnr_list <- taxize::gnr_datasources()

  # Mark supported databases ------------------------------------------------

  gnr_list$return_to_user <- NA
  gnr_list$resolve_taxa <- NA
  gnr_list$resolve_common <- NA

  use_i <- gnr_list[ , 'title'] == 'ITIS'
  gnr_list[use_i, 'return_to_user'] <- 'Integrated Taxonomic Information System (ITIS)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'supported'

  # # Can not query via get_ids_.R. Key required.
  # use_i <- gnr_list[ , 'title'] == 'NCBI'
  # gnr_list[use_i, 'return_to_user'] <- 'National Center for Biotchnology Information (NCBI)'

  # Difficulty securing accurate ranks
  use_i <- gnr_list[ , 'title'] == 'EOL'
  gnr_list[use_i, 'return_to_user'] <- 'Encyclopedia of Life (EOL)'
  gnr_list[use_i, 'resolve_taxa'] <- 'not supported'
  gnr_list[use_i, 'resolve_common'] <- 'supported'

  use_i <- gnr_list[ , 'title'] == 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'return_to_user'] <- 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gnr_list[ , 'title'] == 'GBIF Backbone Taxonomy'
  gnr_list[use_i, 'return_to_user'] <- 'Global Biodiversity Information Facility (GBIF)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gnr_list[ , 'title'] == 'Catalogue of Life'
  gnr_list[use_i, 'return_to_user'] <- 'Catalogue of Life (COL)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  # # Authentication required
  # use_i <- gnr_list[ , 'title'] == 'IUCN Red List of Threatened Species'
  # gnr_list[use_i, 'return_to_user'] <- 'International Union for Conservation of Nature and Natural Resources (IUCN) Red List of Threatened Species'

  # # No support for this resource
  # use_i <- gnr_list[ , 'title'] == 'Open Tree of Life Reference Taxonomy'
  # gnr_list[use_i, 'return_to_user'] <- 'Open Tree of Life Reference Taxonomy'

  use_i <- gnr_list[ , 'title'] == 'World Register of Marine Species'
  gnr_list[use_i, 'return_to_user'] <- 'World Register of Marine Species (WORMS)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  taxonomic_authorities <- gnr_list[complete.cases(gnr_list), c('id', 'return_to_user', 'resolve_taxa', 'resolve_common')]
  colnames(taxonomic_authorities) <- c('id', 'authority', 'resolve_sci_taxa', 'resolve_comm_taxa')
  rownames(taxonomic_authorities) <- c()

  View(taxonomic_authorities)

  taxonomic_authorities

}
