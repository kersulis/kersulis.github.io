---
layout: post
title: "Lagrange multiplier proof"
---

## Problem
Consider the following optimization problem:

<p>
\begin{align*}
&(P) &\min~ & z^\top C z - 2b^\top z & \\
& s.t. & z^\top z &= s^2
\end{align*}
</p>

In general, there are many solutions $\lambda$ to the first-order conditions:

<p>
\begin{align}
\label{eq:first1}Cz &= \lambda z + b \\
\label{eq:first2}z^\top z &= s^2
\end{align}
</p>
[Gander claims][1] that the objective of $(P)$ is minimized when the *smallest* value of $\lambda$ is chosen. The following Theorem formalizes this claim.

## Theorem
$(P)$ is equivalent to:

<p>
\begin{align*}
&(P') & \min~ & \lambda  \\
& s.t.& z^\top z &= s^2 \\
&& Cz &= \lambda z + b
\end{align*}
</p>

### Proof
We need a relationship between values of $\lambda$ in $(P')$ and objective values $O(z) = z^\top C z - 2b^\top z$ in $(P)$. The following Lemma accomplishes this purpose.

## Lemma
If $(\lambda\_1,z\_1)$ and $(\lambda\_2,z\_2)$ solve \eqref{eq:first1} and \eqref{eq:first2}, and $\lambda\_1 < \lambda\_2$, then

<p>
\begin{align*}
z_1^\top C z_1 - 2b^\top z_1 &< z_2^\top C z_2 - 2b^\top z_2~.
\end{align*}
</p>

### Proof
Multiply \eqref{eq:first1} by $z\_1^\top$ and $z\_2^\top$ for both $z\_1$ and $z\_2$, using \eqref{eq:first2} to replace instances of $z\_1^\top z\_1$ or $z\_2^\top z\_2$ by $s^2$:

<p>
\begin{align}
\label{eq:2a}z_1^\top C z_1 &= \lambda_1 s^2 + z_1^\top b \\
\label{eq:2b}z_2^\top C z_2 &= \lambda_2 s^2 + z_2^\top b \\
\label{eq:2c}z_1^\top C z_2 &= \lambda_2z_1^\top z_2 + b^\top z_1 \\
\label{eq:2d}z_2^\top C z_1 &= \lambda_1z_2^\top z_1 + b^\top z_2 \end{align}
</p>

Subtract \eqref{eq:2b} from \eqref{eq:2a} to obtain

<p>
\begin{align*}
(z_1^\top C z_1 - z_1^\top b) - (z_2^\top C z_2 - z_2^\top b) &= (\lambda_1 - \lambda_2)s^2~.
\end{align*}
</p>

Now add $b^\top z\_2$ and subtract $b^\top z\_1$ to yield

<p>
\begin{align*}
O(z_1) - O(z_2) &= (\lambda_1 - \lambda_2)s^2 - z_1^\top b + z_2^\top b~,
\end{align*}
</p>
where, by way of reminder, $$O(z)=z^\top C z - 2b^\top z$$ is the objective value corresponding to $z$ in $(P)$.

Substitute \eqref{eq:2c} and \eqref{eq:2d}:

<p>
\begin{align*}
O(z_1) - O(z_2) &= (\lambda_1 - \lambda_2)s^2 + (\lambda_2 - \lambda_1) z_1^\top z_2 \\
&=  (\lambda_1 - \lambda_2)(s^2 - z_1^\top z_2)
\end{align*}
</p>

Note that $$\lVert z\_1 - z\_2 \rVert = z\_1^\top z\_1 + z\_2^\top z\_2 - 2z\_1^\top z\_2 = 2s^2 - 2z\_1^\top z\_2~,$$ so we have:

<p>
\begin{align*}
O(z_1) - O(z_2) &= \frac{1}{2}(\lambda_1 - \lambda_2)\lVert z_1 - z_2 \rVert
\end{align*}
</p>

Because $\lambda\_1 < \lambda\_2$, the right-hand size is negative. The objective value corresponding to $z\_1$ is therefore less than that of $z\_2$.

This relationship between values of $\lambda$ in (P') and values of $O(z)$ in (P) is sufficient to prove our Theorem.

## Significance
If we know that the smallest feasible value of $\lambda$ in $(P')$ corresponds to the optimal $z$ in $(P)$, then we can ignore all other solutions to \eqref{eq:first1} and \eqref{eq:first2}. To obtain all those solutions, we would need to solve the slipper secular equation, which looks something like this:

<img src={{ site.baseurl }}images/secular.svg>

Finding all intersections between the curve and the horizontal line is difficult in general. Finding only the leftmost intersection is simple. The curve is monotonically increasing on $(-\infty,p\_1)$, where $p\_1$ is the leftmost pole.

[1]: http://e-collection.library.ethz.ch/eserv/eth:3179/eth-3179-01.pdf?pid=eth:3179&dsID=eth-3179-01.pdf
