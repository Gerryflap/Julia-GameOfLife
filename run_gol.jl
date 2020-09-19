using Pkg
Pkg.activate(".")

using GameOfLife
# GameOfLife.run(10000; width=40, height=40, pause=0, alive_chance=0.4)
GameOfLife.run_gtk(width=800, height=600, pause=0.001, alive_chance=0.2)
