using DelimitedFiles
using Plots

include("exact.jl")

f = 1000.0
U = 0.75
c = 343.0
ρ = 1.205
a = 0.005

linedata = readdlm("linedata.csv", ',')

x = Float64.(linedata[2:end, 3])
y = Float64.(linedata[2:end, 4])
z = Float64.(linedata[2:end, 5])

r = sqrt.(x.^2 + y.^2 + z.^2)

femSolution = Float64.(linedata[2:end, 1]) + im .* Float64.(linedata[2:end, 2])

exactSolution = sphericalWave.(U, a, f, 0, r, ρ, c)

err = femSolution - exactSolution

realplt = plot(
    r,
    real.(err),
    legend=false,
    framestyle=:box,
    xlabel="r [m]",
    ylabel="Error [Pa]",
    title="Real Part"
    )

imagplt = plot(
    r,
    imag.(err),
    legend=false,
    framestyle=:box,
    xlabel="r [m]",
    ylabel="Error [Pa]",
    title="Imaginary Part"
)

absplt = plot(
    r,
    abs.(err),
    legend=false,
    framestyle=:box,
    xlabel="r [m]",
    ylabel="Error [Pa]",
    title="Absolute Value"
)

angplt = plot(
    r,
    angle.(err),
    legend=false,
    framestyle=:box,
    xlabel="r [m]",
    ylabel="Error [rad]",
    title="Phase"
)

dBplt = plot(
    r,
    20.0 * log10.(abs.(femSolution) ./ abs.(exactSolution)),
    legend=false,
    framestyle=:box,
    xlabel="r [m]",
    ylabel="Error [dB re Exact]",
    title="dB Error"
)

l = @layout [grid(2,2) a]

errorPlot = plot(realplt, imagplt, absplt, angplt, dBplt, layout=l)

display(errorPlot)

readline()
