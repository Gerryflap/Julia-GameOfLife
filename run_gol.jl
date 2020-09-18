using Pkg
Pkg.activate(".")

using GameOfLife
GameOfLife.run(10000; width=200, height=40, pause=0, alive_chance=0.4)
