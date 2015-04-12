---
layout: post
title: How Distributed Slack Works
---

DC Power flow analysis keeps track of bus injections and node angles. Before performing analysis, it is important to select an "angle reference node" and fix its angle to zero. Without the angle reference node, angles at all other buses are meaningless. An angle can only be interpreted relative to some angle reference.

Sometimes the angle reference node is also designated the "slack node". This means it takes up the mismatch between total power generated and total power demanded. (Note that the slack node must have a generator to compensate for under-generation overall.)

The use of a single slack node does not jibe with reality. It is never the case that a single generator compensates for all mismatch throughout the system. Instead a group of generators work together to divide the mismatch according to "participation factors". Suppose there is a mismatch of +6 pu, and three generators are participating in distributed slack. These generators must decrease their generation to compensate for the 6 pu surplus, which we will call $\alpha$. The response is as follows:

\begin{align}
G_1^{new} &= G_1^0 + k_1\alpha \\
G_2^{new} &= G_2^0 + k_2\alpha \\
G_3^{new} &= G_3^0 + k_3\alpha
\end{align}

The participation factors determine which fraction of the mismatch $\alpha$ will be taken by each generator; they must sum to 1. Suppose Generator 1 has a participation factor of $\frac{1}{6}$, Generator 2 has a participation factor of $\frac{1}{3}$, and Generator 3 has a participation factor of $\frac{1}{2}$. Then the generators will reduce their output by 1 pu, 2 pu, and 3 pu, respectively.

Distributed slack is independent of the choice of angle reference. A generator at the angle reference node may or may not participate in distributed slack. In fact, the angle reference bus need not have a generator at all. There are at least two ways to express the power balance equations when distributed slack is in play. The first and simplest is to have an explicit equation establishing the angle reference node. The power balance equations in this case are:

\begin{align}
\begin{bmatrix} Y & -k \\ e_s & 0 \end{bmatrix} \begin{bmatrix}\theta \\ \alpha \end{bmatrix} &= \begin{bmatrix} G - D \\ 0 \end{bmatrix}
\end{align}

There are $n$ equations establishing power balance, each of the form $$ \sum_k Y_{ik}\theta_k = G_i + k_i\alpha - D_i $$. The last equation establishes the angle reference: $\theta_s = 0$.