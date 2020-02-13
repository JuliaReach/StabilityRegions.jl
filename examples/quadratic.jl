#=
This is the quadratic model from [Example 1, 1].

- [L94] Levin, Alexanckr. *An analytical method of estimating the domain of attraction
        for polynomial differential equations.*
        IEEE Transactions on Automatic Control 39.12 (1994): 2471-2475.
=#

@taylorize function quadratic!(dx, x, p, t)
    x1x2 = x[1]*x[2]
    dx[1] = -2*x[1] + x1x2
    dx[2] = -x[2] + x1x2
    return dx
end

# Add streamline plot

# Integration
X0 = Singleton([1.0, 2.0]) ⊕ BallInf(zeros(2), 0.1)
P = @ivp(x' = quadratic!, x ∈ X0)
#P = @ivp(x' = quadratic(x, p, t), x ∈ X0)
sol = solve(P, tspan=(0.0, 2.0))
