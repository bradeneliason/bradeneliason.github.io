# Pursuit Curves in Julia
## Setup


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


## Rabbit Running in a Circle

pursued(t) = [cos(t), sin(t)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0, 17), 0.8)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, label="Fox")
# savefig(joinpath(@OUTPUT, "pursuit_curves_01_a.png")) # hide


## Rabbit Running in a Line


pursued(t) = [0, (t - 3)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0,6), 1.0)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, label="Fox")
# savefig(joinpath(@OUTPUT, "pursuit_curves_01_b.png")) # hide
