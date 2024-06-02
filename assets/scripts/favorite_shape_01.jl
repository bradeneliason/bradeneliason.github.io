using Plots

k = 0.65223
dt = 0.000001
tlim = acos(-k)-dt
t = -tlim:dt:tlim  

x = @. sqrt(k + cos(t))
y = cumsum(@. cos(t)/sqrt(k + cos(t))*dt)/2

plot(x,y, aspect_ratio=1, lw=4, legend=:none)
savefig(joinpath(@__DIR__, "output", "favorite_shape_01_fig2.svg")) #hide