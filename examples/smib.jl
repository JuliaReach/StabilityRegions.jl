#=
Single-machine infinite bus model from [EHA17].

The numerical values of the parameters are taken from [....] TODO: find book

[EHA17] El-Guindy, Ahmed, Dongkun Han, and Matthias Althoff.
        *Estimating the region of attraction via forward reachable sets.*
        2017 American Control Conference (ACC). IEEE, 2017.
=#


using Reachability, MathematicalSystems, TaylorIntegration, Plots

@taylorize function smib!(dx, x, params, t)
    local H =
    local Pe =
    local Pm =
    local D =

    dx[1] = x[2]
    dx[2] = (1/H)*( (Pm - Pe*sin(x[1])) - D*x[2])
    return dx
end

# The equilibrium point is $xₛ = [0.835, 0]
# The domain of investigation is
G = Interval(-0.5, 2.5) × Interval(-3, 3)
