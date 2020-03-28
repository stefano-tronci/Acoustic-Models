include("RectangularRoom.jl")
using Plots

# Let's define the room size along x, y, and z, in meters
Lx = 5.0
Ly = 4.0
Lz = 3.0

# Here we define the step of the grid over which we want to calculate the mode
# shape. It will be one point every rx, ry, rz meters along x, y, and z
# respectively.
rx = 0.1
ry = 0.1
rz = 0.1

# We identify the mode we want to calculate with these three indices, the mode
# numbers.
nx = 1
ny = 0
nz = 0

# Here we assign an amplitude to the mode, as if we were plotting the pressure
# field in the room as driven by a sine wave source of appropriate power to 
# sustain the target SPL, at steady state regime. dB re 20uPa
SPL = 80.0

# Finally, we set the height in the room at which we want to plot the result.
lh = 1.80

# Computations below.

x, y, z = roomAxes(rx, ry, rz, Lx, Ly, Lz)
X, Y, Z = meshGrid(x, y, z)
li      = argmin(abs.(z .- lh))

P       = 20e-6 * exp10(SPL / 20.0)

eigenV  = P * mode.(X, Y, Z, nx, ny, nz, Lx, Ly, Lz)
eigenF  = modeFrequency(nx, ny, nz, Lx, Ly, Lz)

clibrary(:colorbrewer)

levs    = range(-P, stop = P, length = 128)

# Let's make a little plot
modePlot = contourf(x, y, eigenV[:, :, li],
        levels = levs,
        xlabel = "x [m]", 
        ylabel = "y [m]",
        colorbar_title = "Pressure Disturbance [Pa]",
        title = "Resonance mode at $eigenF Hz, z = $(z[li]) m"
        )
        
### Can make a little animation too - Comment this section in case of troubles
eigenT  = 1.0 / eigenF

Tsteps  = 64

nT      = 1

aL      = nT * eigenT

Fs      = Tsteps * eigenF

nF      = floor(Integer, aL * Fs)

anim = @animate for i = 1:nF
    contourf(x, y, eigenV[:, :, li] * cospi(2 * eigenF * (i - 1) / Fs),
        levels = levs, 
        xlabel = "x [m]", 
        ylabel = "y [m]",
        colorbar_title = "Pressure Disturbance [Pa]",
        title = "Resonance mode at $eigenF Hz, z = $(z[li]) m"
        )
end

fps     = 12

gif(anim, "/tmp/rmode.gif", fps = fps)

###

# Let's show the first plot:
display(modePlot)
