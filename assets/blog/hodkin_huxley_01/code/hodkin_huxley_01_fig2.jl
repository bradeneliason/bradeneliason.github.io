# This file was generated, do not modify it. # hide
# Plotting
p1 = plot(
    sol.t, sol[4,:], 
    legend=false, 
    ylabel="Volatge [mV]"
)
p2 = plot(
    sol.t, I_inj.(sol.t), 
    legend=false, lc=:red, 
    ylabel="Current"
)
p3 = plot(
    sol.t, sol[1:3,:]', 
    label=["n" "m" "h"],
    color=[:blue :orange :green],
    legend=:topright, 
    xlabel="Time [ms]", 
    ylabel="Fraction Active"
)

l = grid(3, 1, heights=[0.4, 0.2 ,0.4])
plot(
    p1, p2, p3, 
    layout = l, 
    size=(600,600), 
    lw=3
)
savefig(joinpath(@OUTPUT, "fig2.png")) # hide