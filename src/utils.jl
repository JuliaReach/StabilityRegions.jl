function _issubset(X::AbstractHyperrectangle, Y::AbstractHyperrectangle)
    return LazySets.issubset(X, Y)
end

# try to test inclusion using polytopes, if everything fails
# TODO: try methods using boxes
function _issubset(X, Y)
    local Z
    try
        Z = X ⊆ Y
    catch
        try
            Xpoly = convert(HPolytope, X)
            Ypoly = convert(HPolytope, Y)
            Z = Xpoly ⊆ Ypoly
        catch
            tX = typeof(X)
            tY = typeof(Y)
            error("inclusion check not implemnted for sts of type $tX and $tY")
        end
    end
    return Z
end
