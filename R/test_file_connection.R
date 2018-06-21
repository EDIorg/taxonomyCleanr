#' Test file connection
#'
#' @description
#'     Test if file is open by another application.
#'
#' @usage
#'     test_file_con(path, file.name)
#'
#' @param path
#'     A character string specifying the path of a file.
#' @param file.name
#'     A character string specifying file name.
#'
#' @return
#'     An error message if the target file is open by another application.
#'
#' @export
#'


test_file_connection <- function(path, file.name){

  # Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  validate_path(path)
  if (missing(file.name)){
    stop('Input argument "file.path" is missing!')
  }
  fname <- validate_file_names(
    path = path,
    data.files = file.name
  )

  # Error if file is open ---------------------------------------------------

  use_i <- suppressWarnings(
    "try-error" %in% class(
      try(file(paste0(path, '/', fname),
               open = "w"),
          silent = TRUE
      )
    )
  )

  if (isTRUE(use_i)){
    stop(
      paste0(
        path,
        '/',
        fname,
        '\n is in use by another program. Please close it and try again.'
      )
    )
  }

}
