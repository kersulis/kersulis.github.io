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

I generated Sankey diagrams to illustrate clique merge algorithm behavior for two test networks. Try clicking on a rectangle to trace a node, clique, or merged group backwards and forwards through the algorithm.
- [IEEE 30-bus test case][1]. This small network is ideal for introducing the Sankey diagram.
- [PEGASE 89-bus test case][2]. This larger network illustrates the outsized role played by a handful of nodes and cliques.


### Footnotes
[^1]: In a chordal graph, any path of length four or greater has a *chord*, which is an edge connecting non-adjacent nodes in the path.
[^2]: There is a linear-time algorithm for identifying the maximal cliques of a chordal graph.

[1]: {{ site.baseurl }}images/clique-merge-case30/
[2]: {{ site.baseurl }}images/clique-merge-case89/
[3]: http://ieeexplore.ieee.org/document/6510541/
[4]: http://faculty.cse.tamu.edu/davis/suitesparse.html
[5]: https://networkx.github.io/
