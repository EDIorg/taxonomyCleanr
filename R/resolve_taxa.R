#' Resolve taxa
#'
#' @description
#'     Resolve input taxonomoic names against an authority and output a table
#'     that maps your raw taxon data to the resolved names. This map is later
#'     used by \code{update_data} to revise the taxon listed in your data.
#'
#' @usage
#'     resolve_names(path = "", data.file = "", taxon.col = "", mode = "")
#'
#' @param path
#'     A path of the directory containing the data table containing taxonomic
#'     information.
#' @param data.file
#'     Name of the input data table containing taxonomic data.
#' @param taxon.col
#'     Name of the column containing the taxonomic names including species
#'     binomials, rank specific names, and or common names.
#' @param method
#'     Method for resolving your taxonomic data against an authority. There
#'     are 2 options:
#'     \itemize{
#'         \item{manual} Use this option if you are not in a position to pass
#'         judgement on the taxonomic data. This is a good option if you are
#'         a data manager helping a data provider clean their taxonomy data.
#'         However, this may be good option for you if you can pass judgement
#'         on the taxonomic data (see notes on the interactive method below).
#'         The output of manual mode is the taxon_choices.txt file which is a
#'         tab delimited table containing the unique taxa of the raw data
#'         with corresponding options to select from. After someone has
#'         passed through this table selected the correct matches, this file
#'         is converted to taxon_map.txt with the `choices2map` function.
#'         taxon_map.txt contains the relationships between your raw taxa data
#'         and your resolved taxa data.
#'         \item{interactive} Use this option if you are in a position to pass
#'         judgement on the correct identification of the taxa contained in
#'         the dataset you are cleaning. When `resolve_taxa` encounters
#'         ambiguity with a taxon you will be prompted to select the correct
#'         taxon from a list. Your selections made during this interactive
#'         session with the RStudio Console window will be recorded to the
#'         taxon_map.txt file containing the relationships between your raw
#'         taxa data and your resolved taxa data. This option has a few issues
#'         you should be aware of:
#'         \itemize{
#'             \item{1.} You can not stop and save your work part way through
#'             the name resolution process and resume at a later time. You will
#'             have to start over from the beginning, which may be cumbersome
#'             for large taxa lists.
#'             \item{2.} If you want to revisit the options for a single taxon,
#'             you will have to revisit and pass judgement on all the other
#'             taxon that don't have issues.
#'             \item{3.} There is no way to reverse a decision made during the
#'             interactive mode. Once you select a taxon and press enter, there
#'             is no way to change your input.
#'         }
#'         \item{automatic} Use this option if you are not in a position to pass
#'         judgement on the taxonomic data, and don't have a data provider to
#'         select any options that may arise if there are multiple options for
#'         a taxon. This option resolves the fewest number of input taxa to an
#'         authority but is sometimes the best option.
#'     }
#'
#' @return
#'     A tab delimited file in the dataset working directory titled
#'     \emph{taxon_map.txt} containing the relationships between your input
#'     taxon data and the resolved names. This file is used by
#'     \code{update_data} to update the taxonomic data of your data table.
#'
#' @export
#'


