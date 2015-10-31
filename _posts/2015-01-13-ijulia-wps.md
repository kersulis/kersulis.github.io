---
layout: post
title: Julia and IJulia at the Winter Power School
image: santafe.jpg
color: white
---
<img src="{{ site.baseurl }}images/wps.jpg" width="400" style="float: right; width: 35%; margin-right: 1%; margin-bottom: 0.5em; margin-left: 0.5em">
_The [Winter Power School][wps] is a recurring event sponsored by the [Center for Nonlinear Studies](http://cnls.lanl.gov) at [Los Alamos National Lab](http://lanl.gov). The goal is to teach important concepts in power and energy to a diverse group of students spanning the systems, controls, and optimization fields. The format is a three-day lecture series followed by a two-day conference with poster session._

This year I worked with [Miles Lubin][miles] and [Yury Dvorkin][yury] to host a series of interactive Julia sessions at the Winter Power School. In particular, I hosted the first session and developed the [Session 1 IJulia notebooks][sess1]. Here's what I learned.

## Have a goal

Going into the session, I had one goal: make everyone in the room comfortable with Julia and the IJulia notebook. The first notebook focused exclusively on the basics, while the last three contained an overview of my research. With my goal in mind, I happily devoted an extra half-hour to the first notebook. It was more important to familiarize everyone with the tools they would in the remaining sessions than to show them my research (there will be other opportunities for that).

## Get the pace right

Our original plan was to spend ten minutes talking about the Julia langauge, forty-five minutes on the first Session 1 notebook, and the remaining hour on the other three notebooks. In the end, I covered the first notebook in detail and could only skim the rest before running out of time. Part of this huge gap between expectation and reality is due to my inexperience. But the gap is also a function of the audience. This audience contained optimization gurus who are comfortable writing production C code, but it also contained researchers who spend far less time programming. One bit of feedback I got after the session was, "Everyone who was going to be engaged was engaged." Others told me they also thought the pacing felt right. Had I moved any faster, I would have alienated members of the audience who were genuinely interested in learning. Any slower and I would have made more people fall asleep. (Yes, a couple people fell asleep, but in my defense this was the 4-6 PM session preceding dinner.)

## Rehearse

I practiced some, but did not have a full rehearsal before the session. As a result, I messed up some details and confused people. Fortunately, Miles picked up on these missing details and clarified for the audience. In-place modification was one thing I did not explain adequately enough. Here is the exercise I assigned to everyone:

{% gist 6661787e73041d0d7ea2 %}

For an audience with many non-programmers, this introduction to in-place modification was sorely lacking. (I didn't understand the concept myself until I invested twenty minutes into it.) It is easy to drop your audience into the deep end without realizing it. The best way to avoid this is to practice on someone with a representative background. My session would have benefited enough from a rehearsal to justify the time it would have taken.

[wps]: http://www.cvent.com/events/grid-science-winter-school-conference/event-summary-229c17f488194f2ebb5b206820974c71.aspx
[miles]: http://www.mit.edu/~mlubin/
[yury]: http://students.washington.edu/dvorkin/
[sess1]: https://github.com/kersulis/IJulia-WPS/tree/master/Session%201
