---
layout: post
title: MATPOWER Network Data in Julia, Take Two
image: matpowercases2.png
---
<!-- color: cornflowerblue -->
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
Recall from my [previous post]({{ site.baseurl }}2015/01/15/matpower-in-julia) that `@__FILE__` refers to the path of the file _in Julia's package directory_, not in the user's working directory. 

I included the function in a new package called "MatpowerCases", which I pushed to Github. It is now possible for anyone to load caseformat transmission network data into Julia using:

```julia
Pkg.clone("https://github.com/kersulis/MatpowerCases.jl.git")
using MatpowerCases

networkData = loadcase("case118")
```

___

**Update (2015-01-29)**: MatpowerCases is now a registered package.  :)

<blockquote class="twitter-tweet" lang="en"><p>Just got my first <a href="https://twitter.com/JuliaLanguage">@JuliaLanguage</a> package registered! Use Pkg.add(&quot;MatpowerCases&quot;) to install it.&#10;<a href="https://t.co/2K9gmWkoSi">https://t.co/2K9gmWkoSi</a></p>&mdash; Jonas Kersulis (@TonyKersulis) <a href="https://twitter.com/TonyKersulis/status/560923618150862848">January 29, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[1]: https://github.com/mlubin
[2]: https://github.com/simonster/MAT.jl
[3]: http://www.pserc.cornell.edu//matpower/