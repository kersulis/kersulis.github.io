---
layout: page
title: Research
color: "#003366"
---

# Research and Publications

## Load-tap-changing (LTC) transformer trade-off
### Background
See [this presntation][4] for an overview. Load-tap-changing (LTC) transformers perform voltage control in subtransmission and distribution systems throughout the day. Renewable fluctuation can result in excessive tapping, leading to premature breakdown for these critical and expensive devices. Prior literature suggested reactive power compensation as a viable solution. Indeed, local voltage regulation at a wind farm will keep downstream distribution LTCs from having to offset fluctuation. But we show that this policy has an adverse side-effect: reactive power fluctuations must be compensated upstream, resulting in subtransmission LTC tapping. A simple toy network illustrates the trade-off between subtransmission and distribution tapping, and we discuss the optimal renewable voltage regulation policy.

### Output
- **Conference paper:** J.A. Kersulis, I.A. Hiskens, "Renewable Voltage Regularion and the Transformer Tapping Trade-off," in Innovative Smart Grid Technologies Asia 2016, 2016, pp. 1-6.
> Load-tap-changing (LTC) transformers provide voltage regulation in subtransmission and distribution networks, but these expensive devices can only tap so many times before they fail. Fluctuations due to renewable energy can cause excessive tapping, accelerating aging. We address the question of how voltage regulation at renewable sources influences tapping frequency. In particular, we show that loose regulation results in excessive downstream (distribution) transformer tapping, while tight regulation causes upstream (subtransmission) tapping. We use yearlong simulations of a simple test network to generate tap trajectories and trade-off curves, illuminating the trade-off between subtransmission and distribution transformer wear. The paper concludes with a description of future work based on joint minimization of upstream and downstream tapping operations.

- **Poster:** [Engineering Graduate Symposium 2016][1].

## Temporal generation deviation patterns

### Background
See [this presentation for an overview][3]. Uncertainty introduced by wind and solar generation leads to unpredictability in transmission network operation. Any wind or solar forecast is subject to relatively high inaccuracy, so an important question is *what are the smallest deviations from a forecast that would cause operational problems?* Our approach uses optimization to minimize the size of forecast deviation (small deviations are most likely to occur) subject to the constraint that some transmission line reaches an excessive temperature. The objective is quadratic. The DC power flow approximation renders power flow constraints linear, but there is no way to model line temperature in terms of first-order angle differences. Thus, there is a quadratic constraint, and we must solve a non-convex quadratically-constrained quadratic program. We show how to solve this problem by applying a series of transformations, solving a simple system, and reversing the solution back into the original problem space.

The output of our algorithm is a ranked list of forecast deviations, each of which is the smallest deviation that will bring a particular line in the system to its temperature limit. Operators can use this information to assess grid vulnerability to wind and solar fluctuations.

### Output
- **Conference paper:** J. Kersulis, I. Hiskens, M. Chertkov, S. Backhaus, and D. Bienstock, "Temperature-based instanton analysis: Identifying vulnerability in transmission networks," in PowerTech, 2015 IEEE Eindhoven, 2015, pp. 1–6.
> A time-coupled instanton method for characterizing transmission network vulnerability to wind generation fluctuation is presented. To extend prior instanton work to multiple-time-step analysis, line constraints are specified in terms of temperature rather than current. An optimization formulation is developed to express the minimum wind forecast deviation such that at least one line is driven to its thermal limit. Results are shown for an IEEE RTS-96 system with several wind-farms.

- **Journal article:** J.A. Kersulis, I.A. Hiskens, "Fast Scanning for Minimal Wind Deviations That Induce Temporal Line Overload," en route to IEEE Transactions on Power Systems.
> A previously-developed method for studying a transmission network's vulnerability to wind forecast inaccuracy is expanded. The method uses optimization to find a likely wind generation pattern that brings a specified line to an unacceptably high temperature. The objective quantifies wind pattern likelihood in terms of distance from the forecast, respecting spatial and temporal correlation between wind sites and time intervals. The set of constraints enforces power balance and ensures a chosen line in the network reaches a fixed temperature by the final time step. The thermal constraint is second-order in voltage angle differences, and is based on a DC-approximate line loss formulation. Repeatedly solving the QCQP for all lines in the network yields a set of instanton candidate generation patterns, which may then be sorted by likelihood. Having described the temporal instanton QCQP and its solution, the paper turns to a discussion of implementation details. Finally, a series of numerical experiments is presented. These experiments demonstrate the effect of an instanton pattern on line temperature trajectory, the effects of wind covariance on instanton analysis, and algorithm scaling properties.

- **Poster:** [Engineering Graduate Symposium 2015][2]

[1]: {{ site.baseurl }}docs/mintap_egs_2016_poster.pdf
[2]: {{ site.baseurl }}docs/instanton_egs_2015_poster.pdf
[3]: http://kersulis.github.io/presentations/498lecture
[4]: http://kersulis.github.io/presentations/498lecture2
