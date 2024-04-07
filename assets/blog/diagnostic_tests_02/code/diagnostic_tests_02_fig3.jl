# This file was generated, do not modify it. # hide
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