#=
Two-dimensional polynomial system from [EHA17].

[EHA17] El-Guindy, Ahmed, Dongkun Han, and Matthias Althoff.
        *Estimating the region of attraction via forward reachable sets.*
        2017 American Control Conference (ACC). IEEE, 2017.
=#

@taylorize function poly_2d!(dx, x, p, t)
    dx[1] = (-2*x[1] + x[2]) + (x[1]^3 + x[2]^5)
    dx[2] = -x[1] - x[2] + (x[1]^2)*(x[2]^5)
    return dx
end
