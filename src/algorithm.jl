"""
    stability_region(S, xs, G; T=10.0, ϵ=1e-3, λ=50, itermax=100, hx=20, hy=20)

### Input

- `S`  -- dynamical system
- `xs` -- vector representing a stability equilibrium point (SEP) for the given dynamics
- `G`  -- search space
- `T`  -- (optional, default: `10`) time horizon for the reach set computations
- `ϵ`  -- (optional, default: `1e-3`) target set tolerance
- `λ`  -- (optional, default: `50`) scaling factor
- `itermax` -- (optional, default: `100`) maximum number of iterations in the inclusion check loop
- `hx` -- (optional, default: `20`) size of the partition along coordinate `x`
- `hy` -- (optional, default: `20`) size of the partition along coordinate `y`

### Notes

This is a proof-of-principle implementation of
[Algorithm 1,  El-Guindy-Han-Althoff paper's].

This preliminary code works for the two-dimensional examples only..
"""
function stability_region(S, xs, G; T=10.0, ϵ=1e-3, λ=50, itermax=100, hx=20, hy=20)

    R0vec = [] # Vector{Zonotope{Float64}}()

    # construct target set as a small box surrounding the SEP
    # Tg = Singleton(xs) + BallInf(zeros(2), ϵ) # (NOTE: the lazy representation is problematic)
    Tg = minkowski_sum(Singleton(xs), BallInf(zeros(2), ϵ)) # so we take the concrete M-sum, which returns a hyperrectangle

    # define the initial set for reachability through scaling of the target set by a factor λ
    R0 = λ * Tg

    Rend = final_set(S, R0, T)
    push!(R0vec, R0)

    # inclusion check loop
    k = 1
    while _issubset(Rend, Tg) && k < itermax && _issubset(R0, G)
        @info "iteration $k"
        Tg = deepcopy(R0)
        R0 = λ * Tg
        push!(R0vec, R0)
        try
            Rend = final_set(S, R0, T)
        catch
            @info "Cannot prove existence and unicity of the solution, skipping the iteration.."
            break
        end
        k += 1
    end

    # aca me tendria que quedar con la interseccion entre R0 y G, ya que la ultima caja
    # puede ser, en general mas grande que G

    # PARA PROBAR, me quedo con el penultmo R0...
    #R0 = R0vec[end-1]

    # ahora viene el punto 3.a y los siguientes
    # ACA HAY QUE TOMAR LA DIFERENCIA ENTRE G y el PENULTIMO
    Gh = overapproximate(G, Hyperrectangle)
    B = split(Gh, [hx, hy])
    SCells = []

    for icell in eachindex(B) # 1:length(B)
        @info "Processing cell $icell"
        R0 = B[icell]
        try
            Rend = final_set(S, R0, T)
        catch
            @info "Cannot prove existence and unicity of the solution, skipping the iteration.."
            continue
        end
        if _issubset(Rend, Tg)
            @info "Found stability region for cell $icell"
            push!(SCells, R0)
        end
    end

    AllCells = B
    return R0vec, SCells, AllCells
end

# solve a reachability problem for the given time horizon T, for the given initial set
# and return the final reach set
function final_set(S, R0, T, args...)
    P = InitialValueProblem(S, R0)
    O = Options(:T=>T, :mode=>"reach")
    sol = solve(P, O, op=TMJets(:abs_tol=>1e-20, :orderT=>10, :orderQ=>4,
                                :output_type=>Zonotope, :max_steps=>5_000));
    return set(last(sol.Xk))
end
