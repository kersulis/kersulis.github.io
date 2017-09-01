---
layout: post
title: Maximal cliques and SDP performance
---

# Maximal cliques and Semidefinite programming (SDP) performance
_Merging cliques to reduce problem size_

## Introduction
Recent advances have made it possible to solve common power system problems like optimal power flow (OPF) using semidefinite programming (SDP). Because modern SDP solvers work best when the rank constraint matrix is no larger than a few dozen elements to a side, an important step in current techniques is decomposition of the full rank constraint matrix (which has dimension $2n\times 2n$ for a power system with $n$ buses). The matrix completion theorem used in [molzahn2013][3] and other works governs valid decompositions. Suppose we have an undirected chordal graph[^1] and an associated incomplete matrix $A$. Then $A$ can be completed to a positive semidefinite matrix if and only if all submatrices associated with the graph's maximal cliques are positive semidefinite.

The completion theorem leads to an rank constraint decomposition. First, if the power system graph is not chordal, a chordal extension must be formed. Second, the maximal cliques must be found[^2]. Each of these cliques has an associated submatrix of the full rank constraint matrix $A$. Finally, the original rank constraint may be replaced by rank constraints on the clique submatrices. Unfortunately, one node in a power system may belong to many maximal cliques. Each clique the node belongs to has its own copy of that node's variables (real and reactive voltage components in OPF), but these variables ultimately can have only one value in the end. Thus, maximal clique decomposition introduces a set of linking constraints that varies with the amount of overlap between cliques.

Most SDP solvers apply primal-dual methods, so a primal linking constraint corresponds to a dual variable. It makes sense, therefore, to consider the sum of scalar variables and linking constraints when characterizing problem size for an SDP with decomposed rank constraint. Molzahn et al. [molzahn2013][3] found that merging cliques may reduce the overall problem size and improve SDP performance. To that end, they proposed a greedy clique merging algorithm. At each step, this algorithm identifies the pair of cliques whose merger would yield the greatest reduction in the sum of variables and linking constraints, and merges them. The algorithm stops when a desired number of submatrices, $L$, is reached. With their results, Molzahn et al. show that SDP solver time gradually decreases as $L$ shrinks (i.e. as more cliques are merged). If $L$ becomes too small, however, the submatrices grow large, and this outweighs reductions in the number of linking constraints.

Clique merging can have a profound effect on SDP behavior. It is inexpensive to compute power system graph chordal extensions and their maximal cliques. Lately I've been studying clique composition of power systems, with the eventual goal of efficiently predicting SDP solver performance.

## Implementation
The matrix completion theorem applies only to chordal graphs. Power system graphs are not necessarily chordal, so our first consideration is chordal extension. The authors of [molzahn2013][3] use a sparsity-preserving Cholesky factorization to obtain a chordal extension with as few edges as possible. I translated Dr. Molzahn's MATLAB code into Python, using [CHOLMOD][4] for Cholesky factorization.

To identify the maximal cliques of our chordal graph extension, I used [NetworkX][5]'s linear-time algorithm. From here, I can generate a clique tree. Nodes in this tree represent cliques, edges connect cliques that share nodes, and the weight of each edge is the number of nodes shared by its endpoint cliques. Because the greedy clique merge algorithm will always merge cliques with the greatest overlap, it is sufficient to consider the minimum-weight spanning tree of our clique graph. NetworkX provides a convenient means of obtaining this tree.

From here, implementation of the clique merge algorithm is straightforward. Because each voltage has real and complex components, a group of $n$ nodes corresponds to $n\cdot(2n+1)$ cliques, and an overlap of $n$ nodes corresponds to $n\cdot(2n+1)$ linking constraints. At each step, the algorithm works through all edges in the clique graph minimal spanning tree. Using the clique sizes and edge weight, it computes the sum of variables and constraints before and after a potential merge. The merge corresponding to lowest $\Delta$ value is implemented. It is important to note that not every merge will reduce the problem size overall; at some point during execution, the algorithm's merges will have an adverse effect on problem size, as submatrices grow too large.

## Results
Rather than fixing a desired number of submatrices (denoted $L$ in [molzahn2013][3]), I use visualization techniques to show algorithm behavior from start to finish. The starting point for the algorithm is the set of maximal cliques, and the final merge yields a single group containing all nodes. This hierarchical clustering may be effectively visualized using a dendrogram or Sankey (alluvial) diagram.

### Dendrograms
A dendrogram (from the Greek *tree* + *drawing*) is perhaps the most common hierarchical clustering visualization tool. The nodes or smallest clusters (cliques in our case) lie along the bottom of the dendrogram, each having its own vertical line. As we follow a clique's vertical line upwards, we encounter a horizontal line representing a merge. The vertical axis value at this line indicates the change in number of variables due to that merge. The figure below illustrates application of the greedy clique merge algorithm to a chordal extension of the IEEE 30-bus test case.

<img src="{{ site.baseurl }}images/dendrogram-case30.svg">

