+++
title = "Solving Beam Deflection"
date = Date(2021, 3, 16)
tags = ["Julia", "engineering"]
hascode = true
hasmath = true
+++

{{pageheader}}

This started as a challenge on the Julia Discourse website to come up with a compelling application for Julia in seven lines of code. I had wanted a reason to learn more about the {{jlpkg ApproxFun.jl}} package and took this as a fun opportunity.

## The Problem

{{jlpkg ApproxFun.jl}} is well suited to finding the solutions of ordinary differential equations (ODEs) with boundary conditions. One application for this is solving beam deflection under various loading conditions. As a test case, here's a simple beam deflection problem: a cantilevered beam with uniform loading. The beam has length, L, and it's stiffness is determined by both the elastic modulus, E, and the moment of inertia, I.

<!-- {{postfig 1 "Uniformly loaded cantilever beam" 100}} -->
\fig{/assets/blog_images/beam_deflection_01_fig1.png}


## My Seven Lines (excluding imports)

\input{julia}{/assets/scripts/beam_deflection_01.jl}

<!-- \input{julia}{scripts/beam_deflection_01.jl} -->

<!-- \fig{./code/beam_deflection_01_a} -->
<!-- {{postfig 1a "Deflection, angle, moment, and shear of beam with a uniform loading" 100}} -->
\fig{/assets/scripts/output/beam_deflection_fig1a.svg}

## What It's Doing

The seven lines are bit compressed to fit within the constraints of the challenge so let's walk through it.

These four lines are the simplest. The first line imports the required packages: `ApproxFun`, `Plots`. Next we define variables for the length, elastic modulus, and moment of inertia for the beam. The variable, d, is the domain of the ODE, in this case from `0` to `L`. The last line in this group creates an `ApproxFun` function called `z` across the domain. This function is simply the distance along the beam.

```julia
using ApproxFun, Plots
L, E, I = 12.0, 1.0, 1.0
d = 0..L
z = Fun(identity, d)
```

`B` is an array of boundary conditions for our ODE. It's a fourth order ODE, so there are four boundary conditions. The vertical displacement and first derivative (ie, angle) are both zero at the fixed end of the beam. The moment and shear in the beam (2nd and 3rd) derivatives are zero at the free end of the beam.

```julia
B = [[Evaluation(d,0,k) for k=0:1]... ; 
     [Evaluation(d,L,k) for k=2:3]... ;]
```

The solution is generated on the next line. The boundary conditions, B, are all set to 0 using `zeros(4)...`. The differential equation for a beam is defined (`E*I*Derivative()^4`) and gets set to a uniform load `one(z)` (shown as **q** in the image above).

```julia
v = [B; E*I*Derivative()^4] \ [ zeros(4)..., one(z)]
```

These two lines plot the results. I've zipped together the solution and it's derivatives with their corresponding labels. The last line uses list comprehension to plot the results. Note: I wouldn't typically use syntax like this for plotting but I had to fit this whole thing into seven lines. A little bit of clarity went out the window.

```julia
func_name = zip([v, v', v'', v'''], ["Deflection", "Angle", "Momement", "Shear"])
plot([plot(z, f, title=n, label="") for (f,n) in func_name]..., lw=3)
```

## Beam Deflection - More Breathing Room

When not constrained to seven lines of code, it's much easier to document and read this Julia code. The code below show a 2 meter long beam with load which increases from 0 at the fixed end to 1 kN/m at the end of the beam. Here's a diagram of the problem setup.

<!-- ![alt text](/assets/blog_images/beam_deflection_01_fig2.png) -->
<!-- {{postfig 2 "Uniformly varying load on a cantilever beam" 100}} -->
\fig{/assets/blog_images/beam_deflection_01_fig2.png}

\input{julia}{/assets/scripts/beam_deflection_02.jl}
\fig{/assets/scripts/output/beam_deflection_fig2a.svg}
<!-- \input{julia}{scripts/beam_deflection_02.jl} -->

<!-- \fig{./code/beam_deflection_01_b} -->
<!-- {{postfig 2a "Deflection, angle, moment, and shear of beam with a uniformly varying load" 100}} -->

## Next Steps

 * I would like to play around with more supporting and loading conditions. In particular, I want to figure out how to have a support in the middle of the beam. I believe I need to solve this problem piecewise when there are supports in the middle of the beam.
 * I want to see if ApproxFun can solve some more complicated examples. It should be able to solve the 2D version of this problem - plate deflection.
 * Adding {{jlpkg Units.jl}} or {{jlpkg Measurements.jl}} should allow me to calculate beam deflections with units and error propagation.