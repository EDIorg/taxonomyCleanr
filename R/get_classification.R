#' Get taxa classification
#'
#' @description
#'     Get the classification hierarchy of a taxa
#'
#' @usage
#'     get_classification(x, col = NULL, path = NULL)
#'
#' @param authority
#'     (character) Vector of authorities corresponding to taxonomic IDs listed
#'     in the "authority.id" argument below. Get data.sources and IDs with
#'     `resolve_sci_taxa`.
#' @param authority.id
#'     (character) Vector taxonomic IDs corresponding to an authority.
#'
#' @return
#'     (list) A list of hierarchical ranks for each taxa represented by an
#'     authority.id
#'
#' @export
#'

get_classification <- function(authority, authority.id){

  # Validate arguments --------------------------------------------------------

  # resolve_sci_taxa ----------------------------------------------------------

  mapply(taxize::classification, x = authority.id, db = authority)

  #

}
