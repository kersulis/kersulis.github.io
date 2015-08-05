---
layout: post
title: Power System Data Format
image: 
color: white
---

For some time I have wanted to describe a power system programmatically using Julia. I need only put together pieces others have designed.

Jon gave me a power system data format used by Mads. This format is much more structured and flexible than [MATPOWER's caseformat][1] (which is plaintext).

## What will this be?
Every time I need to work with a power network, I want to know exactly where each piece of network data comes from and what it means. I want one object that fully characterizes a power network. I'll call this object `pn`. This object will have many nested fields.

```julia
baseMVA
bus
gen

```

## Friday, June 19, 2015

My goal for this afternoon is to perform temporal instanton analysis on a power system stored in my new data structure.

I also need to decide whether DataFrames are a better way to go.


[1]: http://www.pserc.cornell.edu//matpower/docs/ref/matpower5.1/caseformat.html