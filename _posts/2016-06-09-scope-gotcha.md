---
layout: post
title: "A tough scope lesson in Julia"
---

# A tough scope lesson in Julia
_A subtle gotcha one might encounter when attempting to modify a function's input arguments_

I've been working on powerflow code the past couple days. My new routine is hardly the first powerflow I've worked on since entering my PhD program, but it has a key advantage over my previous efforts: it overwrites input arguments to avoid memory allocation.[^1] This can make a dramatic difference in the time it takes to perform the half-million sequential power flows required to simulate a network each minute for a year.

Unfortunately, my new powerflow routine misbehaved, and I spent an hour pulling my hair out before identifying the gotcha. Experienced Julia coders may find this trap obvious, but I thought it was subtle enough to merit a quick post.

## The gotcha
What does the following function do to its input arguments?

```julia
function test!(A::Vector, B::Vector)
    A = fill(0, 2)
    B[:] = fill(0, 2)
    nothing
end
```

Looks like it fills `A` with two 0s, then fills `B` with two 0s. `B[:]` simply refers to all the elements of `B`, so it seems redundant. Unfortunately for my afternoon productivity, there's actually a fundamental difference between the two statements. Let's test `test!`:

```julia
A = fill(1, 2)
B = fill(1, 2)
test!(A, B)

@show(A)
@show(B);
```

Output:

    A = [1,1]
    B = [0,0]


Huh. `A` and `B` both started out as `[1,1]`. After the function call, `A` was not modified, but `B` was. Why?

## Explanation

When the variables are declared, each points to a certain memory location. That location marks the start of the vector's contents. Here's what the two statements in `test!` do:

* `A = fill(0, 2)` causes the variable `A` to point to a _different memory location_, and places a vector of 0s at that location. This change is local to the function, however, so the variable `A` declared outside the function _still points to its original location_ after `test!` is run.
* `B[:] = fill(0, 2)` tells Julia to go to the memory location associated with `B`, then change elements of the vector _at that memory location_ to 0s.

To drive this point home, let's have `test!` return the pointers of `A` and `B` after it acts on them:

```julia
function test!(A::Vector, B::Vector)
    A = fill(0, 2)
    B[:] = fill(0, 2)
    return pointer(A), pointer(B)
end
```

The following script determines whether `test!` modifies each variable's pointer (or memory location):

```julia
A = fill(1, 2)
B = fill(1, 2)
pA_out = pointer(A)
pB_out = pointer(B)
pA_in, pB_in = test!(A, B)

@show(pA_out == pA_in)
@show(pB_out == pB_in);
```

Output:

    pA_out == pA_in = false
    pB_out == pB_in = true


`pA_out` (the pointer of `A` outside the function) differs from `pA_in` (the one inside). This is evidence that the statement `A = fill(0, 2)` causes `A` to point to a different memory location, but only inside the function. By contrast, the statement `B[:] = fill(0, 2)` does not change the pointer of `B`. So it's the same memory location inside the function and outside.

## Lesson learned
Like many of Julia's subtleties, this discovery resulted in frustration followed by understanding. Variables point to memory locations, which contain the actual data. Julia makes two kinds of modification possible: you can alter the data at a certain location, or you can make a variable name point to a different location entirely. So a variable that points to a vector (or matrix, etc.) is like a container. You can reach inside to change certain items (`B[:] = ...`), or you can toss all the items out to get a clean container (`A = ...`).

Next time you would like to modify a function's input arguments, make sure you are reaching inside the container rather than locally replacing one container with another.

___

### Footnotes
[^1]: I know, this is one of the first things someone should consider when coding things like Newton's method. It's a shame I didn't focus on it earlier; simulations I've done in the past would have gone dramatically faster. My excuse: I learned a lot of anti-patterns during the old MATLAB scripting days, and nobody ever told me to profile my code. Better late than never, I suppose.
