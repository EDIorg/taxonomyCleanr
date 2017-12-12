# taxonomyCleanr

Taxonomic data can be challenging to work with. Some of these challenges include incorrect spelling, use of non-accepted names, colloquial terms, synonyms, and generally ambiguity in what a taxa actually is. This R package helps you solve some of these issues and resolve your taxonomic data to a taxonomic authority.

## Getting started

### Contents

#### Documenation

[Instructions for running these workflows](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/instructions.md)

#### R package

`taxonomyCleanr` is a collection of wrapper functions to the `taxize` R package developed by [Chamberlain et al. (2016)](https://github.com/ropensci/taxize). `taxize` contains substantially more functionality than is available in the `taxonomyCleanr`, we recommend you take a look at their fine work.

The `taxonomyCleanr` R package is available here on GitHub. To install, go to your RStudio Console window and enter these lines of code:

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

Now reference the documentation listed above to start operating the `taxonomyCleaner`.

## Running the tests

We have not yet formalized our testing.

## Contributing

We welcome contributions of all forms including code, bug reports, and requests for development. Please reference our [code conduct](https://github.com/EDIorg/taxonomyCleanr/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/taxonomyCleanr/blob/master/CONTRIBUTING.md) for submitting pull requrests.

## Versioning

No released versions of `taxonomyCleanr` are yet available.

## Authors

[See the list of contributors to this project](https://github.com/EDIorg/taxonomyCleanr/blob/master/AUTHORS.md).

## License

This project is licensed under the [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/legalcode) License - see the LICENSE file for details.

## Related materials

