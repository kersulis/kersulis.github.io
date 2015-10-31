---
layout: post
title: "Lagrange multiplier proof"
---

## Problem
Consider the following optimization problem:

$$
\begin{align*}
&(P) &\min~ & z^\top C z - 2b^\top z & \\
& s.t. & z^\top z &= s^2
\end{align*}
$$

In general, there are many solutions $\lambda$ to the first-order conditions:

$$
\begin{align}
\label{eq:first1}Cz &= \lambda z + b \\
\label{eq:first2}z^\top z &= s^2
\end{align}
$$

[Gander claims][1] that the objective of $(P)$ is minimized when the *smallest* value of $\lambda$ is chosen. The following Theorem formalizes this claim.

## Theorem
$(P)$ is equivalent to:

$$
\begin{align*}
&(P') & \min~ & \lambda  \\
& s.t.& z^\top z &= s^2 \\
&& Cz &= \lambda z + b
\end{align*}
$$

### Proof
We need a relationship between values of $\lambda$ in $(P')$ and objective values $O(z) = z^\top C z - 2b^\top z$ in $(P)$. The following Lemma accomplishes this purpose.

## Lemma
If $(\lambda_1,z_1)$ and $(\lambda_2,z_2)$ solve \eqref{eq:first1} and \eqref{eq:first2}, and $\lambda_1 < \lambda_2$, then

$$
\begin{align*}
z_1^\top C z_1 - 2b^\top z_1 &< z_2^\top C z_2 - 2b^\top z_2~.
\end{align*}
$$

### Proof
Multiply \eqref{eq:first1} by $z_1^\top$ and $z_2^\top$ for both $z_1$ and $z_2$, using \eqref{eq:first2} to replace instances of $z_1^\top z_1$ or $z_2^\top z_2$ by $s^2$:

$$
\begin{align}
\label{eq:2a}z_1^\top C z_1 &= \lambda_1 s^2 + z_1^\top b \\
\label{eq:2b}z_2^\top C z_2 &= \lambda_2 s^2 + z_2^\top b \\
\label{eq:2c}z_1^\top C z_2 &= \lambda_2z_1^\top z_2 + b^\top z_1 \\
\label{eq:2d}z_2^\top C z_1 &= \lambda_1z_2^\top z_1 + b^\top z_2 \end{align}
$$

Subtract \eqref{eq:2b} from \eqref{eq:2a} to obtain

$$
\begin{align*}
(z_1^\top C z_1 - z_1^\top b) - (z_2^\top C z_2 - z_2^\top b) &= (\lambda_1 - \lambda_2)s^2~.
\end{align*}
$$

Now add $b^\top z_2$ and subtract $b^\top z_1$ to yield

$$
\begin{align*}
O(z_1) - O(z_2) &= (\lambda_1 - \lambda_2)s^2 - z_1^\top b + z_2^\top b~,
\end{align*}
$$
where, by way of reminder, $$O(z)=z^\top C z - 2b^\top z$$ is the objective value corresponding to $z$ in $(P)$.

Substitute \eqref{eq:2c} and \eqref{eq:2d}:

$$
\begin{align*}
O(z_1) - O(z_2) &= (\lambda_1 - \lambda_2)s^2 + (\lambda_2 - \lambda_1) z_1^\top z_2 \\
&=  (\lambda_1 - \lambda_2)(s^2 - z_1^\top z_2)
\end{align*}
$$

Note that $$\lVert z_1 - z_2 \rVert = z_1^\top z_1 + z_2^\top z_2 - 2z_1^\top z_2 = 2s^2 - 2z_1^\top z_2~,$$ so we have:

$$
\begin{align*}
O(z_1) - O(z_2) &= \frac{1}{2}(\lambda_1 - \lambda_2)\lVert z_1 - z_2 \rVert
\end{align*}
$$

Because $\lambda_1 < \lambda_2$, the right-hand size is negative. The objective value corresponding to $z_1$ is therefore less than that of $z_2$.

This relationship between values of $\lambda$ in (P') and values of $O(z)$ in (P) is sufficient to prove our Theorem.

## Significance
If we know that the smallest feasible value of $\lambda$ in $(P')$ corresponds to the optimal $z$ in $(P)$, then we can ignore all other solutions to \eqref{eq:first1} and \eqref{eq:first2}. To obtain all those solutions, we would need to solve the slipper secular equation, which looks something like this:

<img src="{{ site.baseurl }}images/secular.svg">

Finding all intersections between the curve and the horizontal line is difficult in general. Finding only the leftmost intersection is simple. The curve is monotonically increasing on $(-\infty,p_1)$, where $p_1$ is the leftmost pole.

[1]: http://e-collection.library.ethz.ch/eserv/eth:3179/eth-3179-01.pdf?pid=eth:3179&dsID=eth-3179-01.pdf
