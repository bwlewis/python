# Miscellaneous extra internal conversion routines handled in the R language
#
# Add other conversions here as desired. Note that the coversions performed
# here copy their data unlike those performed by the lower-level scalar and
# numpy conversions. This is probably necessary for complex data structures
# like sparse matrices and others.

#' Convert miscellaneous Python objects to R objects called by the
#' py_to_r C function as a last conversion result
#' @param x a python object
#' @return either a converted R object or NULL if no
#'          suitable conversion could be found
#' @keywords internal
r_py_to_r <- function(x)
{
  if(isTRUE(all(c("scipy.sparse.csc.csc_matrix", "externalptr") %in% class(x))))
  {
    return(sparseMatrix(i=1 + x$indices, p=x$indptr,
                        x=as.vector(x$data), dims=unlist(x$shape)))
  }
  NULL
}

#' Convert miscellaneous R objects to Python objects, called by r_to_py
#' C function as a last conversion result
#' @param x an R object
#' @return either a converted Python object or error if no
#'          suitable conversion could be found
#' @keywords internal
r_r_to_py <- function(x)
{
  c <- class(x)
  sp <- import("scipy.sparse")
  if("dgCMatrix" %in% c) return(
    sp$csc_matrix(list(x@x, x@i, x@p), dim(x))
  )
  stop("Unable to convert R object to python type")
}
