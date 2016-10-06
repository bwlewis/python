
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

  # call tf onLoad handler
#  tf_on_load(libname, pkgname)
}


.onAttach <- function(libname, pkgname) {
  # call tf onAttach handler
#  tf_on_attach(libname, pkgname)
}

.onUnload <- function(libpath) {
  py_finalize();
}
