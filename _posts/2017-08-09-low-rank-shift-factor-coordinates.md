---
layout: post
title: Low-rank shift factors and electrical coordinates
---

<script src="https://www.w3schools.com/lib/w3.js"></script>

# Low-rank shift factors and electrical coordinates
_2D embedding of electrical coordinates illustrates low-rank approximation of injection shift factors_

Consider Figure 2 in [this paper][1] by Cuffe and Keane. The authors use [injection shift factors][3] to derive electrical distances. The electrical distance between nodes $i$ and $k$ is taken to be the sum of absolute values of all power flows induced in the network when 1 pu of active power is injected at $i$ and withdrawn at $k$. Having compiled all pairwise distances in a matrix, the authors then use [multidimensional scaling][2] to obtain 2D "electrical coordinates" for each bus. These coordinates may be plotted, and lines representing transmission lines may be added. The result is an electrically meaningful graph depiction of a power system.

Jon Martin (who was in my research group until he defended last year) noticed the sparsity of injection shift factors as he wrapped up his research. Pick a line in the network, and look at the sensitivity of its flow to injections at all buses. You will likely find that most sensitivities are tiny, but there are a couple with large magnitude. This suggests that the shift factor matrix is well-approximated by a low-rank matrix. To test this hypothesis, let's combine SVD-based dimensionality reduction with the graph drawing procedure described in the previous paragraph, focusing on the [IEEE 30-Bus system][4] just like Cuffe and Keane did. Because the system has 30 nodes, the shift factor matrix $A$ has 30 singular value components. For $k\in[1,30]$, do the following:

1. Let $U, S, V = \text{SVD}(A)$. A scatterplot of $\text{diag}(S)$ shows that a large portion of the sum of singular values is captured by the first 10 values:
<img src="{{ site.baseurl }}images/ieee30-isf-svd.svg">
2. Compute a rank-$k$ approximation of $A$: $ A_k = U[:, 1:k]\cdot S[1:k, 1:k]\cdot V[:, 1:k]^\top $
3. Derive a distance matrix $D_k$ from $A_k$ by summing the flows induced for a 1 pu injection and withdrawal at each pair of buses.
4. Perform multidimensional scaling to obtain electrical coordinates $X_k$ for all nodes.
5. Perform [Procrustes analysis][5] to align $X_k$ with $X_{k-1}$ (rotation is an extra degree of freedom in multidimensional scaling).

After performing the steps listed above, one can obtain the figures shown below. Use the buttons to flip through values of $k$. The top subfigure is a heatmap of $A_k$; at bottom is a graph visualization of $X_k$. Note that the high-voltage portion of IEEE 30 is designated by thicker lines.

<div style="margin: auto; width: 40%">
<button onclick="SlideShow.previous()"><</button>
<button onclick="SlideShow.next()">></button>
<button onclick="SlideShow.display(1)">k=1</button>
<button onclick="SlideShow.display(2)">k=2</button>
<button onclick="SlideShow.display(11)">k=11</button>
<button onclick="SlideShow.display(29)">k=29</button>
</div>
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/1.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/2.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/3.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/4.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/5.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/6.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/7.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/8.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/9.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/10.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/11.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/12.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/13.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/14.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/15.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/16.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/17.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/18.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/19.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/20.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/21.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/22.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/23.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/24.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/25.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/26.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/27.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/28.png" style="width: 70%; margin: auto">
<img class="slideshow" src="{{ site.baseurl }}images/isf-reduction/29.png" style="width: 70%; margin: auto">

<script>
SlideShow = w3.slideshow(".slideshow", 0);
</script>

A few observations:

- $X_1$ effectively places the nodes in a line; this is a 1D embedding of electrical distance. Note that the high-voltage portion of the grid (the "transmission backbone" already jumps out here).
- By the time we reach $X_5$, a great deal of the final structure is present.
- There is little qualitative difference between $X_{10}$ and $X_{29}$. Flipping between the two, we see that the last two features to be resolved are the separation between nodes 29 and 30 and the length of line $9-11$. Setting those relatively insignificant features aside, the graph possesses its final structure by $X_{10}$ (or even a little earlier).
- There is an intuitive explanation for shift factor sparsity: each line in the network is electrically close to just a few nodes. Most nodes are electrically distant, and are therefore unable to easily alter the line's flow.

IEEE 30 is one of many commonly-used test networks. It may prove interesting to repeat this analysis for a collection of larger networks and look for trends.

[1]: http://ieeexplore.ieee.org.proxy.lib.umich.edu/document/7109118/
[2]: https://en.wikipedia.org/wiki/Multidimensional_scaling
[3]: {{ site.baseurl }}2015/10/28/injection-shift-factors/
[4]: http://icseg.iti.illinois.edu/ieee-30-bus-system/
[5]: https://en.wikipedia.org/wiki/Procrustes_analysis
