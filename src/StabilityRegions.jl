module StabilityRegions

using Reexport, Parameters
@reexport using ReachabilityAnalysis

# abstract supertype for all algorithm types
abstract type AbstractAlgorithm end

# utility functions
include("utils.jl")

# algorithms
include("static.jl")
export Static2D

# user API
include("api.jl")
export stability_region

end # module
