+++
title = "Pursuit Curves in Julia"
date = Date(2020, 6, 10)
hascode = true
hasmath = true
tags = ["Julia"]
+++

{{pageheader}}

Imagine the path of a fox chasing a rabbit. A simple pursuit strategy (but by no means the best) would consist of the fox constantly moving in the direction of the rabbit at full speed. The path traced out by this fox belongs to a family of curves aptly named pursuit curves. The exact trajectory that the fox takes depends on the path that the rabbit takes, the starting positions of each animal, and the relative speed between the fox and rabbit.

The position of the rabbit through time is the vector $R(t)$, and the position of the fox through time is the vector $F(t)$. For the sake of simplicity, the rabbit takes a predefined trajectory and has a constant speed of 1. The fox's speed is some multiple, $k$, of the rabbit's speed. The governing differential equation of this pursuit curve is below. The differential equation is tell us that every instant in time, we are updating the fox's velocity, $F'$, to point in the direction of the rabbit. The unit vector pointing from the fox and to the rabbit is $R-F/|R-F|$. We scale this unit vector by the fox's speed (simplified to just $k$) to get an equation of for the fox velocity vector at any instant in time.

$$ \left| R' \right| \equiv 1 $$

$$ \left| F' \right| \equiv k \left| R' \right| = k $$

$$ \frac{F'}{\left| F' \right|} = \frac{R-F}{\left| R-F \right|} $$

$$ F' = \frac{k(R-F)}{\left| R-F \right|} $$

## Setup

I'm defining a custom plotting recipe in Julia. This creates the plots seen below containing a lines with trailing widths. The last line of this code block shouldn't be ignored. This single line defines the differential equation which governs the path of the fox. It takes the function pursued (the path that the rabbit takes) and spits out the velocity vector of the fox.

```julia
using Plots
using DifferentialEquations, OrdinaryDiffEq
using LinearAlgebra

# Creating a plotting recipe for these pursuit curves
@userplot PursuitPlot
@recipe function f(cp::PursuitPlot)
    t, u = cp.args
    u = hcat(u...)';
    x, y = u[:,1], u[:,2];
    n = length(x)
    linewidth --> range(0.75, 10, length = n)
    aspect_ratio --> 1
    x, y
end

# Define the pursuit differential equations
pursuit(u, k, t) = k * (pursued(t) - u) / norm(pursued(t)-u)
```

## Rabbit Running in a Circle

The following simulation has the rabbit run in a unit circle with the fox starting at [4, 0]. In this simulation the fox is only 80% as fast as the rabbit, so he's never able to catch the rabbit.

```julia
pursued(t) = [cos(t), sin(t)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0, 17), 0.8)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, color=:tomato2, label="Fox")
savefig(joinpath(@OUTPUT, "fig1a.png")) # hide
```

<!-- {{postfig 1a "Animation: Rabbit running in a circle" 100}} -->
<!-- {{postfig 1b "Animation: Rabbit running in a circle" 100}} -->

\fig{/assets/blog_images/pursuit_curves_01_fig1b.gif}

## Rabbit Running in a Line

The following simulation has the rabbit run straight north starting at [0, -3] with the fox starting at [4, 0] again. Once again, the fox is only 80% as fast as the rabbit, so he's never able to catch the rabbit.

```julia
pursued(t) = [0, (t - 3)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0,6), 1.0)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, color=:tomato2, label="Fox")
savefig(joinpath(@OUTPUT, "fig2a.png")) # hide
```

<!-- {{postfig 2a "Rabbit Running in a Line" 100}} -->
<!-- {{postfig 2b "Animation: Rabbit Running in a Line" 100}} -->

\fig{/assets/blog_images/pursuit_curves_01_fig2b.gif}