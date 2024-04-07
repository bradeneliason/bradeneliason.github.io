# This file was generated, do not modify it. # hide
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