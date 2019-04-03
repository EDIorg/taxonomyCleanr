[![Travis-CI Build Status](https://travis-ci.com/EDIorg/taxonomyCleanr.svg?branch=master)](https://travis-ci.org/EDIorg/taxonomyCleanr)
[![codecov.io](https://codecov.io/github/EDIorg/taxonomyCleanr/coverage.svg?branch=master)](https://codecov.io/github/EDIorg/taxonomyCleanr?branch=master)

# taxonomyCleanr

The `taxonomyCleanr` is a user friendly workflow and collection of functions to help you:
1. Identify and correct misspelled taxa
2. Resolve taxa to an authority (e.g. [Integrated Taxonomic Information System (ITIS)](https://www.itis.gov/))
3. Get hierarchical rank values
4. Get common names
5. Render taxonomic information in the [Ecological Metadata Language (EML)](https://knb.ecoinformatics.org/#external//emlparser/docs/index.html).

The `taxonomyCleanr` is based on the `taxize` R package developed by [Chamberlain et al. (2016)](https://github.com/ropensci/taxize).

## Getting started

### R package

Install `taxonomyCleanr` from GitHub

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

### Documenation

[Check out use cases at the project website](https://ediorg.github.io/taxonomyCleanr/)

## Contributing

We welcome contributions of all forms including bug reports, requests for development, and new functionality. Please reference our [code conduct](https://github.com/EDIorg/taxonomyCleanr/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/taxonomyCleanr/blob/master/CONTRIBUTING.md) for submitting pull requests.

## Testing

Unit tests are found under /tests and follow the `testthat` methodology.

## Versioning

Versioning for the `taxonomyCleanr` follows [semantic versioning](https://semver.org/).

## Authors

[See the list of contributors to this project](https://github.com/EDIorg/taxonomyCleanr/blob/master/AUTHORS.md).

