module GameOfLife
using NNlib

# Init weight
w = ones(Float64, (3,3,1,1))
w[2,2,1,1] = 0

function next_step(field)
    field = Float64.(field)
    # Acquire sizes
    s1, s2 = size(field)

    # Compute the counts of neighboring nodes using convolutions
    counts = conv(field, w; pad=1)

    # Compute the new field by comparing values in the field and counts
    return ((field .== 1.0) .& (counts .>= 2) .& (counts .<= 3)) .| (counts .== 3)
end

function init_field(width, height, alive_chance)
    return rand(Float64,  height,width, 1, 1) .< alive_chance
end

function show_field(field)
    s = ""
    sizes = size(field)
    for i=1:sizes[1]
        for j=1:sizes[2]
            if field[i, j, 1, 1]
                s *= "▊"
            else
                s *= " "
            end
        end
        s *= "\n"
    end

    println(s)
end

function run(n_steps; pause=0.0, width=30, height=30, alive_chance=0.3)
    field = init_field(width, height, alive_chance)
    show_field(field)

    for i = 1:n_steps
        if pause != 0.0
            sleep(pause)
        end
        field = next_step(field)
        show_field(field)
    end
end
end # module
