module StabilityRegions

using Reexport, Parameters
@reexport using ReachabilityAnalysis

abstract type AbstractAlgorithm end

include("utils.jl")
include("static.jl")

export Static2D,
       stability_region

end # module
