# taxonomyCleanr 1.1.1

## Bug fixes

* __Missing taxonomicClassification:__ The taxonomicClassification element was missing from the taxonomicCoverage top-level list producing invalid EML. This issue has been fixed.

# taxonomyCleanr 1.1.0

## Enhancements

* __EML v2.0.0:__ `make_taxonomicCoverage()` now works with `EML` v.2.0.0 and outputs the taxonomicCoverage node as a list object and/or an .xml file written to path. The argument `write.file` has been added to enable use of taxa_map.csv without writing to file. These changes are based on a pull request by @srearl.

# taxonomyCleanr 1.0.1

## Bug fixes

* __Invalid input:__ Refactor calls to `taxize`. The `taxize` package changed to tibble outputs and taxonomyCleanr was expecting data frames. Inputs from taxize are now converted to data frames prior to processing. Thanks for reporting this issue @srearl!

# taxonomyCleanr 1.0.0

## Enhancements

* __Demo vignette:__ Clean up demonstration vignette.
* __Project website:__ Build project website with `pkgdown`.
* __Change log:__ Add change log!
