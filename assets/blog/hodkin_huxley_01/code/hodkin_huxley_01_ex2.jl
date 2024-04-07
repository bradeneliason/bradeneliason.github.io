# This file was generated, do not modify it. # hide
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