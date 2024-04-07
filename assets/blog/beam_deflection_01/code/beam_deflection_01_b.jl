# This file was generated, do not modify it. # hide
using ApproxFun, Plots
° = π/180;

# Setting up problem
L = 2.0                 # Length in m
E = 82.74e9             # Elasticin Pa
I = 444.0 * (0.01)^4    # Moment of interia m⁴
d = 0..L                # Domain of beam
z = Fun(identity, d)    # Length along beam in m
D = Derivative()

# Problem Definition
q = 1000*(z/L)          # Triangular loading in N/m
w = E*I*D^4             # DiffEq for beam deflection

# Boundary Conditions
B= [Evaluation(d, 0, 0) # Beam vertically constrained at z = 0
    Evaluation(d, 0, 1) # Beam's angle is constrained at z = 0
    Evaluation(d, L, 2) # Beam's moment is 0 at z = L
    Evaluation(d, L, 3)]# Beam's shear is 0 at z = L

# Solving for vertical displacement
v = [B; w] \ [ zeros(4)...; -q]

# Renaming and scaling variables
θ, M, V = (v'/°),(v''*E*I), (v'''*E*I)

# Plotting
p1 = plot(z, 1000v, legend=:none, 
    title="Deflection [mm]", lc=:blue)
p2 = plot(z, θ, legend=:none, 
    title="Angle [°]", lc=:orange)

plot(z, M/1000, label="Momement [kN⋅m]",
    fill = (0, 0.15, :blue),  lc=:blue)
plot!(z, V/1000, label="Shear [kN]",
    fill = (0, 0.15, :green), lc=:green)
p3 = plot!(z, q/1000, label="Load [kN/m]", 
    fill = (0, 0.15, :red),   lc=:red,
    legend=:bottomright)

l = grid(3, 1, heights=[0.2, 0.2 ,0.6])
plot(p1, p2, p3, layout=l,  lw = 3, 
    size=(500, 900), frame=:zerolines)
savefig(joinpath(@OUTPUT, "fig2a.png")) # hide