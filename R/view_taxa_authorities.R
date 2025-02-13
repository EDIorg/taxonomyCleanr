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
#'     (data frame) Taxonomic authorities and corresponding identifiers
#'     supported by `resolve_taxa` and `resolve_common`.
#'
#' @export
#'


view_taxa_authorities <- function(){

  # Get gna datasources -----------------------------------------------------

  gna_list <- load_gna_data_sources()

  # Mark supported databases ------------------------------------------------

  gna_list$return_to_user <- NA
  gna_list$resolve_taxa <- NA
  gna_list$resolve_common <- NA

  use_i <- gna_list[ , 'title'] == 'ITIS'
  gna_list[use_i, 'return_to_user'] <- 'Integrated Taxonomic Information System (ITIS)'
  gna_list[use_i, 'resolve_taxa'] <- 'supported'
  gna_list[use_i, 'resolve_common'] <- 'supported'

  use_i <- gna_list[ , 'title'] == 'EOL'
  gna_list[use_i, 'return_to_user'] <- 'Encyclopedia of Life (EOL)'
  gna_list[use_i, 'resolve_taxa'] <- 'not supported'
  gna_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gna_list[ , 'title'] == 'Tropicos - Missouri Botanical Garden'
  gna_list[use_i, 'return_to_user'] <- 'Tropicos - Missouri Botanical Garden'
  gna_list[use_i, 'resolve_taxa'] <- 'supported'
  gna_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gna_list[ , 'title'] == 'Global Biodiversity Information Facility Backbone Taxonomy'
  gna_list[use_i, 'return_to_user'] <- 'Global Biodiversity Information Facility (GBIF)'
  gna_list[use_i, 'resolve_taxa'] <- 'supported'
  gna_list[use_i, 'resolve_common'] <- 'not supported'

  # use_i <- gna_list[ , 'title'] == 'Catalogue of Life'
  # gna_list[use_i, 'return_to_user'] <- 'Catalogue of Life (COL)'
  # gna_list[use_i, 'resolve_taxa'] <- 'supported'
  # gna_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gna_list[ , 'title'] == 'World Register of Marine Species'
  gna_list[use_i, 'return_to_user'] <- 'World Register of Marine Species (WORMS)'
  gna_list[use_i, 'resolve_taxa'] <- 'supported'
  gna_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- !is.na(gna_list$return_to_user)
  taxonomic_authorities <- gna_list[use_i, c('id', 'return_to_user', 'resolve_taxa', 'resolve_common')]
  colnames(taxonomic_authorities) <- c('id', 'authority', 'resolve_sci_taxa', 'resolve_comm_taxa')
  rownames(taxonomic_authorities) <- c()

  # Return

  taxonomic_authorities

}








#' Load and fix gna Datasources
#'
#' @return (data.frame) gna datasources from \code{taxize::gna_data_sources()}
#'
#' @details This fixes bugs in taxize which otherwise produce inconsistent datasource names (e.g. "Integrated Taxonomic Information SystemITIS" rather than expected "ITIS")
#'
#' @keywords internal
#'
load_gna_data_sources <- function() {
  gna_list <- as.data.frame(taxize::gna_data_sources())
  gna_list$title[gna_list$id == "3"] <- "ITIS"
  return(gna_list)
}
