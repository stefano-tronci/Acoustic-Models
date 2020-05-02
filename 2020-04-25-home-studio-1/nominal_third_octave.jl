using DelimitedFiles

function nominalThirdOctaveFrequencies()

    return [
        16;
        20;
        25;
        31.5;
        40;
        50;
        63;
        80;
        100;
        125;
        160;
        200;
        250;
        315;
        400;
        500;
        630;
        800;
        1000;
        1250;
        1600;
        2000;
        2500;
        3150;
        4000;
        5000;
        6300;
        8000;
        10000;
        12500;
        16000;
        20000
    ]

end

function writeParaViewTimeArray(
    x::AbstractArray,
    root::String,
    fileName::String
    )

    for n in 1:length(x)
        writedlm(joinpath(root, fileName * "_$n.csv"), x[n])
    end

end
