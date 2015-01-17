---
layout: post
title: MATPOWER Network Data in Julia
---

_Liberating MATPOWER caseformat data._

The [MATPOWER caseformat][4] is frequently used to store power system data, but Julia (with its [GraphViz package][5]) is better suited for network visualization than MATLAB. I decided to write a Julia package to import MATPOWER's built-in network data into a Julia environment.

It is possible to run MATLAB code using Julia, but not to translate arbitrary MATLAB code. Rather than working with MATPOWER directly, I used PYPOWER, a Python port under the GPL v3 license. I cloned the PYPOWER repository:

```bash
git clone --recursive https://github.com/rwl/PYPOWER
cd PYPOWER
```
Next, I copied all `.py` files containing network data into a new directory. These files begin with "case", so it's easy to glob them together:

```bash
mkdir case-only
cp pypower/case*.py case-only
```
Here are the contents of `case-only`:

```bash
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
Each of these Python files contains a single function with a predictable name -- piece of cake. After a bit of experimentation, I came up with the following Julia module, which uses [PyCall.jl][2] to handle the Python:

```julia
module Power
using PyCall

export loadcase

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
    # Add .py directory to access file:
    unshift!(PyVector(pyimport("sys")["path"]), dirname(@__FILE__))

    # Load casefile data:
    pycall(pyimport(caseName)[caseName], Dict{ASCIIString,PyAny})

    # Remove .py directory to leave path as it was:
    shift!(PyVector(pyimport("sys")["path"]));
end

end
```
A few notes:

* I am looking forward to the next Julia release, which will display the function docstring (the text between the triple double quotation marks) when the user asks for it.

* One gotcha: `@pyimport` defers to Python's `sys.path`, which will not contain the folder `case-only` by default (see [this Github issue][3]). This is why I use the following lines of Julia code to prepend `sys.path` with the appropriate directory and remove it afterwards:

```julia
unshift!(PyVector(pyimport("sys")["path"]), dirname(@__FILE__))
shift!(PyVector(pyimport("sys")["path"]));
```

* There are two ways to use PyCall. Macros (like `@pyimport`) accept symbols as arguments, while functions (like `pyimport()`) accept strings. Macros are more convenient during interactive use, but it is more intuitive to pass a string to the final `loadcase()` function than to pass a symbol.

* The object returned by `pycall(pyimport(caseName)[caseName])` is a Python dictionary with string keys and float values. To convert this object to its Julia analog, I passed the following type description to `pycall()`: `Dict{ASCIIString,PyAny}`. This converts the Python dictionary to a Julia `Dict` with string keys and inferred value types. (`PyAny` tells PyCall to infer the type, which I know will either be `Float64` or `Array{Float64}`.)

* After some debugging, I [pushed my Julia module to Github as an unregistered Julia package][6]. Anyone can use `Power.jl` as follows:

```julia
Pkg.clone("https://github.com/kersulis/Power.jl.git")
using Power
case118 = loadcase("case118")
```

The finished product gets the job done, but has a significant drawback. It is unreasonable for such a simple data import package to require its users to have Python installed. In my next post, I develop a new package called "MatpowerCases" with no non-Julia dependencies.

[1]: https://github.com/rwl/PYPOWER
[2]: https://github.com/stevengj/PyCall.jl
[3]: https://github.com/stevengj/PyCall.jl/issues/48
[4]: http://www.maths.ed.ac.uk/optenergy/LocalOpt/caseformat.txt
[5]: https://github.com/Keno/GraphViz.jl
[6]: http://julia.readthedocs.org/en/latest/manual/packages/#making-your-package-available