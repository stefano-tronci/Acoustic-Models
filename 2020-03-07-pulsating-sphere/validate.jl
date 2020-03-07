using DelimitedFiles
using Plots

include("exact.jl")

f = 999.99999999999989
U = 0.75
c = 343.0
ρ = 1.205
a = 0.005

linedata = readdlm("linedata_2.csv", ',')

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
    xlabel="Distance from Source [m]",
    ylabel="[Pa]",
    title="Real Part of the Error"
    )

imagplt = plot(
    r,
    imag.(err),
    legend=false,
    framestyle=:box,
    xlabel="Distance from Source [m]",
    ylabel="[Pa]",
    title="Imaginary Part of the Error"
)

absplt = plot(
    r,
    abs.(err),
    legend=false,
    framestyle=:box,
    xlabel="Distance from Source [m]",
    ylabel="[Pa]",
    title="Absolute Value of the Error"
)

angplt = plot(
    r,
    angle.(err),
    legend=false,
    framestyle=:box,
    xlabel="Distance from Source [m]",
    ylabel="[rad]",
    title="Phase of the Error"
)

dBplt = plot(
    r,
    20.0 * log10.(abs.(femSolution) ./ abs.(exactSolution)),
    legend=false,
    framestyle=:box,
    xlabel="Distance from Source [m]",
    ylabel="[dB re Exact]",
    title="Error with respect Exact Solution (Magnitude)"
)

angRplt = plot(
    r,
    angle.(femSolution ./ exactSolution),
    legend=false,
    framestyle=:box,
    xlabel="Distance from Source [m]",
    ylabel="[rad re Exact]",
    title="Error with respect Exact Solution (Phase)"
)

l = @layout [grid(2,2) grid(2, 1)]

errorPlot = plot(realplt, imagplt, absplt, angplt, dBplt, angRplt, layout=l)

display(errorPlot)

readline()
