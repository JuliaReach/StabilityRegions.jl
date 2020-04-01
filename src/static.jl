using ReachabilityAnalysis: AbstractContinuousPost

@inline function _issubset_old(X, Y)
    local Z
    try
        Z = X ⊆ Y
    catch
        try
            Xpoly = convert(HPolytope, X)
            Ypoly = convert(HPolytope, Y)
            Z = Xpoly ⊆ Ypoly
        catch
            error("no esta implementado")
        end
    end
    return Z
end

function _issubset(X::AbstractHyperrectangle, Y::AbstractHyperrectangle)
    return LazySets.issubset(X, Y)
end

"""
    stability_region(S, xs, G; T=10.0, ϵ=1e-3, λ=50, itermax=100, hx=20, hy=20)

### Input

- `S`  -- dynamical system, `x' = f(x)`
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
@with_kw struct Static2D <: AbstractAlgorithm
    T::Float64=10.0
    ϵ::Float64=1e-3
    λ::Int=10
    itermax::Int=100
    hx::Int=20
    hy::Int=20
    cpost::AbstractContinuousPost=TMJets()
    #ST::Hyperrectangle{Float64, Vector{Float64}, Vector{Float64}}
end

function stability_region(S::AbstractContinuousSystem, xs::AbstractVector, G::LazySet)
    # default algorithm
    alg = Static2D()
    return stability_region(S, xs, G, alg)
end

function stability_region(S::AbstractContinuousSystem, xs::AbstractVector, G::LazySet, alg::Static2D)

    @unpack T, ϵ, λ, itermax, hx, hy, cpost = alg

    n = 2 # dimension of state space
    @assert statedim(S) == n "this method only works for two-dimensional sets, but "
                             "the given system is $n-dimensional"

    # this algorithm requires G to be a hyperrectangular set
    G = overapproximate(G, Hyperrectangle)

    # construct target set as a small box surrounding the SEP
    Tg = Hyperrectangle(xs, fill(ϵ, n))

    # define the initial set for reachability through scaling of the target set by a factor λ
    R0 = Hyperrectangle(xs, fill(λ * ϵ, n))

    # compute the initial flowpipe until time horizon T
    Rend = _final_set(S, R0, T, alg)

    # vector that holds the initial set for each flowpipe computation
    #ST = Hyperrectangle{Float64, Vector{Float64}, Vector{Float64}}
    #ST = typeof(Rend)
    #R0vec = Vector{ST}()

    #push!(R0vec, R0)

    # inclusion check loop
    k = 1
    while k < itermax && _issubset(Rend, Tg)
        @info "iteration $k"
        Tg = deepcopy(R0)
        R0 = Hyperrectangle(Tg.center, Tg.radius * λ)

        #push!(R0vec, R0)

        if !_issubset(R0, G)
            R0 = intersection(R0, G)
            isempty(R0) && break # remove?
        end
        _issubset(G, R0) && break

        try
            Rend = _final_set(S, R0, T, alg)
        catch
            @info "Cannot prove existence and unicity of the solution, skipping the iteration.."
            break
        end
        k += 1
    end

    return R0, T, Tg, Rend, k # , R0vec

    # aca me tendria que quedar con la interseccion entre R0 y G, ya que la ultima caja
    # puede ser, en general mas grande que G

    # PARA PROBAR, me quedo con el penultimo R0...
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
            Rend = _final_set(S, R0, T)
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
# and return the final set
# NOTE: could exploit RA#32 once ready
function _final_set(S::AbstractContinuousSystem, R0::LazySet, T, alg)
    sol = solve(IVP(S, R0), tspan=(0.0, T), alg)
    sol_oa = overapproximate(sol[end], Hyperrectangle)
    return set(sol_oa)
end
