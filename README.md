# taxonomyCleanr

Taxonomic data can be messy and challenging to work with. Incorrect spelling, the use of common names, unaccepted names, and the use of synonyms all contribute to ambiguity in what a taxon is. This R package helps you resolve these issues by resolving your taxonomic data to an authority system and helps you create metadata for your taxonomic data in the Ecological Metadata Language (EML) format.

## Getting started

### Documenation

[Instructions for using the taxonomyCleanr](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/instructions.md)

### R package

`taxonomyCleanr` is a collection of wrapper functions to the `taxize` R package developed by [Chamberlain et al. (2016)](https://github.com/ropensci/taxize). `taxize` offers substantially more functionality than used by the `taxonomyCleanr`. We recommend a browse through the [`taxize` documentation](https://cran.r-project.org/web/packages/taxize/taxize.pdf) to see all it has to offer.

The `taxonomyCleanr` R package is available here on GitHub. To install, go to your RStudio Console window and enter these lines of code:

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

## Running the tests

We are still formulating our tests. Please check back soon!

## Contributing

We welcome contributions of all forms including code, bug reports, and requests for development. Please reference our [code conduct](https://github.com/EDIorg/taxonomyCleanr/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/taxonomyCleanr/blob/master/CONTRIBUTING.md) for submitting pull requests.

## Versioning

Versioning for the `taxonomyCleanr` follows [semantic versioning](https://semver.org/).

## Authors

[See the list of contributors to this project](https://github.com/EDIorg/taxonomyCleanr/blob/master/AUTHORS.md).

