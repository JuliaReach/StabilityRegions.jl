"""
Este es un "parche" hasta que las funciones necesarias en LazySets esten agregado, asi
simplemente X ⊆ Y para los tipos en cuestion funciona y es eficiente. La idea es tranformar los conjuntos
X e Y (que pueden ser lazy en general) a polytopes, y a partir de ahi hacer el chequeo usando funciones de soporte,
que funciona como se explica a continuacion.

La idea del algortimo es la siguiente: dados los politopos X e Y, sean {<a_x, b_x>} y {<a_y, b_y>} las listas de
semiespacios que definen a X y a Y respectivamente. Entonces X esta incluido en Y si y solo si para cada normal
a_y de Y, se cumple que ρ(a_y, X) <= b_y
"""
@inline function _issubset(X, Y)
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
