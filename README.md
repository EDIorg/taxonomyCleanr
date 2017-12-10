# taxonomyCleanr

Taxonomic data can be challenging to work with. Some of these challenges include incorrect spelling, use of non-accepted names, colloquial terms, synonyms, and generally ambiguity in what a taxa actually is. This R package helps you resolve taxonomic data to a taxonomic authority.

## Getting started

### Contents

#### Documenation

[A schematic representation of the workflows supported by this package.](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/schematic.md)

[Instructions for running these workflows](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/example.md)

#### R package

`taxonCleanr` is a collection of wrapper functions to the `taxize` R package developed by [Boettiger et al. (2017)](https://github.com/ropensci/EML). For an understanding of what is going on under the hood of the assembly line, we recommend you first take a look at the `EML` R package. Once you understand this you will be able to customize the assembly line for your own workflows or become a developer of this project.

The `EMLassemblyline` R package is available here on GitHub. To install, go to your RStudio Console window and enter these lines of code:

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load EMLassemblyline
install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
```

Now reference the documentation listed above to start operating the assembly line.

## Running the tests

We have not yet formalized our testing.

## Contributing

We welcome contributions of all forms including code, bug reports, and requests for development. Please reference our [code conduct](https://github.com/EDIorg/EMLassemblyline/blob/master/CODE_OF_CONDUCT.md) and [contributing guidelines](https://github.com/EDIorg/EMLassemblyline/blob/master/CONTRIBUTING.md) for submitting pull requrests.

## Versioning

We do not yet have any versions available. Stay tuned!

## Authors

Several people have participated in this project. [View the current list of team members and contributors](https://github.com/EDIorg/EMLassemblyline/blob/master/AUTHORS.md).

## License

This project is licensed under the [CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/legalcode) License - see the LICENSE file for details.

## Related materials

[Learn everything you wanted to know about the Ecological Metadata Language standard.](https://knb.ecoinformatics.org/#external//emlparser/docs/index.html)

[Reference the community developed best practices for EML content.](https://environmentaldatainitiative.org/resources/assemble-data-and-metadata/step-3-create-eml-metadata/best-practices-for-dataset-metadata-in-ecological-metadata-language-eml/)
