---
layout: post
title: "Julia Snippet: Injection Shift Factors"
color: white
---

# Injection Shift Factors
Yesterday I needed to calculated DC injection shift factors. Jon gave me a nice introduction to the concept and generalized to the generator droop response case (with arbitrary participation factors).

I wrote the following function to compute an injection shift factor matrix for DC power flow, with and without participation factors.

{% gist db706e35667152739a18 %}