Because we are most interested in merges that reduce overall problem size, the vertical axis is cut off. The first merge performed by the algorithm combines the clique containing nodes 26, 27, 28, and 30 with the clique that contains nodes 27, 28, 29, and 30. These maximal cliques share three nodes, so their merger eliminates many linking constraints. As we move up the dendrogram, we see many merges that reduce the number of variables by 10-15. When we reach the point where merges no longer reduce the number of variables, 12 clusters remain.

Of the four clusters at the top of the figure, let's consider the rightmost one. Eleven of the twenty-six maximal cliques ultimately merge into this cluster, including the two largest ones. Vertical axis values for merges in this branch are also more staggered than for the other three. This suggests that the rightmost branch corresponds to a power grid "backbone" consisting of many large and overlapping maximal cliques. Other test cases exhibit similar behavior. Consider the dendrogram below, which shows clique merge behavior for a chordal extension of the 89-bus PEGASE test case. This time the middle branch contains the "backbone" and first several merges (colored magenta), which involve large cliques with significant overlap.

<img src="{{ site.baseurl }}images/dendrogram-case89.svg">

### Sankey diagrams
Dendrograms may effectively illustrate hierarchical clustering, but alluvial diagrams excel at depicting evolution of networks over time. The Sankey diagram belongs to this family, and is particularly useful for studying clique merge algorithm behavior. We will use Sankey diagrams to address the following dendrogram shortcomings:

- Each horizontal line can represent a merge of only two groups, so a dendrogram cannot illustrate division of nodes into cliques. A Sankey diagram lets me visualize the number of cliques each node belongs to.
- While we can see which clusters belong to each merge by glancing down the dendrogram, it can be difficult to keep track of the size of each merge. A Sankey diagram represents cluster size via rectangle height.
- Because the last few merges add so many variables, it is difficult to show the full dendrogram without obscuring the first set of merges. To emphasize merges that reduce SDP problem size, I had to truncate the dendrograms. The Sankey diagram allows me to represent change in number of variables using color instead of vertical position, so I can show every merge.

Consider [this Sankey diagram][1], which represents greedy clique merge for a chordal extension of the IEEE 30-bus test case. The leftmost set of rectangles, labeled "Bus x" and colored blue, represent buses. The size of each rectangle corresponds to the number of cliques each bus belongs to. The orange set of rectangles to the right, labeled "Clique x", represent maximal cliques. The size of each orange rectangle reflects the number of buses in it. All remaining rectangles represent merges, and are colored using a green/red spectrum. The most noticeable difference between this Sankey diagram and our dendrogram from earlier is that the latter captures all merges. The first merge reduces problem size by 38, while the final merge (Merge 25, which contains all nodes) adds 568 variables. Also noteworthy are the sizes of the blue bus rectangles, from which we see that buses 27 and 28 belong to 9 and 10 maximal cliques, respectively.

Sankey diagrams for larger networks are qualitatively similar. Consider [this diagram][2], which depicts greedy clique merge behavior for a chordal extension of the PEGASE 89-bus test case. Once more we see that there are a few key nodes that belong to many cliques. Bus 76, for example, belongs to 24 of the 75 maximal cliques. We also see a set of beneficial merges involving a subset of large, overlapping maximal cliques. To show this more clearly, **try clicking the rectangle for Clique 12 to highlight all paths it is involved in**. Merges 1-4, which provide the greatest reduction in problem size, combine Clique 12 with a few other cliques that share several nodes. Click on Clique 12 again to deselect it, and try clicking on other groups and nodes to see their role in the algorithm's behavior.

## Conclusions
In this post I applied two visualization techniques to the greedy clique merge algorithm proposed in [molzahn2013][1]. First, I used dendrograms to illustrate hierarchical clustering of cliques. Then I used Sankey diagrams to better show merge sizes and the roles individual cliques and buses play. While these diagrams illuminate behavior of the clique merge algorithm for small networks, data-driven methods are required for studying larger ones. We close with some ideas for future work.

- Compare clique merge behavior with clique composition for [NESTA][6] cases.
- Plot merge gaps (dendrogram vertical axis values) for all NESTA cases and look for patterns.
- Run clique merge on all NESTA networks, but terminate once merges no longer reduce problem size. Might the state of the algorithm at that point be connected to system structure? What is the number of submatrices at this termination point for NESTA networks, and how large are they? Do these properties scale with network size?

### Footnotes
[^1]: In a chordal graph, any path of length four or greater has a *chord*, which is an edge connecting non-adjacent nodes in the path.
[^2]: There is a linear-time algorithm for identifying the maximal cliques of a chordal graph.

[1]: {{ site.baseurl }}images/clique-merge-case30/
[2]: {{ site.baseurl }}images/clique-merge-case89/
[3]: http://ieeexplore.ieee.org/document/6510541/
[4]: http://faculty.cse.tamu.edu/davis/suitesparse.html
[5]: https://networkx.github.io/
[6]: https://www.researchgate.net/publication/267759575_NESTA_The_NICTA_Energy_System_Test_Case_Archive
