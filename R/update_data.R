#' Update data
#'
#' @description
#'     Update the taxonomic information in your data table based on the
#'     mapping containted in \emph{taxa_map.csv}.
#'     function.
#'
#' @usage
#'     update_data(path = "", data.file = "", col = "")
#'
#' @param path
#'     A path of the directory containing taxa_map.csv and the raw data table.
#' @param x
#'     A data frame containing the vector of taxa names to be updated.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be updated.
#' @retain.raw
#'     TRUE or FALSE, indicating whether the raw taxa column should be included
#'     in the output.
#' @sep
#'     The column delimiter to use when writting the table to file. Can be ","
#'     or "\t".
#'
#' @return
#'     A copy of your data table containing appended columns containing:
#'     \itemize{
#'         \item{resolved_taxa} Resolved taxa names.
#'         \item{rank} Taxonomic rank.
#'         \item{authority} Authority system the resolved names correspond with.
#'         \item{authority_id} Taxonomic IDs of the authority system.
#'
#'     }
#'
#' @export
#'

update_data <- function(path, x, col, retain.raw, sep){

  # Check arguments and parameterize ------------------------------------------

  message('Checking arguments.')

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }
  if (missing(retain.raw)){
    stop('Input argument "retain.raw" is missing!')
  }
  if (missing(sep)){
    stop('Input argument "sep" is missing!')
  }

  # Validate path

  validate_path(path)

  # Validate taxon.col

  columns <- colnames(data_L0)
  columns_in <- taxon.col
  use_i <- str_detect(string = columns,
                      pattern = str_c("^", columns_in, "$", collapse = "|"))
  if (sum(use_i) == 0){
    stop(paste0('Invalid "taxon.col" entered: ', columns_in, ' Please fix this.'))
  }

  # Validate retain.raw

  # Validate sep
  # (Add sep validation here)

  # Read taxa_map.csv -------------------------------------------------------

  taxa_map <- suppressMessages(
    as.data.frame(
      read_csv(
        paste0(
          path,
          '/taxa_map.csv'
        )
      )
    )
  )


  # Update data table -------------------------------------------------------

  if (retain.raw == T){

    # Add columns

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


  } else if (retain.raw == F){

    # Update raw taxa

    # Add columns

  }

  # Write to file -----------------------------------------------------------

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


}

