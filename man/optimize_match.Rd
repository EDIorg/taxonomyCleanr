% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resolve_sci_taxa.R
\name{optimize_match}
\alias{optimize_match}
\title{Optimize match}
\usage{
optimize_match(x, data.sources)
}
\arguments{
\item{x}{(character) A character string specifying the taxon.}

\item{data.sources}{(numeric) A numeric vector of values specifying the authorities to search across.
Run `view_authorities` to get valid data source options and ID's.}
}
\value{
\itemize{
        \item{taxa_clean} Resolved name for input taxon.
        \item{rank} Rank of the input taxon.
        \item{authority} Best authority match for input taxon.
        \item{authority_id} Corresponding authority ID for the input taxon.
        \item{score} Authority match score for input taxon.

    }
}
\description{
Optimize the taxon match to an authority based on completeness of
    returned information. A complete return contains both an authority
    name and an authority ID for a taxon.
}
\keyword{internal}
