#' Get taxa classification hierarchy
#'
#' @description
#'     Get the classification hierarchy of taxa.
#'
#' @usage
#'     get_classification(taxa.clean, authority, authority.id, path = NULL)
#'
#' @taxa.clean
#'     (character) Name of taxa resolved to an authority.
#' @param authority
#'     (character) Vector of authorities corresponding to taxonomic IDs listed
#'     in the "authority.id" argument below. Get data.sources and IDs with
#'     `resolve_sci_taxa`.
#' @param authority.id
#'     (character) Vector taxonomic IDs corresponding to an authority.
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function. Create this file with `create_taxa_map`.
#'
#' @return
#'     (list) A list taxa with corresponding hierarchical names and ranks.
#'
#' @export
#'

get_classification <- function(taxa.clean, authority, authority.id, path = NULL){

  cw <- data.frame(human.readable = c('Catalogue of Life', 'ITIS',
                                      'World Register of Marine Species',
                                      'GBIF Backbone Taxonomy',
                                      'Tropicos - Missouri Botanical Garden'),
                   machine.readable = c('col', 'itis', 'worms', 'gbif',
                                        'tropicos'),
                   stringsAsFactors = F)

  if (is.null(path)){
    use_i <- match(authority, cw$human.readable)
    output <- suppressMessages(mapply(taxize::classification,
                                      x = authority.id[use_i],
                                      db = cw$machine.readable[use_i]))
    names(output) <- taxa.clean[use_i]
    output <- lapply(output, as.data.frame)
    output
  }

}
