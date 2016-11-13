# Python bindings for R

The `python` package defines a simple interface that lets R easily interact
with and manipulate many Python objects. It's derived from a fork of the superb
https://github.com/rstudio/tensorflow project (the `rpy` branch).

## Differences with https://github.com/rstudio/tensorflow

The intention of the `python` package is to provide a simpler interface between
R and Python compared to the more specialized Tensorflow R package.
The `python` package:

- removes tensorflow-specific objects and methods. 
- defers evaluating Python objects, allowing R programs to directly use Python object methods from R
- automatically converts R objects to corresponding Python ones when it can (just like the Tensorflow package)
- adds limited support for sparse matrix objects (compressed column oriented sparse matrices for now)
- treats R numeric vectors as 1-d numpy arrays when possible instead of Python list objects (users can append Python's tolist() method to yield Python lists if they wish)

## Why a separate project?

Now that these packages have begun to diverge somewhat, I decided to sever the
fork relationship to let users report issues specific to the `python` package,
distinct from the Tensorflow package.

Note that the low-level function namespaces are compatible between packages, so
that both may be loaded and used together (the user must prefix the `import()`
function with the desired package name however).

# Requirements and installation

R and the Rcpp package version >= 0.12.7 are required.  Python version 2 or 3
and the Python development headers and the numpy library are required. The Python
requirements may be satisfied on a Debian-like Linux operating system with,
for instance:
```
sudo apt-get install python-dev python-numpy
```

Install the package using the R `devtools` package with
```{r}
devtools::install_github("bwlewis/python")
```

# Quick start

Import the numpy library:
```{r}
library(python)
np = import("numpy")
```
TAB completion works on most Python objects. R's dollar sign operator
is used to access Python object methods and variables.
For instance, try typing `np$<TAB>` to see a (long) list of available numpy methods, functions, and variables.

Create an R matrix and copy it into a Python Numpy array object:
```{r}
set.seed(1)
x = matrix(rnorm(9), nrow=3)
p = np$array(x)
print(p)
```
```
[[-0.62645381  1.5952808   0.48742905]
 [ 0.18364332  0.32950777  0.73832471]
 [-0.83562861 -0.82046838  0.57578135]]
```
Note that the `p` variable is really a Python object, for example the output
above was printed by Python.
```{r}
class(p)
```
```
[1] "numpy.ndarray"         "python.builtin.object" "externalptr"
```
Again, we can use the dollar sign operator and TAB completion to see what
Python methods are available for our Numpy array:
```
p$<TAB>

p$T             p$byteswap      p$cumsum        p$flat          p$min           p$ravel         p$shape         p$tobytes
p$all           p$choose        p$data          p$flatten       p$nbytes        p$real          p$size          p$tofile
p$any           p$clip          p$diagonal      p$getfield      p$ndim          p$repeat        p$sort          p$tolist
p$argmax        p$compress      p$dot           p$imag          p$newbyteorder  p$reshape       p$squeeze       p$tostring
p$argmin        p$conj          p$dtype         p$item          p$nonzero       p$resize        p$std           p$trace
p$argpartition  p$conjugate     p$dump          p$itemset       p$partition     p$round         p$strides       p$transpose
p$argsort       p$copy          p$dumps         p$itemsize      p$prod          p$searchsorted  p$sum           p$var
p$astype        p$ctypes        p$fill          p$max           p$ptp           p$setfield      p$swapaxes      p$view
p$base          p$cumprod       p$flags         p$mean          p$put           p$setflags      p$take
```
Use the `pyhelp()` function if you want help on something. At the moment,
`pyhelp()` needs you to provide a full valid Python name (with dots). For instance:
```{r}
pyhelp("numpy.ndarray.prod")
```
```
numpy.ndarray.prod = prod(...)
    a.prod(axis=None, dtype=None, out=None, keepdims=False)
    
    Return the product of the array elements over the given axis
    
    Refer to `numpy.prod` for full documentation.
    
    See Also
    --------
    numpy.prod : equivalent function
```
Let's compare R and Python:
```{r}
prod(x)
p$prod()
```
```
[1] -0.008591294
-0.00859129361028
```

NOTE! Python functions and methods return new Python objects. The 2nd returnd
value above from `p$prod()` is *not* an R object:
```{r}
p$prod() + 1
```
```
Error in p$prod() + 1 : non-numeric argument to binary operator
```

Use the `R()` function to convert Python objects back in to corresponding R
objects:
```{r}
R(p$prod()) + 1
```
```
[1] 0.9914087
```
Or, with the matrices themselves:
```{r}
x - R(p)
```
```
     [,1] [,2] [,3]
[1,]    0    0    0
[2,]    0    0    0
[3,]    0    0    0
```

# Sparse matrices and more examples

Right now (November, 2016), the package only understands double-precision
general compressed, column-oriented sparse format. Hopefully soon more
sparse matrix formats will be added (adding new format comprehension is
pretty easy).

```{r}
library(Matrix)
library(python)

set.seed(1)
x = sparseMatrix(i = sample(10, 10), j = sample(10, 10), x = runif(10), dims=c(10,10))

sp = import("scipy.sparse")
p = sp$csc_matrix(x)

```
