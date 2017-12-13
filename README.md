# taxonomyCleanr

Taxonomic data can be messy and challenging to work with. Incorrect spelling, the use of common names, unaccepted names, and synonyms, contribute to ambiguity in what a taxon actually is. This R package helps you resolve taxonomic data to a taxonomic authority, get accepted names and taxonomic serial numbers, as well as create metadata for your taxa in the Ecological Metadata Language (EML) format.

## Getting started

### Contents

#### Documenation

[Instructions for running the taxonomyCleanr](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/instructions.md)

#### R package

`taxonomyCleanr` is a collection of wrapper functions to the `taxize` R package developed by [Chamberlain et al. (2016)](https://github.com/ropensci/taxize). `taxize` contains substantially more functionality than used by the `taxonomyCleanr`. We recommend a browse through the [`taize` documentation](https://cran.r-project.org/web/packages/taxize/taxize.pdf) to see all they have to offer.

The `taxonomyCleanr` R package is available here on GitHub. To install, go to your RStudio Console window and enter these lines of code:

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

Now follow [these instructions](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/instructions.md) to begin operating the `taxonomyCleaner`.

## Running the tests

Our tests will be made availble soon!

## Contributing

We welcome contributions of all forms including code, bug reports, and requests for development. Please reference our [code conduct](https://github.com/EDIorg/taxonomyCleanr/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/taxonomyCleanr/blob/master/CONTRIBUTING.md) for submitting pull requrests.

## Versioning

Verioning for the `taxonomyCleanr` follows [semantic versioning](https://semver.org/). `taxonomyCleanr` is ready for use but is in a pre-release version. Once some final features have been added and testing complete, the production version 1.0.0 will be released.

## Authors

[See the list of contributors to this project](https://github.com/EDIorg/taxonomyCleanr/blob/master/AUTHORS.md).

## License

This project is licensed under the [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/legalcode) License - see the LICENSE file for details.

## Related materials

