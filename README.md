# StabilityRegions.jl

[![Build Status](https://travis-ci.org/JuliaReach/StabilityRegions.jl.svg?branch=master)](https://travis-ci.org/JuliaReach/StabilityRegions.jl)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](http://juliareach.github.io/StabilityRegions.jl/dev/)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/JuliaReach/StabilityRegions.jl/blob/master/LICENSE)
[![DOI](https://zenodo.org/badge/105701832.svg)](https://zenodo.org/badge/latestdoi/105701832)
[![Code coverage](http://codecov.io/github/JuliaReach/StabilityRegions.jl/coverage.svg?branch=master)](https://codecov.io/github/JuliaReach/StabilityRegions.jl?branch=master)
[![Join the chat at https://gitter.im/JuliaReach/Lobby](https://badges.gitter.im/JuliaReach/Lobby.svg)](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`StabilityRegions` is a [Julia](http://julialang.org) package to compute stability
regions of ordinary differential equation systems using reachability analysis.

## Resources

- [Manual](http://juliareach.github.io/StabilityRegions.jl/dev/)
- [Contributing](https://juliareach.github.io/StabilityRegions.jl/dev/about/#Contributing-1)
- [Release notes of tagged versions](https://github.com/JuliaReach/StabilityRegions.jl/releases)
- [Release notes of the development version](https://github.com/JuliaReach/StabilityRegions.jl/wiki/Release-log-tracker)
- [Publications](https://juliareach.github.io/Reachability.jl/dev/publications/)
- [Developers](https://juliareach.github.io/StabilityRegions.jl/dev/about/#Credits-1)

## Installing

This package requires Julia v1.0 or later.
Refer to the [official documentation](https://julialang.org/downloads) on how to
install and run Julia on your system.

Depending on your needs, choose an appropriate command from the following list
and enter it in Julia's REPL.
To activate the `pkg` mode, type `]` (and to leave it, type `<backspace>`).

#### [Install the latest release version](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Adding-registered-packages-1)

```julia
pkg> add StabilityRegions
```

#### Install the latest development version

```julia
pkg> add https://github.com/mforets/StabilityRegions.jl.git
```

#### [Clone the package for development](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Developing-packages-1)

```julia
pkg> dev https://github.com/mforets/StabilityRegions.jl.git
```
