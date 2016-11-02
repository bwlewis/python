# Miscellaneous internal conversion routines handled in the R language

#' Convert miscellaneous Python objects to R objects
#' @param x a python object
#' @return either a converted R object or the original python object if no
#'          suitable conversion could be found
#' @keywords internal
r_py_to_r <- function(x)
{
  if(isTRUE(all(c("scipy.sparse.csc.csc_matrix", "externalptr") %in% class(x))))
  {
    return(sparseMatrix(i=1 + x$indices, p=x$indptr,
                        x=as.vector(x$data), dims=unlist(x$shape)))
  }
  x
}

#' Convert miscellaneous R objects to Python objects,
#' called by r_to_py C function
#' @param x an R object
#' @return either a converted Python object or error if no
#'          suitable conversion could be found
#' @keywords internal
r_r_to_py <- function(x)
{
  c <- class(x)
  if("dgCMatrix" %in% c) return(
    sp$csc_matrix(list(x@x, x@i, x@p), dim(x))
  )
  stop("Unable to convert R object to python type")
}
