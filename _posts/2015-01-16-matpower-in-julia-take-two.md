---
layout: post
title: MATPOWER Network Data in Julia, Take Two
---

Though my first Julia MATPOWER network data package for importing MATPOWER network data was successful, it has a significant issue. [Miles Lubin][1] pointed out that it requires Python to work. This does seem a rather silly dependency for a data import package to have. I decided to re-work the package using [MAT.jl][2].

## MATLAB side 

I copied all caseformat `.m` files from [MATPOWER][3] into a new directory:

```bash
cp case* mfiles
```
Next I wrote MATLAB code to run each `.m` file and store the resulting caseformat data in a `.mat` file. Here are the lines that do this for the 118-bus network:

```matlab
networkData = case118;
save('matfiles/case118.mat', 'networkData')
```
I'm sure there is a more elegant way to loop through the `.m` files in MATLAB, but this is a one-time operation, and I wanted to get back to Julia.

## Julia side

With all the `.mat` files in the `matfiles` directory, the next step is to write a Julia function to import data for a user-selected network.

```julia
function loadcase(caseName::ASCIIString)
    matread("$(dirname(@__FILE__))/$(caseName).mat")["networkData"]
end
```
Recall from my [previous post][/_posts/2015-01-15-matpower-in-julia.md] that `@__FILE__` refers to the path of the file _in Julia's package directory_, not in the user's working directory. 

I included the function in a new package called "MatpowerCases", which I pushed to Github.

[1]: https://github.com/mlubin
[2]: https://github.com/simonster/MAT.jl
[3]: http://www.pserc.cornell.edu//matpower/