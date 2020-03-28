using LinearAlgebra

"""
    angularWaveVectorComponent(n, L)

Returns the angular wave vector component for a rectangular room given the
mode index and room length along the required component cartesian direction, in
meters.
# Example
```jldoctest
julia> nx = 7
7

julia> Lx = 5
5

julia> kx = angularWaveVectorComponent(nx, Lx)
4.39822971502571
```
"""
function angularWaveVectorComponent(n::Integer, L::Real)
    return n * π / L
end

"""
    angularWaveVector(nx, ny, nz, Lx, Ly, Lz)

Returns the angular wave vector of a rectangular room mode. Mode numbers along
the cartesian directions are nx ny and nz, the room sizes along the cartesian
directions are Lx, Ly and Lz meters.
# Example
```jldoctest
julia> angularWaveVector(1, 4, 7, 5.0, 4.0, 3.0)
3-element Array{Float64,1}:
 0.6283185307179586
 3.141592653589793
 7.330382858376184
```
"""
function angularWaveVector(
    nx::Integer, ny::Integer, nz::Integer,
    Lx::Real, Ly::Real, Lz::Real
    )

    return [
        angularWaveVectorComponent(nx, Lx);
        angularWaveVectorComponent(ny, Ly);
        angularWaveVectorComponent(nz, Lz)
        ]

end

"""
    modeFrequency(nx, ny, nz, Lx, Ly, Lz, c)

Returns the modal frequency of a mode characterized by indeces nx, ny and nz
along the cartesian directions for a rectangular room of sizes Lx, Ly and Lz
meters along the cartesian directions. c is the speed of sound in air, by
default 343 meters per second (speed at standard conditions).
# Example
```jldoctest
julia> modeFrequency(1, 4, 7, 5.0, 4.0, 3.0)
436.7174156260672

julia> modeFrequency(1, 4, 7, 5.0, 4.0, 3.0, 340.0)
432.89772977511035
```
"""
function modeFrequency(
    nx::Integer, ny::Integer, nz::Integer,
    Lx::Real, Ly::Real, Lz::Real,
    c::Real = 343
    )

    return norm(angularWaveVector(nx, ny, nz, Lx, Ly, Lz)) * c / 2π

end

# """
# """
# function modeSearch(
#     n::Integer,
#     Lx::Real, Ly::Real, Lz::Real,
#     c::Real = 343
#     )
#
#     idxMatrix = zeros(Integer, 3, n)
#
#     modeFrequencies = zeros(n)
#     modeFrequencies[1] = modeFrequency(
#         idxMatrix[1, 1], idxMatrix[2, 1], idxMatrix[3, 1],
#         Lx, Ly, Lz,
#         c
#     )
#
#     idxAdders = [
#         1 0 0 1 1 0 1;
#         0 1 0 1 0 1 1;
#         0 0 1 0 1 1 1
#     ]
#
#     m = 2
#     idxPivot = idxMatrix[:, 1]
#
#     while m <= n
#
#         idxCandidates = idxPivot .+ idxAdders
#
#         selIdx = [
#             !any(all(idxMatrix[:, 1:m] .== idxCandidates[:, k], dims=1))
#             for k in 1:size(idxCandidates, 2)
#         ]
#
#         idxCandidates = idxCandidates[:, selIdx]
#
#         candidates = modeFrequency.(
#             idxCandidates[1, :], idxCandidates[2, :], idxCandidates[3, :],
#             Lx, Ly, Lz,
#             c
#         )
#
#         sortIdx = sortperm(candidates)
#         candidates = candidates[sortIdx]
#         idxCandidates = idxCandidates[:, sortIdx]
#
#         tTarget = min(n, m + length(sortIdx) - 1)
#         tSource = min(n - m + 1, length(sortIdx))
#
#         modeFrequencies[m:tTarget] = candidates[1:tSource]
#         idxMatrix[:, m:tTarget] = idxCandidates[:, 1:tSource]
#
#         idxPivot = idxMatrix[:, m]
#
#         m = tTarget + 1
#
#     end
#
#     sortIdx = sortperm(modeFrequencies)
#
#     return modeFrequencies[sortIdx], idxMatrix[:, sortIdx]
#
# end
"""
    mode(x, y, z, nx, ny, nz, Lx, Ly, Lz)

Returns the modal shape at coordinates in x, y, z for mode characterized by
indeces nx, ny and nz along the cartesian directions for a rectangular room of
sizes Lx, Ly and Lz meters along the cartesian directions. Result returned
normalized between 1 and -1, arbitrary units.
# Example
```jldoctest
julia> mode(2.5, 2.0, 1.5, 1, 4, 7, 5.0, 4.0, 3.0)
0.0

julia> mode.([3.0; 2.5], [1.0; 2.0], [0.75; 1.5], 1, 4, 7, 5.0, 4.0, 3.0)
2-element Array{Float64,1}:
 0.2185080122244105
 0.0
```
"""
function mode(
    x::Real, y::Real, z::Real,
    nx::Integer, ny::Integer, nz::Integer,
    Lx::Real, Ly::Real, Lz::Real
    )

