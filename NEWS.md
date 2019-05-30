# taxonomyCleanr 1.1.0

#### 2019-05-28
* __Enhancement:__ `make_taxonomicCoverage()` now works with `EML` v.2.0.0 and outputs the taxonomicCoverage node as a list object and/or an .xml file written to path. The argument `write.file` has been added to enable use of taxa_map.csv without writing to file. These changes are based on a pull request by @srearl.

# taxonomyCleanr 1.0.1

#### 2019-04-04
* __Bug fix:__ Refactor calls to `taxize`. The `taxize` package changed to tibble outputs and taxonomyCleanr was expecting data frames. Inputs from taxize are now converted to data frames prior to processing. Thanks for reporting this issue @srearl!

# taxonomyCleanr 1.0.0

#### 2019-04-03
* __Enhancement:__ Clean up demonstration vignette.
* __Enhancement:__ Build project website with `pkgdown`.
* __Enhancement:__ Add change log!
