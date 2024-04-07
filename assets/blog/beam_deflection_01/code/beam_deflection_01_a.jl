# This file was generated, do not modify it. # hide
using ApproxFun, Plots
L, E, I = 12.0, 1.0, 1.0
d = 0..L
z = Fun(identity, d)
B = [[Evaluation(d,0,k) for k=0:1]... ; [Evaluation(d,L,k) for k=2:3]... ;]
v = [B; E*I*Derivative()^4] \ [ zeros(4)...; one(z)]
func_name = zip([v, v', v'', v'''], ["Deflection", "Angle", "Momement", "Shear"])
plot([plot(z, f, title=n, label="") for (f,n) in func_name]..., lw=3)
savefig(joinpath(@OUTPUT, "fig1a.png")) # hide