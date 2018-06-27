# taxonomyCleanr

Taxonomic data can be challenging to work with. Incorrect spelling, common names, unaccepted names, and the use of synonyms all contribute to ambiguity in the representation of a taxon. `taxonomyCleanr` helps address these issues by providing a user friendly workflow for resolving taxa to an authority (e.g. [Integrated Taxonomic Information System](https://www.itis.gov/)) and provides additional useful outputs (e.g. Rendering of taxonomic information in the [Ecological Metadata Language (EML)](https://knb.ecoinformatics.org/#external//emlparser/docs/index.html)).

## Getting started

### R package

`taxonomyCleanr` is a collection of wrapper functions to the `taxize` R package developed by [Chamberlain et al. (2016)](https://github.com/ropensci/taxize). `taxize` offers substantially more functionality than used by `taxonomyCleanr`. We recommend a browse through the [`taxize` documentation](https://cran.r-project.org/web/packages/taxize/taxize.pdf) to see all it has to offer.

`taxonomyCleanr` is available here on GitHub. To install:

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

### Documenation

[Instructions for the taxonomyCleanr](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/instructions.md)

## Contributing

We welcome contributions of all forms including code, bug reports, and requests for development. Please reference our [code conduct](https://github.com/EDIorg/taxonomyCleanr/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/taxonomyCleanr/blob/master/CONTRIBUTING.md) for submitting pull requests.

## Versioning

Versioning for the `taxonomyCleanr` follows [semantic versioning](https://semver.org/).

## Authors

[See the list of contributors to this project](https://github.com/EDIorg/taxonomyCleanr/blob/master/AUTHORS.md).

