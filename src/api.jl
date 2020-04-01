function stability_region(S::AbstractContinuousSystem, xs::AbstractVector, G::LazySet)
    # default algorithm
    alg = Static2D()
    return stability_region(S, xs, G, alg)
end