return cospi(nx * x / Lx) * cospi(ny * y / Ly) * cospi(nz * z / Lz)

end

"""
    meshGrid(x, y, z)

Returns the 3-D grid coordinates defined by the vectors x, y, and z.
The grid is represented by three matrices of size length(y) by length(x) by
length(z). This is similar to MATLAB's meshgrid.
# Example
```jldoctest
julia> x = [1; 2]
2-element Array{Int64,1}:
 1
 2

julia> y = [3; 4]
2-element Array{Int64,1}:
 3
 4

julia> z = [5; 6]
2-element Array{Int64,1}:
 5
 6

julia> X, Y, Z = meshGrid(x, y, z)
([1 2; 1 2]

[1 2; 1 2], [3 3; 4 4]

[3 3; 4 4], [5 5; 5 5]

[6 6; 6 6])
```
"""
function meshGrid(x::AbstractArray, y::AbstractArray, z::AbstractArray)

    X = zeros(eltype(x), length(y), length(x), length(z))
    fX(i, j, k) = X[i, j, k] = x[j]
    [fX(i, j, k) for i in 1:length(y), j in 1:length(x), k in 1:length(z)]

    Y = zeros(eltype(y), length(y), length(x), length(z))
    fY(i, j, k) = Y[i, j, k] = y[i]
    [fY(i, j, k) for i in 1:length(y), j in 1:length(x), k in 1:length(z)]

    Z = zeros(eltype(z), length(y), length(x), length(z))
    fZ(i, j, k) = Z[i, j, k] = z[k]
    [fZ(i, j, k) for i in 1:length(y), j in 1:length(x), k in 1:length(z)]

    return X, Y, Z

end

"""
    indexGrid(Nx, Ny, Nz)

Returns a 3-D grid up to indeces Nx, Ny and Nz along the 3 cartesian
directions. The grid is represented by three matrices of size Ny by Nx by Nz.
# Example
```jldoctest
julia> Gx, Gy, Gz = indexGrid(3, 4, 5)
([1 2 3; 1 2 3; 1 2 3; 1 2 3]

[1 2 3; 1 2 3; 1 2 3; 1 2 3]

[1 2 3; 1 2 3; 1 2 3; 1 2 3]

[1 2 3; 1 2 3; 1 2 3; 1 2 3]

[1 2 3; 1 2 3; 1 2 3; 1 2 3], [1 1 1; 2 2 2; 3 3 3; 4 4 4]

[1 1 1; 2 2 2; 3 3 3; 4 4 4]

[1 1 1; 2 2 2; 3 3 3; 4 4 4]

[1 1 1; 2 2 2; 3 3 3; 4 4 4]

[1 1 1; 2 2 2; 3 3 3; 4 4 4], [1 1 1; 1 1 1; 1 1 1; 1 1 1]

[2 2 2; 2 2 2; 2 2 2; 2 2 2]

[3 3 3; 3 3 3; 3 3 3; 3 3 3]

[4 4 4; 4 4 4; 4 4 4; 4 4 4]

[5 5 5; 5 5 5; 5 5 5; 5 5 5])

```
"""
function indexGrid(Nx::Integer, Ny::Integer, Nz::Integer)
    return meshGrid(0:Nx, 0:Ny, 0:Nz)
end

"""
    roomAxes(rx, ry, rz, Lx, Ly, Lz)

Returns the 1-D axes coordinates along the sides of a rectangular room with
reference to a corner. The room has sizes Lx, Ly and Lz meters along the
cartesian directions, while rx, ry and rz express the step of the axes along
each cartesian direction.
"""
function roomAxes(
    rx::Real, ry::Real, rz::Real,
    Lx::Real, Ly::Real, Lz::Real
    )

    x = range(0.0, stop = Lx, length = round(Integer, 1 + Lx / rx))
    y = range(0.0, stop = Ly, length = round(Integer, 1 + Ly / ry))
    z = range(0.0, stop = Lz, length = round(Integer, 1 + Lz / rz))

    return x, y, z

end

"""
    roomGrid(rx, ry, rz, Lx, Ly, Lz)

Returns the 3-D grid coordinates inside a rectangular room with reference to a
corner. The room has sizes Lx, Ly and Lz meters along the cartesian directions,
while rx, ry and rz express the step of the grid along each cartesian direction.
"""
function roomGrid(
    rx::Real, ry::Real, rz::Real,
    Lx::Real, Ly::Real, Lz::Real
    )

    x, y, z = roomAxes(rx, ry, rz, Lx, Ly, Lz)

    return meshGrid(x, y, z)

end
