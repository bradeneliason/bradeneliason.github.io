+++
title = "Diagnostic Test Visualization: Part 2"
date = Date(2021, 1, 4)
tags = ["Julia"]
hasmath = true
+++

{{pageheader}}

{{postfig 1 "Diagnostic Test Visualization with Linear Scale from previous post"}}

I wanted to revisit a visualization that I made in a [previous post](/blog/diagnostic_tests_01) which shows various parameters of diagnostics tests. I glossed over an issue in that previous post that I hope to address here. For a typical screening test, the visualization would be nearly unreadable because important regions on the graph would be too small to see. The box in the visualization is divided vertically by the prevalence of the condition. People with the condition are on the left and people without the condition are on the right. If the prevalence of the condition is low (say 1%), then the people with the condition (both true positives and false negatives) take up just a tiny sliver of the graph. The same problem occurs with very high prevalence for people without the condition. Similarly if the sensitivity or specificity is close to either 0 or 1, one of the boxes vanishes into a sliver.

## To a New Scale

Instead of fundamentally altering the diagram, I figured I could rescale the axes. Logarithmic scaling is for [quitters](https://xkcd.com/1162/) and doesn't meet my needs, so I need a new scaling function. Probability is bounded between 0 and 1. I want to expand the regions on the ends of this range nearest to 0 and 1. On the low end, I need to distinguish two anomalous events with probabilities like 1% and 0.1%. Similarly, I would like the scale to distinguish two events which are nearly certain with probabilities like 99% and 99.9%. The scaling function should have an inverted "S" shape that gets steeper near 0 and 1. The steep regions of the graph have the effect of mapping a narrow range of inputs (depicted on the x-axis) into a larger region of output (depicted on the y-axis).

\input{julia}{/assets/scripts/diagnostic_tests_02_1.jl}
\fig{/assets/scripts/output/diagnostic_tests_02_fig2.svg}

<!-- ```julia:./code/diagnostic_tests_02_fig2
using Plots

logit(x) = log(x/(1-x))

begin
	xx = 0:0.001:1.0
	plot( logit, xx, label="Logit function", lw=2)
	plot!( xlim=(-0.1,1.1), ylim=(-4.1,4.1),
		legend=:topleft, framestyle=:zerolines,
		size=(400,400)
	)
end
savefig(joinpath(@OUTPUT, "fig2.png")) # hide
``` -->

<!-- \fig{./code/diagnostic_tests_02_fig2.png} -->
<!-- {{postfig 2 "Plot of logit function with asymptotes at 0 and 1."}} -->

At first it seems like [logit function](https://en.wikipedia.org/wiki/Logit) (the inverse of the logistic function) might be a good fit. This maps values between 0 and 1 to $-∞$ and $+∞$. The one annoyance is that it takes a bounded range and maps it to an unbounded range. I wanted all the relevant features of my visualization to stay within a box so having a rescaling capable of shooting points off to infinity was not ideal.

The function below satisfies all my requirements. The amount of scaling at the ends of the range is determined by a parameter $k$. One really convenient feature is that to invert the scaling, you only need to apply the same function with the reciprocal parameter.

$$ f(x; k) = \frac{1}{1 + \left(\frac{1}{x} - 1 \right)^k} $$

$$ f(\ f(x; k);\ \frac{1}{k})= x $$

I have to credit an answer from [user Ron on math.StackExhange.com](https://math.stackexchange.com/questions/1832177/sigmoid-function-with-fixed-bounds-and-variable-steepness-partially-solved/3253471#3253471) with this equation. The question posted in that thread was relating to a sigmoidal function for an AI application, but Ron's equation is precisely what I was looking for.

I've found that a scaling factor of $\frac{1}{5}$ is a really good balance. With this scaling factor probabilities of 0.1%, 1%, 10%, and their inverses get remapped to close to 10% divisions. This means I can create nearly regularly spaced ticks marks that fall on these preferred numbers.

<!-- TODO: fix formatting of this code -->
\input{julia}{/assets/scripts/diagnostic_tests_02_2.jl} 
\fig{/assets/scripts/output/diagnostic_tests_02_fig3.svg}

<!-- ```julia:./code/diagnostic_tests_02_fig3
using Plots

scale_fwd(x, k=5) = 1 / (1 + ((1/x) - 1)^(1/k))
scale_rev(x, k=5) = 1 / (1 + ((1/x) - 1)^(k))

begin
	xx = 0:0.001:1.0
	plot( scale_fwd, xx, label="k=5", color=:dodgerblue1)
	plot!(scale_rev, xx, label="k=1/5", ls=:dash, color=:dodgerblue1)
	plot!(xx, xx, lw=2, ls=:dot, color=:gray, label="x=y")
	plot!(aspect_ratio=:equal, 
		xlim=(-0.1,1.1), 
		ylim=(-0.1,1.1),
		legend=:topleft,
		framestyle=:zerolines,
		size=(600,600),
		lw=2,
	)
end
savefig(joinpath(@OUTPUT, "fig3.png")) # hide
``` -->

<!-- \fig{./code/diagnostic_tests_02_fig3.png} -->
<!-- {{postfig 3 "Plot of bounded scaling function and it's inverse" 100}} -->

## New Version of the Visualization

I recreated my visualization from before but with axes rescaled. Take note of the light dashed lines and axis labels. The prevalence is only 2.2% but this doesn't collapse the left side of the plot into a sliver. It goes without saying that this graph isn't meant to be used as a quantitative comparison.

Logarithmic scales are ubiquitous for a reason; they have a very nice property that turns curves depicting exponential decays or growth into straight lines. I'm not sure if there is a deeper mathematical elegance to the scale I've chosen or if there is another scaling function that's better suited. My primary goal is to have a readable chart that helps me better understand diagnostic tests.

{{postfig 4 "Diagnostic Test Visualization" 100}}

I could have stopped with the image above, but I wasn't quite satisfied. I wanted my visualization to be interactive. I fired up an interactive {{jlpkg Pluto.jl}} notebook and created a visualization which reacts to input from a few sliders. The graphic was made with {{jlpkg Luxor.jl}}. {{jlpkg Luxor.jl}} isn't meant to be interactive, but {{jlpkg Pluto.jl}} notebooks are reactive. When I update the value of a slider, the notebook automatically updates all the affected code including the code which generates the visualization. I may explore using {{jlpkg Javis.jl}} in the future for smoother animations. I'm pretty pleased with the outcome and there's still a lot more that could be done.

{{postfig 5 "Animated Diagnostic Test Visualization" 100}}

## Wrapping Up

This project is mostly a vehicle for me to better remember the details of diagnostic testing. I've been pretty unsatisfied with the descriptions and visualizations on this topic. Creating my own visualization gives me a motivation to dive into terminology of diagnostic tests and learn new skills (such as creating interactive visualizations).

There's still more work that could be done. For this first plot, I've chosen to divide the plot first by people with and without the condition (i.e. splitting vertically by the prevalence). The vertical segments are subsequently split based on the results of their test. I chose this order because the most commonly discussed parameters of a diagnostic test—sensitivity, specificity, and prevalence—can be read directly from the graph. You could just as easily flip the order of these cuts. That is, first cut the square horizontally by people's test results (negative and positive) and then cut the horizontal segments by people with and without the condition. On this alternative plot, parameters including positive predictive value (PPV), false discovery rate (FDR), false omission rate (FOR), and negative predictive value (NPV) can be read off from the graph directly.
