#' Common to scientific names
#'
#' @description
#'     Get common name for scientific name.
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
#'     preference. Run `view_authorities` to get valid data source options
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
