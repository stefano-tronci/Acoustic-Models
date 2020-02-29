function sphericalImpedance(
    f::Real,
    r::Real,
    ρ::Real,
    c::Real
    )

    kr = 2π * f * r / c

    return im * ρ * c * kr / (1.0 + im * kr)

end

function sphericalWave(
    U::Real,
    a::Real,
    f::Real,
    t::Real,
    r::Real,
    ρ::Real,
    c::Real
    )

    Z = sphericalImpedance(f, a, ρ, c)

    ω = 2π * f
    k = ω / c

    ϕ = mod2pi(ω * t - k * (r - a))

    return Z * a * U * exp(im * ϕ) / r

end

function decibel(x::T, ref::Real) where {T<:Number}
    return 20.0 * log10(abs(x) / ref)
end
