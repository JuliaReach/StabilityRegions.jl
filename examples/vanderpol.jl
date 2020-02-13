#=
Inverted Van der Pol model from [EHA17].

[EHA17] El-Guindy, Ahmed, Dongkun Han, and Matthias Althoff.
        *Estimating the region of attraction via forward reachable sets.*
        2017 American Control Conference (ACC). IEEE, 2017.
=#

using Reachability, MathematicalSystems, TaylorIntegration, Plots

@taylorize function vanderpol!(dx, x, params, t)
    dx[1] = -x[2]
    dx[2] = -x[2]*(1-x[1]^2) + x[1]
    return dx
end

# The system has a stable equilibrium point at the origin.
# The domain of investigation in [EHA17] is
G = Interval(-2.5, 2.5) × Interval(-2, 2)
