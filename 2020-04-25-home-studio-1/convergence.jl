function parseConvergence(fileName::String)

  file = open(fileName)
  lines = readlines(file)
  close(file)

  frequencyMask = occursin.(
    "HelmholtzSolve:  Frequency (Hz):",
    lines
  )

  itStartMask = occursin.(
    "IterSolver: Calling complex iterative solver",
    lines
  )

  itEndMask = occursin.(
    "ComputeChange: NS (ITER=1)",
    lines
  ) .| occursin.(
    "NUMERICAL ERROR:: IterSolve: Too many iterations was needed.",
    lines
  )

  lineNumber = 1:length(lines)
  nSolutions = length(lines[frequencyMask])

  data = Dict()

  for n in 1:nSolutions

    freq = parse(Float64, split(lines[frequencyMask][n])[end])

    convLines = split.(
      lines[
        (lineNumber[itStartMask][n] + 1):(lineNumber[itEndMask][n] - 1)
      ]
    )

    it = [parse.(Float64, convLines[n])[1] for n in 1:length(convLines)]
    v = [parse.(Float64, convLines[n])[2] for n in 1:length(convLines)]

    convData = [it v]

    data[freq] = convData

  end

  return data

end
