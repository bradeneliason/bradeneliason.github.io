# This file was generated, do not modify it. # hide
pursued(t) = [cos(t), sin(t)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0, 17), 0.8)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, color=:tomato2, label="Fox")
savefig(joinpath(@OUTPUT, "fig1a.png")) # hide