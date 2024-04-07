# This file was generated, do not modify it. # hide
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