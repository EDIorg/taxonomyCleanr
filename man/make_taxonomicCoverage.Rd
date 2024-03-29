% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_taxonomicCoverage.R
\name{make_taxonomicCoverage}
\alias{make_taxonomicCoverage}
\title{Make taxonomicCoverage EML node}
\usage{
make_taxonomicCoverage(
  taxa.clean,
  authority = NA,
  authority.id = NA,
  rank = NA,
  path,
  write.file = TRUE
)
}
\arguments{
\item{taxa.clean}{(character) Taxa names as they appear in your dataset}

\item{authority}{(character) Authorities \code{taxa.clean} have been resolved to. Supported authorities include: "ITIS", "WORMS", "GBIF". For unsupported authorities, list the home page URL. For unresolved taxa use \code{NA}. If only one authority is provided, function will use that authority for all entries. If more than one authority, e.g. four, but fewer than the length of \code{taxa.clean}, is provided, function will only expand into full taxonomic classification for the first names, up to the number of authorities provided (e.g. the first four in \code{taxa.clean}); the rest of the names will not be expanded.}

\item{authority.id}{(character) ID of \code{taxa.clean} within the \code{authority}, otherwise \code{NA}}

\item{rank}{(character) Rank (e.g. "Genus", "Species") of \code{taxa.clean}, otherwise \code{NA}. This is useful when \code{taxa.clean} can't be resolved to an \code{authority} and the rank must be manually defined.}

\item{path}{(character) Path of the directory to which taxonomicCoverage.xml will be written. Can also be the path of the directory containing taxa_map.csv, if using as inputs to this function.}

\item{write.file}{(logical) Whether taxonomicCoverage.xml should be written to file. Default is \code{TRUE}.}
}
\value{
\item{emld list}{The taxonomicClassification EML node for use in constructing EML metadata with the EML R library.}
\item{taxonomicCoverage.xml}{If \code{write.file = TRUE}.}
}
\description{
Make taxonomicCoverage EML node
}
\details{
This function uses \code{get_classification()} to expand taxa, resolved to supported authorities, into full taxonomic classification. Each level of classification is accompanied by an annotation (listing the \code{authority} and \code{authority.id}) and common names (only when \code{authority} is ITIS or WORMS). Taxa resolved to unsupported authorities, or not resolved at all, will be listed as is defined in the \code{taxa.clean}, \code{authority}, and \code{authority.id} arguments.
}
\note{
The name of this function is a bit misleading. The return value is actually a list of taxonomicClassification nodes, which occur immediately below taxonomicCoverage (i.e. ../taxonomicCoverage/taxonomicClassification).
}
\examples{
\dontrun{

# Set working directory
setwd("/Users/me/Documents/data_packages/pkg_260")

# For taxa resolved to a supported authority
taxcov <- make_taxonomicCoverage(
  taxa.clean = c("Oncorhynchus tshawytscha", "Oncorhynchus nerka"),
  authority = c("WORMS", "WORMS"),
  authority.id = c("158075", "254569"),
  path = ".")

# For taxa resolved to an unsupported authority
taxcov <- make_taxonomicCoverage(
  taxa.clean = c("Taxon-1", "Taxon-2"),
  authority = c("https://some-authority.org", "https://some-authority.org"),
  authority.id = c("123", "456"),
  path = ".")

# For taxa not resolved to an authority
taxcov <- make_taxonomicCoverage(
  taxa.clean = c("Taxon-1", "Taxon-2"),
  path = ".")

}

}
