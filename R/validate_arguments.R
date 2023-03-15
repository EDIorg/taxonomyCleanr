#' Validate arguments of taxonomyCleanr functions
#'
#' @description
#'     Validate input arguments to taxonomyCleanr functions.
#'
#' @param fun.name
#'     (character) Function name
#' @param fun.args
#'     (named list) Function arguments and values passed from the calling
#'     function.
#'
#'
#' @keywords internal
#'
validate_arguments <- function(fun.name, fun.args){

  # Parameterize --------------------------------------------------------------

  use_i <- sapply(fun.args, function(X) identical(X, quote(expr=)))
  fun.args[use_i] <- list(NULL)

  # Helper functions ----------------------------------------------------------

  # Return a warning if data.sources aren't available

  ping_data_sources <- function(data.sources) {

    worms_ping <- function (what = "status", ...) {
      r <- httr::GET("https://www.marinespecies.org/rest")
      httr::status_code(r) == 200
    }

    pingers <- data.frame(
      id = c(3, 9, 11, 165),
      fun = c("taxize::itis_ping()", "worms_ping()", "taxize::gbif_ping()", "taxize::tropicos_ping()"),
      name = c("ITIS", "WORMS", "GBIF", "TROPICOS"),
      stringsAsFactors = FALSE)

    use_i <- unlist(
      lapply(
        pingers$fun[match(data.sources, pingers$id)],
        function(x) {
          eval(parse(text = x))
        }))

    if (!all(use_i)) {
      warning(
        paste0(
          pingers$name[match(data.sources, pingers$id)][!use_i],
          " cannot be reached at this time. Please try again later."),
        call. = FALSE)
    }

  }

  # Called from resolve_sci_taxa() --------------------------------------------

  if (fun.name == 'resolve_sci_taxa') {

    if (!is.null(fun.args$x) & !is.null(fun.args$path)) {
      stop('Both "path" and "x" arguments are not allowed. Select one or the other.')
    }

    if (is.null(fun.args$x)) {
      if (is.null(fun.args$path)) {
        stop('Input argument "path" is missing!')
      }
      if (!file.exists(paste0(fun.args$path, '/taxa_map.csv'))) {
        stop('taxa_map.csv is missing! Create it with create_taxa_map().')
      }
    }

    if (is.null(fun.args$data.sources)) {
      stop('Input argument "data.sources" is missing!')
    }

    authorities <- view_taxa_authorities()
    authorities <- authorities[authorities$resolve_sci_taxa == 'supported', ]
    use_i <- as.character(fun.args$data.sources) %in% as.character(authorities$id)
    if (sum(use_i) != length(use_i)){
      stop('Input argument "data.sources" contains unsupported data source IDs!')
    }

    ping_data_sources(fun.args$data.sources)

  }

}

