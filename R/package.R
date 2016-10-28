#' Not TensorFlow for R
#'
#'
#' @docType package
#' @name python 
#' @useDynLib python
#' @importFrom Rcpp evalCpp
NULL

.onLoad <- function(libname, pkgname) {

  # initialize python
  config <- py_config()
  py_initialize(config$libpython);

  # add our python scripts to the search path
  py_run_string(paste0("import sys; sys.path.append('",
                       system.file("python", package = "python") ,
                       "')"))
}

.onUnload <- function(libpath) {
  py_finalize();
}
