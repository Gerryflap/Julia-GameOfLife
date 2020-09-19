module GameOfLife
using NNlib
using Gtk
using Gtk.ShortNames

# === Code for computing board states ===
# Init weight
w = ones(Float64, (3,3,1,1))
w[2,2,1,1] = 0

function next_step(field)
    # Compute the counts of neighboring nodes using convolutions
    counts = conv(field, w; pad=1)

    # Compute the new field by comparing values in the field and counts
    return Float64.(((field .== 1.0) .& (counts .>= 2) .& (counts .<= 3)) .| (counts .== 3))
end

function init_field(width, height, alive_chance)
    return Float64.(rand(Float64,  height,width, 1, 1) .< alive_chance)
end

# === Code for text display ===

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

function run_text(n_steps; pause=0.0, width=30, height=30, alive_chance=0.3)
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

# === Code for GTK app ===
# Global variables for the GTK app
win = nothing
data = nothing
pixbuf = nothing
view = nothing
running = true

# Listener for app shutdown
function stop_running(w)
    global running = false
end

function gtk_show_field(field)
    global win
    if win == nothing
        # Initialize GTK window and view
        global win = Window("Game of Life", size(field)[2], size(field)[1])
        global data = Gtk.RGB[Gtk.RGB(0,0,0) for x=1:size(field)[2], y=1:size(field)[1]];
        global pixbuf = Pixbuf(data=data,has_alpha=false)
        global view = Image(pixbuf);
        push!(win,view);
        signal_connect(stop_running, win, :destroy)
        showall(win);
    end
    # Update buffer and trigger refresh
    data[:] = Gtk.RGB[Gtk.RGB(
                              field[y,x,1,1]*255,
                              field[y,x,1,1]*255,
                              field[y,x,1,1]*255)
                      for x=1:size(field)[2], y=1:size(field)[1]];
    G_.from_pixbuf(view, pixbuf)
end

function run_gtk(;pause=0.0001, width=800, height=600, alive_chance=0.3)
    # Runs the GTK app
    global running
    field = init_field(width, height, alive_chance)
    gtk_show_field(field)

    while running
        if pause != 0.0
            sleep(pause)
        end
        field = next_step(field)
        gtk_show_field(field)
    end
end

# === Main function for app artifact building ====
function julia_main()
    run_gtk()
    return 0
end


end # module
