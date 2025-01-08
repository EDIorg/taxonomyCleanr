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

  # Get GNR datasources -----------------------------------------------------

  gnr_list <- load_gnr_datasources()

  # Mark supported databases ------------------------------------------------

  gnr_list$return_to_user <- NA
  gnr_list$resolve_taxa <- NA
  gnr_list$resolve_common <- NA

  use_i <- gnr_list[ , 'title'] == 'ITIS'
  gnr_list[use_i, 'return_to_user'] <- 'Integrated Taxonomic Information System (ITIS)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'supported'

  use_i <- gnr_list[ , 'title'] == 'EOL'
  gnr_list[use_i, 'return_to_user'] <- 'Encyclopedia of Life (EOL)'
  gnr_list[use_i, 'resolve_taxa'] <- 'not supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gnr_list[ , 'title'] == 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'return_to_user'] <- 'Tropicos - Missouri Botanical Garden'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gnr_list[ , 'title'] == 'GBIF Backbone Taxonomy'
  gnr_list[use_i, 'return_to_user'] <- 'Global Biodiversity Information Facility (GBIF)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  # use_i <- gnr_list[ , 'title'] == 'Catalogue of Life'
  # gnr_list[use_i, 'return_to_user'] <- 'Catalogue of Life (COL)'
  # gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  # gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- gnr_list[ , 'title'] == 'World Register of Marine Species'
  gnr_list[use_i, 'return_to_user'] <- 'World Register of Marine Species (WORMS)'
  gnr_list[use_i, 'resolve_taxa'] <- 'supported'
  gnr_list[use_i, 'resolve_common'] <- 'not supported'

  use_i <- !is.na(gnr_list$return_to_user)
  taxonomic_authorities <- gnr_list[use_i, c('id', 'return_to_user', 'resolve_taxa', 'resolve_common')]
  colnames(taxonomic_authorities) <- c('id', 'authority', 'resolve_sci_taxa', 'resolve_comm_taxa')
  rownames(taxonomic_authorities) <- c()

  # Return

  taxonomic_authorities

}








#' Load and fix GNR Datasources
#'
#' @return (data.frame) GNR datasources from \code{taxize::gnr_datasources()}. # TODO: Remove reference to taxize
#'
#' @details This fixes bugs in taxize which otherwise produce inconsistent datasource names (e.g. "Integrated Taxonomic Information SystemITIS" rather than expected "ITIS").  # TODO: Modify language
#'
#' @keywords internal
#'
load_gnr_datasources <- function() {
  gnr_list <- as.data.frame(taxize::gnr_datasources())  # TODO: Read in these data from a snapshot stored in /data-raw
  gnr_list$title[gnr_list$id == "3"] <- "ITIS"
  return(gnr_list)
}
