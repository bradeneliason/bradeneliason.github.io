+++
title = "Tolerance Analysis with Julia"
hascode = true
hasmath = true
date = Date(2020, 5, 20)
tags = ["Julia", "engineering"]
+++

{{pageheader}}

\toc

## Intro

This project started when I was reviewing the Excel engineering calculators found on [MITCalc.com](https://www.mitcalc.com/). MITCalc has many useful calculators for sale for designing gears, springs, beams, and much more. They also have many generic engineering tools including a spreadsheet for performing tolerance analysis. Being both frugal and curious, I set out to see if I could replicate this function with Julia. I've posted the results here for other frugal, curious engineers. 

**Disclaimer:** I've done this as a proof of concept to fulfill my own curiosity—use your own judgment to determine if this tool will work for you and your application.

## Background on Tolerances

If you are making only a few parts and assembling the parts yourself, make the parts to fit. If you watch a master woodworker, they'll often use layout calipers or use one piece to mark another (i.e. relative dimensioning). If there's another party involved in the manufacturing or you are making many parts, you need to consider the tolerances of your dimension. Dimensions and tolerances are a way to communicate intent. There are several different ways a dimension may be presented on the drawing of a part:

 1. **Limit of size** — This type of tolerance lists two dimensions: the smallest and the largest acceptable dimension. The dimension are either written from smallest to largest left-to-right, or the larger dimension is on top of the smaller dimension.
 1. **Equal bilateral form** — This is the type of tolerance *most people are familiar with*. The dimension has a nominal value followed by the acceptable variation. The dimension may be larger or smaller by equal amounts.
 1. **Unequal bilateral form** — Like the equal bilateral form, the dimension has a nominal value followed by the acceptable variation, but in this case the variation is not symmetrical. The dimension may be larger or smaller on either side by a different amount.
 1. **Unilateral form** — In this case the dimension is only allowed to be either larger or smaller than the nominal dimension.
 1. **Unless Otherwise Specified (UOS)** — A part drawing will often have a table of tolerances in the title block. The tolerance of each dimension can be specified by the number of significant digits given. 

| Decimal Places |	Format   | Standard Tolerance   |
|----------------|-----------|----------------------|
| 1              | `0.x`     | `± 0.2"`             |
| 2              | `0.0x`    | `± 0.01"`            |
| 3              | `0.00x`   | `± 0.005"`           |
| 4              | `0.000x`  | `± 0.0005"`          |

In general, use equal bilateral tolerance, but there are exceptions to that rule. Remember, dimensions and tolerances communicate intent. Consider the case where you want an eighth-inch hole, but the application permits the hole to be larger more readily than it permits the hole to be smaller. You may want to specify the dimension as something like $\varnothing\ 0.125 + 0.005/-0.001"$. If instead you were to specify the dimension as $\varnothing\ 0.127 \pm .003"$, this might signal to the manufacturer that they would need a special $0.127"$ tool. In general, holes produced by standard drills are over-sized, so a wise machinist might know to use a quarter-inch drill when given a dimension of $\varnothing\ 0.127 \pm .003"$. However, $\varnothing\ 0.125 +0.005/-0.001"$ more clearly communicates your intent: a $0.125"$ hole.

## Tolerance Analysis

Tolerance analysis is the process of calculating how error might accumulate in dimensions with tolerances. There are two main ways to calculate tolerance: worst-case analysis and statistical analysis.

Worst-case analysis is just what it sounds like: you consider each dimension at its largest and smallest acceptable values and you calculate the upper and lower bounds for the combined dimensions. Since most manufacturing processes will produce real dimensions following a normal distribution, it's extremely unlikely that anything close to the worst-case scenario will come true. The power of the worst-case analysis is in its simplicity. It boils down to just adding up the dimensions twice: once for the lower limit dimensions and again for the the upper limit dimensions.

Statistical tolerance analysis is much more powerful. Instead of assuming each part is at the limits of its acceptable variation, statistical tolerance analysis assumes each dimension is sampled from a statistical distribution. For the sake of simplicity, we'll assume that each dimension is sampled from a normal distribution centered on the nominal dimension and that the tolerance represents three times the standard deviation ($3\sigma$ on either side for a total of $6\sigma$). When we assume the dimensions are normal distributions, we can use the root sum squared (RSS) method to combine their tolerances as standard deviations.

Note: Not all manufacturing processes will produce dimensions with a normal distribution. The methods to calculate the tolerance stack-up get more complicated; special software has been developed to deal with these cases. I plan to look into various probabilistic programming packages in Julia ({{jlpkg Soss.jl}}, {{jlpkg Turing.jl}}, and {{jlpkg Gen.jl}}) to see if they can be used for this type of tolerance analysis.

Consider the simple case of stacking two parts on together.

 * The left, purple part has a dimension of $40 \pm 0.5 mm$.
 * The right, blue part has a dimension of $25 \pm 0.1 mm$.

{{postfig 1 "Tolerance stack up" 60}}

### Worst-Case Tolerance Analysis

Using worst-case analysis, we can calculate the upper and lower bound of the stack. The smallest acceptable dimensions of each part are 39.5 and 24.9 for a total of 64.4. The largest acceptable dimensions of each part are 40.5 and 25.1 for a total of 65.6. The total stack will fall between 64.4 and 65.6—put another way, $64 \pm 0.6 mm$.

The worst-case analysis produces a more conservative (larger) tolerance compared with the RSS method.

### Statistical Tolerance Analysis — RSS Method

Using the RSS method, we sum the standard deviations using the following formula:

$$ \sigma_{total}=\sqrt{\sum_{i=1}^{n} \sigma_{i}^{2}}\ = \sqrt{0.5^2 + 0.1^2}\ =\ 0.5099.. $$

The nominal dimensions are summed normally to produce a tolerance stack up of $65 \pm 0.51 mm$.

These processes are not terribly complicated for simple geometries, but the complexity of these calculations explodes rapidly with more dimensions.

## Measurements.jl

```julia
using Measurements #hide
a = 4.5 ± 0.1;
b = 3.8 ± 0.4;
@show 2a + b
```

```julia
2a + b = 12.8 ± 0.45
```
<!-- TODO: -->
<!-- \output{./code/blender_dithering_01_ex1} -->

{{jlpkg Measurements.jl}} is a package in Julia that takes care of uncertainty propagation for you. Values with uncertainty can be specified with `±`, as we would hope. In this case, the `±` symbol is a custom infix operator that creates a new type called a Measurement. Through the unreasonable effectiveness of multiple dispatch, {{jlpkg Measurements.jl}} extends the basic operations of Julia, so all calculations done on a Measurement will look the same as if they were just a float. More details about {{jlpkg Measurements.jl}} can be found in the package documentation. Here is a basic example of how {{jlpkg Measurements.jl}} works:

## Tolerance Analysis with Measurements.jl

```julia
using Measurements #hide
dim1 = 40 ± 0.5;
dim2 = 25 ± 0.1;
@show dim1 + dim2
```

```julia
dim1 + dim2 = 65.0 ± 0.51
```
<!-- TODO: -->
<!-- \output{./code/blender_dithering_01_ex2} -->

Consider our simple example above. The following code is able to replicate the statistical tolerance analysis method without the hassle. There's no special methods to call. The complexities of propagating uncertainty though addition are handled by extending the definition of addition to quantities with uncertainty. 

Okay, that's too easy. Let's try a problem with more teeth.

{{postfig 2a "Tolerance analysis example" 100}}

This example was taken from an example in the [documentation for the MITCalc.com](https://www.mitcalc.com/doc/tolanalysis3d/help/en/tolanalysis3d.htm) tolerance analysis calculator. Imagine a part with two holes. The positions of the two holes are determined by chains of dimensions. We would like to know the center-to-center distance and tolerance between the two holes. Our simple calculation methods above quickly become unwieldy.

{{postfig 2b "Tolerance analysis example, variable names" 100}}

The MITCalc example suggests first deriving the equations below:


$$ X=B-D+(C-E) \cdot \cos (A)-G \cdot \sin (A) $$

$$ Y=(C-E) \cdot \sin (A)+G \cdot \cos (A)-F $$

$$ Z=\sqrt{X^{2}+Y^{2}} $$

Ignore those equations. **There's an easier way.** Performing statistical tolerance analysis on this part becomes trivial with {{jlpkg Measurments.jl}}. Simply define each of the dimensions as a vector. For example, dimension $F$ is really a vector with a Measurement for one of its values:

$$ F = \begin{bmatrix}0 \\44.95 \pm 0.05\end{bmatrix} $$

```julia
using Pkg; Pkg.add("Measurements") #hide
using Measurements, LinearAlgebra

# Define the degree symbol to convert from degree to radians
° = pi / 180; 

# Create a quick function to rotate vectors
vec_rotate(θ, vector) = [cos(θ) -sin(θ); sin(θ) cos(θ)] * vector

A = (30 ± 0.2)°;
B = [120, 0];
C = vec_rotate(A, [120, 0]);
D = [25, 0];
E = vec_rotate(A, [-25, 0]);
F = [0, 44.95 ± 0.05];
G = vec_rotate(A, [0, 44.95 ± 0.05]);

path1 = B + C + G + E;
path2 = F + D;

Z = path1 - path2;

@show norm(Z) # The length of Z
```

Once all the vectors are defined, determining Z is easy. Z is just a vector derived from all the other dimension vectors. The length of Z can be found by taking its norm. The result is $160.26 \pm 0.24$.

```julia
norm(Z) = 160.26 ± 0.24
```
<!-- TODO: -->
<!-- \output{./code/blender_dithering_01_ex3} -->

## Wrapping Up

### Smaller Details:

 * I've only demonstrated doing the RSS statistical tolerance analysis method. I may write a quick function to do worst-case analysis using {{jlpkg Measurements.jl}}—stay tuned.
 * I've converted a unilateral dimension ($45 +0/-0.1$) in the example above into equal bilateral dimensions ($44.95 \pm 0.05$).
 * I've bodged a little convenience function to rotate vectors. I would like to make a more generic function, but it wasn't worth the hassle for this proof of concept. Let me know if you know of a better solution.
 * I've also defined the degree symbol as π/180. I made it a habit to write that at the beginning of all Julia scripts, because it's ridiculously convenient to just write `30°` instead of `30*π/180`.
 * This method is also compatible with {{jlpkg Unitful.jl}}. This means that you could give units to each dimension vector and the calculation proceeds without any additional monkey business. I haven't shown this here, but it does work. Using {{jlpkg Unitful.jl}} may be particularly useful if you're compelled to use mixed imperial and metric dimensions.

### Future Work

There is still a lot that could be done. I've considered creating a package to perform tolerance analysis, but for now I'm happy with using {{jlpkg Measurements.jl}}. More refined statistical tolerance analysis processes could probably still use Julia, but I believe I'll need to use one of the probabilistic programming packages ({{jlpkg Soss.jl}}, {{jlpkg Turing.jl}}, and {{jlpkg Gen.jl}}) to perform uncertainty propagation with arbitrary distributions. Here are some features that could be part of a Julia package specifically for tolerances:

 * Supporting all of the tolerance types above, including a way to parse a dimension written as a string.
 * Support for multiple different tolerance analysis methods, including worst-case, RSS, Monte Carlo simulations, and others.
 * Support for units (a must!).
 * Integration with {{jlpkg Plots.jl}} (this would be interesting).
 * The ability to specify standard tolerances (e.g., ANSI or ISO hole tolerance standards)

If you end up using this, let me know! I'd be really curious to hear what you think. 