resolve_taxa <- function(path, data.file, taxon.col, method){

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
  if (missing(method)){
    stop('Input argument "method" is missing! Specify the method for resolving your taxonomic names.')
  }

  # Validate path

  validate_path(path)

  # Validate data.files

  data_file <- validate_file_names(path, data.file)

  # Validate method

  method.low <- tolower(method)

  if (!str_detect(method.low, "^automatic$|^interactive$|^manual$")){
    stop('Invalid value entered for the "method" argument. Please choose "automatic", "interactive", or "manual".')
  }

  # Detect operating system

  os <- detect_os()

  # Detect field delimiter

  sep <- detect_delimeter(path, data.files = data_file, os)

  # Validate number of fields

  validate_fields(path, data.files = data_file)

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

  # Create taxon list from data.file ------------------------------------------

  message("Creating taxon list.")

  data_L0 <- unique(data_L0[[taxon.col]])

  # Resolve taxonomic names to authority --------------------------------------


  if (method == "automatic"){

    message('Resolving taxon names using the "automatic" method.')

    # Select authority and retrieve options

    # (out <- gnr_datasources())
    # message("Refer to the list of authorities to resolve taxonomic names against.")
    # answer <- readline("Enter the row number of the one you'd like to use: ")
    # ds <- as.integer(answer)
    ds <- as.integer("3") # Restrict to ITIS (for now)
    # print(paste("You selected ...", out$title[as.integer(answer)]))

    # Send to Global Names Resolver
    # Not all names may resolve because of colloquial terms and non-species terms

    message('Resolving scientific names.')

    gnr_out <- gnr_resolve(names = data_L0,
                           data_source_ids = ds,
                           resolve_once = F,
                           with_context = F,
                           canonical = T,
                           best_match_only = T)

    if (dim(gnr_out)[1] != 0){
      data_out <- subset(gnr_out,
                         select = c(user_supplied_name,
                                    matched_name2,
                                    data_source_title))

      colnames(data_out)[2] <- "matched_name"

      data_out$do_not_use <- character(dim(data_out)[1])

      # Attempt to resolve common names ---------------------------------------------
      # Identify remaining names and send through common2science name resolver.
      # Print to file for spread sheet selection (manual).

      # message('Resolving common names.')

      data_sources <- data.frame(id = seq(2),
                                 title = c("itis", "worms"),
                                 stringsAsFactors = F)
      # print("Reference the list of sources above to resolve common names against.")
      # answer <- readline("Enter the row number of the source to query: ")
      # ds <- as.integer(answer)
      ds <- as.integer("1") # default to ITIS (for now)

      all_resolved_names <- rbind(data_out)

      # Add authority_taxon_id to all_resolved_names (only supported for ITIS right now)
      # get_tsn only works for ITIS. Could add other db options.

      message('Identifying taxonomic serial numbers.')

      all_resolved_names$authority_taxon_id <- character(nrow(all_resolved_names))

      for (i in 1:length(all_resolved_names$matched_name)){
        info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$matched_name[i],
                                         searchtype = "scientific",
                                         accepted = T,
                                         ask = F))
        if (attr(info, "match") == "found"){
          all_resolved_names$authority_taxon_id[i] <- info[1]
        }
      }

      # Add taxon_rank to all_resolved_names (only supported for ITIS right now)

      message('Identifying taxon ranks.')

      all_resolved_names$taxon_rank <- character(nrow(all_resolved_names))

      for (i in 1:length(all_resolved_names$matched_name)){
        info <- all_resolved_names$authority_taxon_id[i]
        if (!info == ""){
          info <- itis_taxrank(query = as.numeric(info))
          all_resolved_names$taxon_rank[i] <- info
        }
      }

      # Remove donotuse column

      all_resolved_names <- all_resolved_names[ ,-4]

      # Write results to file -------------------------------------------------------

      message('Writing results to "taxon_map.txt".')

      write.table(all_resolved_names,
                  file = paste(path,
                               "/",
                               "taxon_map.txt",
                               sep = ""),
                  col.names = T,
                  row.names = F,
                  sep = "\t",
                  eol = "\r\n",
                  quote = F)

    } else {

      message('Unable to resolve taxonomic data. taxon_map.txt was not created.')
      message('Done.')

    }






  } else if (method == "manual"){

    message('Method = "manual"')

    # Select authority ------------------------------------------------------------

    data_source <- as.integer("3") # Restrict to ITIS (for now)

    # Send to Global Names Resolver (GNR) -----------------------------------------
    # NOTE: Colloquial terms will  not resolve, nor will any non-sensical taxon
    # (e.g. "unsorted biomass"). These are resolved in the next step.

    message('Resolving scientific names.')

    gnr_out <- gnr_resolve(names = data_L0,
                           data_source_ids = data_source,
                           resolve_once = F,
                           with_context = F,
                           canonical = T,
                           best_match_only = T)

    if (length(gnr_out) != 0){

      data_out <- subset(gnr_out,
                         select = c(user_supplied_name,
                                    matched_name2,
                                    data_source_title))

      colnames(data_out)[2] <- "authority_match"
      colnames(data_out)[3] <- "authority_name"

      data_out$do_not_use <- character(dim(data_out)[1])

    }

    # Attempt to resolve common names
    # Identify remaining names and send through common2science name resolver.
    # Print to file for spread sheet selection (manual).

    message('Resolving common names.')

    data_sources <- data.frame(id = seq(2),
                               title = c("itis", "worms"),
                               stringsAsFactors = F)

    data_source <- as.integer("1") # Restrict to ITIS (for now)


    # List unidentified taxa.

    use_i <- data_L0 %in% unique(gnr_out[["user_supplied_name"]])
    unidentified_taxa <- data_L0[!use_i]

    # data_out <- data.frame(user_supplied_name = character(0),
    #                        authority_match = character(0),
    #                        authority_name = character(0),
    #                        name_usage = character(0),
    #                        authority_taxon_id = character(0),
    #                        stringsAsFactors = F)

    ut_out <- data.frame(user_supplied_name = character(0),
                         authority_match = character(0),
                         authority_name = character(0),
                         name_usage = character(0),
                         authority_taxon_id = character(0),
                         stringsAsFactors = F)

    if (!identical(unidentified_taxa, character(0))){
      for (i in 1:length(unidentified_taxa)){
        comm2sci_reply <- as.data.frame(terms(query = unidentified_taxa[i],
                                              what = "common"))
        if (!isTRUE((dim(comm2sci_reply)[1] == 0) & (dim(comm2sci_reply)[2] == 0))){
          ut_out <- rbind(ut_out,
                          data.frame(user_supplied_name = unidentified_taxa[i],
                                     authority_match = comm2sci_reply$scientificName,
                                     authority_name = "ITIS",
                                     name_usage = comm2sci_reply$nameUsage,
                                     authority_taxon_id = comm2sci_reply$tsn))
        } else if ((isTRUE((dim(comm2sci_reply)[1] == 0) & (dim(comm2sci_reply)[2] == 0)))){
          ut_out <- rbind(ut_out,
                          data.frame(user_supplied_name = unidentified_taxa[i],
                                     authority_match = "",
                                     authority_name = "",
                                     name_usage = "",
                                     authority_taxon_id = ""))
        }
      }
    }




    # for (i in 1:length(data_source)){
    #   comm2sci_reply <- comm2sci(commnames = unidentified_taxa, db = data_sources$title[i])
    #   if (length(comm2sci_reply) != 0){
    #     for (j in 1:length(comm2sci_reply)){
    #       usn <- names(comm2sci_reply)[j]
    #       if (identical(comm2sci_reply[[j]], character(0))){
    #         mn <- "could not be resolved"
    #       } else {
    #         mn <- comm2sci_reply[[j]]
    #       }
    #       dst <- data_sources$title[i]
    #       usn <- rep(usn, length(mn))
    #       dst <- rep(dst, length(mn))
    #       utr <- rep("", length(mn))
    #       dat_out <- data.frame(user_supplied_name = usn,
    #                             authority_match = mn,
    #                             authority_name = dst,
    #                             do_not_use = utr,
    #                             stringsAsFactors = F)
    #       ut_out <- rbind(ut_out, dat_out)
    #     }
    #   }
    # }
    #
    # # Prompt user to select from list of resolvable options
    #
    # if (dim(ut_out)[1] != 0){
    #   ut_out <- ut_out[order(ut_out$user_supplied_name), ]
    #   ut_out$authority_name <- toupper(ut_out$authority_name)
    #
    #   ut_out2 <- data.frame(user_supplied_name = character(0),
    #                         authority_match = character(0),
    #                         authority_name = character(0),
    #                         do_not_use = character(0),
    #                         stringsAsFactors = F)
    #   uni_supplied_names <- unique(ut_out$user_supplied_name)
    #   for (i in 1:length(uni_supplied_names)){
    #     use_i <- ut_out$user_supplied_name == uni_supplied_names[i]
    #     hold <- ut_out[use_i, ]
    #     ut_out2 <- rbind(ut_out2, hold)
    #   }
    #   use_i <- ut_out2$authority_match == "could not be resolved"
    #   ut_out2 <- ut_out2[!use_i, ]
    #
    #   ut_out3 <- data.frame(user_supplied_name = character(0),
    #                         authority_match = character(0),
    #                         authority_name = character(0),
    #                         do_not_use = character(0),
    #                         stringsAsFactors = F)
    #   uni_supplied_names <- unique(ut_out2$user_supplied_name)
    #
    #   for (i in 1:length(uni_supplied_names)){
    #     hold <- c()
    #     use_i <- ut_out2$user_supplied_name == uni_supplied_names[i]
    #     hold <- ut_out2[use_i, ]
    #     rownames(hold) <- seq(nrow(hold))
    #     print(hold[ , 1:2])
    #     print("Reference the list of matches above")
    #     answer <- readline("Enter the row number of the correct match for your data: ")
    #     print(paste("You selected ...", hold$authority_match[as.integer(answer)]))
    #     ut_out3 <- rbind(ut_out3, hold[as.integer(answer), ])
    #   }
    #   ut_out <- ut_out3
    # }





    # Combine resolvable names (scientific and common) ----------------------------

    if (exists("data_out")){
      all_resolved_names <- data_out

      # Add authority_taxon_id to all_resolved_names (only supported for ITIS right now)

      message('Identifying taxonomic serial numbers.')

      all_resolved_names$authority_taxon_id <- character(nrow(all_resolved_names))
      colnames(all_resolved_names) <- c("user_supplied_name",
                                        "authority_match",
                                        "authority_name",
                                        "name_usage",
                                        "authority_taxon_id")

      data_out <- data.frame(user_supplied_name = character(0),
                             authority_match = character(0),
                             authority_name = character(0),
                             name_usage = character(0),
                             authority_taxon_id = character(0),
                             stringsAsFactors = F)

      for (i in 1:length(all_resolved_names$authority_match)){
        info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$authority_match[i],
                                         searchtype = "scientific",
                                         accepted = T,
                                         ask = F))
        if (attr(info, "match") == "found"){
          all_resolved_names$authority_taxon_id[i] <- info[1]
          all_resolved_names$name_usage[i] <- "accepted"
          data_out <- rbind(data_out,
                            all_resolved_names[i, ])
        } else {
          info <- suppressWarnings(terms(query = all_resolved_names$authority_match[i],
                                         what = "scientific"))
          info <- as.data.frame(info)
          if (!isTRUE((dim(info)[1] == 0) & (dim(info)[2] == 0))){
            data_out <- rbind(data_out,
                              data.frame(user_supplied_name = all_resolved_names$user_supplied_name[i],
                                         authority_match = info$scientificName,
                                         authority_name = "ITIS",
                                         name_usage = info$nameUsage,
                                         authority_taxon_id = info$tsn))
          } else if ((isTRUE((dim(info)[1] == 0) & (dim(info)[2] == 0)))){
            data_out <- rbind(data_out,
                              data.frame(user_supplied_name = all_resolved_names$user_supplied_name[i],
                                         authority_match = "",
                                         authority_name = "",
                                         name_usage = "",
                                         authority_taxon_id = ""))
          }
        }
      }
    }

    # Combine resolved scientific and common names

    if (isTRUE(exists("data_out") & (dim(ut_out)[1] != 0))){
      data_out <- rbind(ut_out, data_out)
    } else if (isTRUE(!exists("data_out") & (dim(ut_out)[1] != 0))){
      data_out <- ut_out
    }

    # Add column to indicate selection then rearrange column order

    data_out$selection <- ""

    data_out <- data.frame(selection = data_out$selection,
                           user_supplied_name = data_out$user_supplied_name,
                           authority_match = data_out$authority_match,
                           name_usage = data_out$name_usage,
                           authority_name = data_out$authority_name,
                           authority_taxon_id = data_out$authority_taxon_id,
                           stringsAsFactors = F)

    # Add selection mark to uniquely resolved taxon

    use_i <- !data_out$user_supplied_name %in% data_out$user_supplied_name[duplicated(data_out$user_supplied_name)]
    data_out$selection[use_i] <- "x"

    # Remove "x" from unique taxon with no info in authority_match column

    use_i <- data_out$authority_match == ""
    data_out$selection[use_i] <- ""

    # Add space between user_supplied_names to simplify reading

    df_new <- as.data.frame(lapply(data_out, as.character), stringsAsFactors = FALSE)
    taxon_choices <- do.call(rbind, by(df_new, df_new$user_supplied_name, rbind, ""))

    # Write results to file -------------------------------------------------------

    message('Writing results to "taxon_choices.txt".')

    write.table(taxon_choices,
                file = paste(path,
                             "/",
                             "taxon_choices.txt",
                             sep = ""),
                col.names = T,
                row.names = F,
                sep = "\t",
                eol = "\r\n",
                quote = F)

    message("Done.")








  } else if (method == "interactive"){

    message('Method = "interactive"')

    # Select authority ------------------------------------------------------------

    data_source <- as.integer("3") # Restrict to ITIS (for now)

    # Send to Global Names Resolver (GNR) -----------------------------------------
    # NOTE: Colloquial terms will  not resolve, nor will any non-sensical taxon
    # (e.g. "unsorted biomass"). These are resolved in the next step.

    message('Resolving scientific names.')

    gnr_out <- gnr_resolve(names = data_L0,
                           data_source_ids = data_source,
                           resolve_once = F,
                           with_context = F,
                           canonical = T,
                           best_match_only = T)

    if (length(gnr_out) != 0){

      data_out <- subset(gnr_out,
                         select = c(user_supplied_name,
                                    matched_name2,
                                    data_source_title))

      colnames(data_out)[2] <- "authority_match"
      colnames(data_out)[3] <- "authority_name"

      data_out$do_not_use <- character(dim(data_out)[1])

    }

    # Attempt to resolve common names
    # Identify remaining names and send through common2science name resolver.
    # Print to file for spread sheet selection (manual).

    message('Resolving common names.')

    data_sources <- data.frame(id = seq(2),
                               title = c("itis", "worms"),
                               stringsAsFactors = F)

    data_source <- as.integer("1") # Restrict to ITIS (for now)


    # List unidentified taxa.

    use_i <- data_L0 %in% unique(gnr_out[["user_supplied_name"]])
    unidentified_taxa <- data_L0[!use_i]

    ut_out <- data.frame(user_supplied_name = character(0),
                         authority_match = character(0),
                         authority_name = character(0),
                         do_not_use = character(0),
                         stringsAsFactors = F)

    for (i in 1:length(data_source)){
      comm2sci_reply <- comm2sci(commnames = unidentified_taxa, db = data_sources$title[i])
      if (length(comm2sci_reply) != 0){
        for (j in 1:length(comm2sci_reply)){
          usn <- names(comm2sci_reply)[j]
          if (identical(comm2sci_reply[[j]], character(0))){
            mn <- "could not be resolved"
          } else {
            mn <- comm2sci_reply[[j]]
          }
          dst <- data_sources$title[i]
          usn <- rep(usn, length(mn))
          dst <- rep(dst, length(mn))
          utr <- rep("", length(mn))
          dat_out <- data.frame(user_supplied_name = usn,
                                authority_match = mn,
                                authority_name = dst,
                                do_not_use = utr,
                                stringsAsFactors = F)
          ut_out <- rbind(ut_out, dat_out)
        }
      }
    }

    # Prompt user to select from list of resolvable options

    if (dim(ut_out)[1] != 0){
      ut_out <- ut_out[order(ut_out$user_supplied_name), ]
      ut_out$authority_name <- toupper(ut_out$authority_name)

      ut_out2 <- data.frame(user_supplied_name = character(0),
                            authority_match = character(0),
                            authority_name = character(0),
                            do_not_use = character(0),
                            stringsAsFactors = F)
      uni_supplied_names <- unique(ut_out$user_supplied_name)
      for (i in 1:length(uni_supplied_names)){
        use_i <- ut_out$user_supplied_name == uni_supplied_names[i]
        hold <- ut_out[use_i, ]
        ut_out2 <- rbind(ut_out2, hold)
      }
      use_i <- ut_out2$authority_match == "could not be resolved"
      ut_out2 <- ut_out2[!use_i, ]

      ut_out3 <- data.frame(user_supplied_name = character(0),
                            authority_match = character(0),
                            authority_name = character(0),
                            do_not_use = character(0),
                            stringsAsFactors = F)
      uni_supplied_names <- unique(ut_out2$user_supplied_name)

      for (i in 1:length(uni_supplied_names)){
        hold <- c()
        use_i <- ut_out2$user_supplied_name == uni_supplied_names[i]
        hold <- ut_out2[use_i, ]
        rownames(hold) <- seq(nrow(hold))
        print(hold[ , 1:2])
        print("Reference the list of matches above")
        answer <- readline("Enter the row number of the correct match for your data: ")
        print(paste("You selected ...", hold$authority_match[as.integer(answer)]))
        ut_out3 <- rbind(ut_out3, hold[as.integer(answer), ])
      }
      ut_out <- ut_out3
    }




    # Combine resolvable names (scientific and common) ----------------------------

    if ((exists("data_out") & exists("ut_out")) == T){
      all_resolved_names <- rbind(data_out, ut_out)
    } else if ((exists("data_out") & !exists("ut_out")) == T){
      all_resolved_names <- data_out
    } else if ((exists("ut_out") & !exists("data_out")) == T){
      all_resolved_names <- ut_out
    }



    # Add authority_taxon_id to all_resolved_names (only supported for ITIS right now)
    # get_tsn only works for ITIS. Could add other db options.

    message('Identifying taxonomic serial numbers.')

    all_resolved_names$authority_taxon_id <- character(nrow(all_resolved_names))

    for (i in 1:length(all_resolved_names$authority_match)){
      info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$authority_match[i],
                                       searchtype = "scientific",
                                       accepted = T,
                                       ask = F))
      if (attr(info, "match") == "found"){
        all_resolved_names$authority_taxon_id[i] <- info[1]
      } else {
        info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$authority_match[i],
                                         searchtype = "scientific",
                                         accepted = T,
                                         ask = T))
        all_resolved_names$authority_taxon_id[i] <- info[1]
      }
    }

    # Add taxon_rank to all_resolved_names (only supported for ITIS right now) ----

    message('Identifying taxonomic ranks.')

    all_resolved_names$taxon_rank <- character(nrow(all_resolved_names))
    use_i <- is.na(all_resolved_names$authority_taxon_id)
    all_resolved_names$authority_taxon_id[use_i] <- ""

    for (i in 1:length(all_resolved_names$authority_match)){
      info <- all_resolved_names$authority_taxon_id[i]
      if (!info == ""){
        info <- itis_taxrank(query = as.numeric(info))
        all_resolved_names$taxon_rank[i] <- info
      }
    }

    # Remove donotuse column

    all_resolved_names <- all_resolved_names[ ,-4]

    # Write results to file -------------------------------------------------------

    message('Writing results to "taxon_map.txt".')

    write.table(all_resolved_names,
                file = paste(path,
                             "/",
                             "taxon_map.txt",
                             sep = ""),
                col.names = T,
                row.names = F,
                sep = "\t",
                eol = "\r\n",
                quote = F)

  }



}











