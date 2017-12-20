#' Update data
#'
#' @description
#'     Update the taxonomic information in your data table based on the
#'     mapping containted in \emph{taxon_map.csv} created by the \code{resolve_names}
#'     function.
#'
#' @usage
#'     update_data(path = "", data.file = "", taxon.col = "")
#'
#' @param path
#'     A path of the directory containing the data table containing taxonomic
#'     information and the file \emph{taxon_map.csv} for this dataset.
#' @param data.file
#'     Name of the data table containing taxonomic data.
#' @param taxon.col
#'     Name of the column containing the taxonomic names including species
#'     binomials and common names.
#'
#' @return
#'     A copy of your data table containing revised taxonomic data (for those
#'     taxa that could be resolved, non-resolved taxa are not updated). The
#'     copy of your data is appended with the current date-time stamp. This
#'     copy is made in the directory specified by path.
#'
#'     A comma delimited file \emph{taxon.csv} appended with the current
#'     date-time stamp. This date-time stamp links the revised table and
#'     \emph{taxon.csv} together. \emph{taxon.csv} is used by
#'     \code{make_taxonomicCoverage} to create the taxonomicCoverage EML tree
#'     for your taxa.
#'
#' @export
#'

update_data <- function(path, data.file, taxon.col){

  # Check arguments and parameterize ------------------------------------------

  message('Checking arguments.')

  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to your dataset working directory.')
  }
  if (missing(data.file)){
    stop('Input argument "data.file" is missing! Specify the name of your data file containing taxonomic data.')
  }
  if (missing(taxon.col)){
    stop('Input argument "taxon.col" is missing! Specify the column of your data table containing taxon names.')
  }

  # Validate path

  validate_path(path)

  # Validate data.files

  data_file <- validate_file_names(path, data.file)

  # Validate taxon.col

  # (Add taxon.col validation here)

  # Validate method

  # (Add method validation here)

  # Detect operating system

  os <- detect_os()

  # Detect field delimiter

  sep <- detect_delimeter(path, data.files = data_file, os)

  # Get file_extension

  file_extension <- substr(data_file, nchar(data_file)-3, nchar(data_file))

  # Validate taxon.col

  message(paste0("Reading ", data_file, "."))

  data_path <- paste(path,
                     "/",
                     data_file,
                     sep = "")

  data_L0 <- suppressWarnings(read.table(data_path,
                                         header = TRUE,
                                         sep = sep,
                                         quote = "\"",
                                         as.is = TRUE,
                                         fill = T,
                                         comment.char = ""))

  columns <- colnames(data_L0)
  columns_in <- taxon.col
  use_i <- str_detect(string = columns,
                      pattern = str_c("^", columns_in, "$", collapse = "|"))
  if (sum(use_i) == 0){
    stop(paste0('Invalid "taxon.col" entered: ', columns_in, ' Please fix this.'))
  }

  # Read in data file -----------------------------------------------------------

  message(paste("Reading", data_file))

  data_L0 <- read.table(paste(path, "/", data_file, sep = ""),
                        header = T,
                        sep = sep,
                        as.is = T,
                        na.strings = "NA")

  if (!file.exists(paste(path, "/", "taxon_map.csv", sep = ""))){
    stop("taxon_map.csv doen't exist. It is required for this function to opperate.")
  }

  message("Reading in taxon_map.csv")

  taxon_map <- read.table(paste(path, "/", "taxon_map.csv", sep = ""),
                          header = T,
                          sep = ",",
                          as.is = T,
                          na.strings = "NA")

  # Add columns and write to file ---------------------------------------------

  message(paste0("Revising taxa listed in ", '\"', taxon.col, '\" column.'))

  message("Adding new columns: taxon_rank, authority_system, authority_taxon_id")

  new_df <- data.frame(taxon_name = character(nrow(data_L0)),
                       taxon_rank = character(nrow(data_L0)),
                       taxon_authority_system = character(nrow(data_L0)),
                       taxon_authority_taxon_id = character(nrow(data_L0)),
                       stringsAsFactors = F)

  taxon_L0 <- data_L0[[taxon.col]]

  for (i in 1:nrow(taxon_map)){
    use_i <- taxon_map$user_supplied_name[i] == taxon_L0
    new_df[use_i, ] <- taxon_map[i, c("matched_name", "taxon_rank", "data_source_title", "authority_taxon_id")]
  }
  use_i <- new_df$taxon_rank == ""
  new_df[use_i, ] <- NA_character_

  # Add resolvable taxon to taxon.col, else leave original contents

  data_L0[!use_i, taxon.col] <- new_df$taxon_name[!use_i]

  # Append new_df without the taxon_name column

  data_out <- cbind(data_L0, new_df[ ,c("taxon_rank", "taxon_authority_system", "taxon_authority_taxon_id")])

  # Write to file

  new_file_name <- paste(substr(data_file, 1, nchar(data_file)-4),
                         "_",
                         str_replace(Sys.time(), " ", "_"),
                         file_extension,
                         sep = "")

  new_file_name <- str_replace(new_file_name, ":", "")
  new_file_name <- str_replace(new_file_name, ":", "")

  message(paste0('Writing ', new_file_name))

  write.table(data_out,
              file = paste(path,
                           "/",
                           new_file_name,
                           sep = ""),
              col.names = T,
              row.names = F,
              sep = sep,
              quote = F)



  # Create table for EML taxonomicCoverage element ----------------------------

  use_i <- is.na(taxon_map$authority_taxon_id)

  taxon_table <- data.frame(taxon_id = seq(dim(taxon_map)[1]),
                            taxon_rank = taxon_map$taxon_rank,
                            taxon_name = taxon_map$matched_name,
                            authority_system = taxon_map$data_source_title,
                            authority_taxon_id = taxon_map$authority_taxon_id,
                            stringsAsFactors = F)

  new_file_name <- paste("taxon",
                         "_",
                         str_replace(Sys.time(), " ", "_"),
                         file_extension,
                         sep = "")

  new_file_name <- str_replace(new_file_name, ":", "")
  new_file_name <- str_replace(new_file_name, ":", "")

  message(paste0('Writing ', new_file_name))

  write.table(taxon_table,
              file = paste(path,
                           "/",
                           new_file_name,
                           sep = ""),
              col.names = T,
              row.names = F,
              sep = "\t",
              eol = "\r\n",
              quote = F)

}

