# This file was generated, do not modify it. # hide
pursued(t) = [0, (t - 3)]
prob = ODEProblem(pursuit, [4.0, 0.0], (0.0,6), 1.0)
sol = solve(prob, saveat=0.1);

pursuitplot(sol.t, pursued.(sol.t), label="Rabbit")
pursuitplot!(sol.t, sol.u, color=:tomato2, label="Fox")
savefig(joinpath(@OUTPUT, "fig2a.png")) # hide