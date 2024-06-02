+++
title = "Hodgkin-Huxley Model Using Julia"
date = Date(2020, 1, 15)
tags = ["Julia", "engineering"]
hascode = true
hasmath = true
+++

{{pageheader}}

<!-- # Hodgkin-Huxley Model Using Julia -->

For a biomedical engineer, studying the Hodgkin-Huxley model is a rite of passage—and rightly so. [Alan Hodgkin](https://en.wikipedia.org/wiki/Alan_Hodgkin) and [Andrew Huxley](https://en.wikipedia.org/wiki/Andrew_Huxley) set out to reverse engineer the spiking behavior of our nerves, and their work won them the Nobel Prize. This apex of scientific achievement was only possible through the combination of exquisite biological technique, genius mathematical insight, and no small degree of patience.

I've modeled their equation in several programming languages: first in Matlab while in college, second using Python (when I couldn't afford a personal license of Matlab), and now here using Julia. It has become my "Hello World!" example for scientific computing. The winner?—Julia by a landslide!

## Introduction to the Hodgkin-Huxley Model

This introduction isn't meant to be exhaustive. If you would like to learn more about the electrical behavior of a cell membrane, I highly recommend [Bioelectromagnetism - Principles and Applications of Bioelectric and Biomagnetic Fields by Jaakko Malmivuo & Robert Plonsey](http://www.bem.fi/book/).

The electrical behavior of a cell is not dictated by the flow of electrons. Instead, electricity flows through the body by the movement of ions. Thus the electrical behavior of a cell is dictated by ion concentrations and ion conductance. Ions can pass through the cell membrane by way of ion channels. Hodgkin and Huxley predicted that the conductance of these ion channels was dictated by activating "particles." Each of the particles could be active or inactive and the proportion of particles in the active state corresponds with the fraction of ion channels that are open.

## Transfer Rate Coefficients

In their model, there were three different activating particles: n, m, and h. The particles jump from their inactive state to their active state at a rate of $\alpha$. Similarly they become inactive again at a rate of $\beta$. Hodgkin and Huxley determined how these transfer rates changed as a function the membrane voltage (or more accurately the difference between the membrane voltage and the resting potential). The particle kinetics and governing differential equation are shown below:

### Kinetics:

$$ n \overset{\alpha_n}{\underset{\beta_n}{\leftrightharpoons}} (1-n) $$

$$ m \overset{\alpha_m}{\underset{\beta_m}{\leftrightharpoons}} (1-m) $$

$$ h \overset{\alpha_n}{\underset{\beta_n}{\leftrightharpoons}} (1-h) $$

### Differential Equations:

$$ \frac{d n}{d t}=\alpha_n(1-n)-\beta_n n $$

$$ \frac{d m}{d t}=\alpha_m(1-m)-\beta_m m $$

$$ \frac{d h}{d t}=\alpha_h(1-h)-\beta_h h $$

## The Setup

The Julia code below imports the necessary packages and defines functions for the transfer rate coefficients for n, m, and h. We also define the steady state values for each of these activation particles to help define our initial conditions. Finally we set a few constants that will be used throughout the script.

```julia
using Plots, DifferentialEquations, LaTeXStrings

## Constants
const C_m     = 1       # μF/cm², membrane capacitance
const G_NaMax = 120     # mS/cm², max conductivity of Na channel
const G_KMax  = 36      # mS/cm², max conductivity of K channel
const G_L     = 0.3     # mS/cm², leak conductivity
const V_r  = -65        # mV, resting potential
const V_Na =  50        # mV, Nernst voltage for Na 
const V_K  = -77        # mV, Nernst voltage for K
const V_L  = -54.387    # mV, Nernst voltage for leak

## Function Definitions
α_n(dV) = (0.1 - 0.01*dV)/(exp(1 - 0.1*dV)- 1)
β_n(dV) = 0.125/(exp(0.0125*dV))
α_m(dV) = (2.5 - 0.1*dV)/(exp(2.5 - 0.1*dV)- 1)
β_m(dV) = 4/(exp(dV/18))
α_h(dV) = 0.07/(exp(0.05*dV))
β_h(dV) = 1/(exp(3 - 0.1*dV)+ 1)

# Steady states
n_∞(dV) = α_n(dV)/(α_n(dV)+β_n(dV))
m_∞(dV) = α_m(dV)/(α_m(dV)+β_m(dV))
h_∞(dV) = α_h(dV)/(α_h(dV)+β_h(dV))
```

## Differential Equations

<!-- ![Circuit diagram of neuron membrane](/assets/blog_images/hodkin_huxley_01_fig1.png) -->
<!-- {{postfig 1 "Circuit diagram of neuron membrane" 100}} -->
\fig{/assets/blog_images/hodkin_huxley_01_fig1.png}

This diagram shows the circuit model for a small patch of cell membrane. Each ion can only pass through a designated channel. The conductance of each ion channel is determined by the parameters G which is affected by the activation particles described above. Each ion also has a voltage associated with it called the Nernst voltage. In addition to the ion channel conductances, there are also leak currents and capacitive currents. From this circuit model, the final differential equation can be derived.

Hodgkin and Huxley solved for the membrane current per unit area as function of the ion conductance and membrane capacitance. Recall that the current across a capacitor depends on the capacitance and change in voltage over time. For my simulation, instead of solving for the membrane current, I am going to solve for the change in voltage over time. The membrane current will be a stimulus which I can adjust to cause the simulated cell to fire. Essentially this is the current that I am injecting into my simulated cell to cause an action potential.

$$ I_m=C_m \frac{d V_m}{d t}+(V_m-V_{Na}) G_{Na}+(V_m-V_K) G_K+(V_m-V_L) G_L $$

$$ \frac{d V_m}{d t} = \frac{I_{inj}(t) + (V_{Na} - V_m)G_{Na} + (V_K - V_m)G_K + (V_L - V_m) G_L}{C_m} $$

Julia is a very concise and high level language. As a result, it can often look like pseudocode. The differential equations defined above for the transfer rate coefficients and the membrane voltage can be seen directly in the HH_model function.

```julia
# Injected Current Function
I_inj(t) = 10 * (5 < t < 30)

function HH_model(u,p,t)
    n, m, h, Vm = u 
    
    # Update transfer rate coefficients, n, m, and h
    # V_diff: membrane voltage - rest voltage
    V_diff = Vm - V_r         
    dn = α_n(V_diff)*(1-n) - β_n(V_diff)*n
    dm = α_m(V_diff)*(1-m) - β_m(V_diff)*m
    dh = α_h(V_diff)*(1-h) - β_h(V_diff)*h
    
    # Update cell membrane voltage, Vm
    G_K  = G_KMax  * n^4       # Sodium conductance
    G_Na = G_NaMax * h * m^3   # Potasium conductance
    dVm = ( I_inj(t) + (V_Na - Vm)*G_Na + 
          (V_K - Vm)*G_K + (V_L - Vm)*G_L ) / C_m 

    [dn; dm; dh; dVm]
end

## Run Model:
u0 = [n_∞(0); m_∞(0) ; h_∞(0); -65.1]
tspan = (0.0,50.0)
prob = ODEProblem(HH_model, u0, tspan)
sol = solve(prob, saveat=0.01);
```

```julia
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
```
<!-- TODO: -->
<!-- {{postfig 2 "Simulated neuron results. The light blue curve indicataes the voltage acorss the cell membrane. The red curve is the injected current stimulus that causes the simulated cell to depolarize. The blue, orange, and green curve show the dynamics of the activating particles." 100}} -->