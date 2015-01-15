---
layout: post
title: MATPOWER Cases in Julia
---

_Liberating MATPOWER casefile data._

The MATPOWER casefile is a common data format for power system data, but Julia (with the GraphViz package) is much better suited for network visualization. I decided to write a Julia package to import MATPOWER case data into a Julia environment.

It is possible to run MATLAB code using Julia, but not to translate arbitrary MATLAB code. Rather than working with MATPOWER directly, I decided to rely on PYPOWER, a Python port. (PYPOWER's GPL v3 license permits reuse and modification.) I cloned the [PYPOWER repository][1] (`pip install` threw a hash/md5 mismatch error):

```bash
git clone --recursive https://github.com/rwl/PYPOWER
cd PYPOWER
```
Next, I copied all `.py` files pertaining to case files into a new directory:

```bash
mkdir case-only
cp pypower/case*.py case-only
```
Here are the contents of `case-only`:

```bash
ls -1
case118.py
case14.py
case24_ieee_rts.py
case300.py
case30pwl.py
case30.py
case30Q.py
case39.py
case4gs.py
case57.py
case6ww.py
case9.py
case9Q.py
caseformat.py
```
I explored the files in this directory using the Jupyter notebook.

<img src=/images/case9py.png width="100%" align="middle">

It looks like we can use [PyCall.jl][2] to import and run any of these functions, all of which have predictable names. After a bit of experimentation, I came up with the following Julia file:

```julia
module Power
using PyCall

export loadcase

unshift!(PyVector(pyimport("sys")["path"]), "")

function loadcase(caseName::ASCIIString)
    """
    Return a Dict containing power system data 
    in MATPOWER's format. Valid cases:
    case118
    case118
    case14
    case14
    case24_ieee_rts
    case300
    case30pwl
    case30
    case30Q
    case39
    case4gs
    case57
    case6ww
    case9
    case9
    case9Q
    caseformat
    """
    pycall(pyimport(caseName)[caseName], Dict{ASCIIString,PyAny})
end

end
```
A few notes:

* One gotcha: `@pyimport` defers to Python's `sys.path`, which will not contain the folder `case-only` by default (see [this Github issue][3]). This is why I use the following line of Julia code to prepend `sys.path` with an empty string (representing the current directory):

```julia
unshift!(PyVector(pyimport("sys")["path"]), "")
```

* There are two ways to use PyCall. Macros (like `@pyimport`) accept symbols as arguments, while functions (like `pyimport()`) accept strings. Macros are more convenient during interactive use, but it is more intuitive to pass a string to the final `loadcase()` function than to pass a symbol.

* The object returned by `pycall(pyimport(caseName)[caseName])` is a Python dictionary with string keys and float values. To convert this object to its Julia analog, I passed the following type description to `pycall()`: `Dict{ASCIIString,PyAny}`. This converts the Python dictionary to a Julia `Dict` with string keys and inferred value types. (`PyAny` tells PyCall to infer the type, which I know will either be `Float64` or `Array{Float64}`.)

* Thanks to the `Module` format, I can store any MATPOWER case (case118, for example) in a Julia variable as follows:

```julia
using Power
case118 = loadcase("case118")
```


[1]: https://github.com/rwl/PYPOWER
[2]: https://github.com/stevengj/PyCall.jl
[3]: https://github.com/stevengj/PyCall.jl/issues/48