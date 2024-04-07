# This file was generated, do not modify it. # hide
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