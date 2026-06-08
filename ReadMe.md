# DimPomodoro
Gruvbox themed, minimal, dark, and semi-opaque Pomodoro timer with oled-safety in mind.

## Features
- automatically shifts between screen corners to help keep track
- low-blue colours
- random shuffling

## um 
- didn't do scaling automatically... you can change it in the file, add a resolution and your ui scaling factor, it's at 1x 1080p.

## Inputs
- double click to skip
- right click to pause
- middle click to realign to corner
- click on the tray icon to toggle visibility

## TBA
- analogue mode
- little pet mode
- something smart `-__-`

## Installation
### automatic
There are `install` and `launch` scripts, just run them in order. 
They do very little, just install julia and run the commends below. The `.jl` file temporarily adds a specific qml library to path as a workaroud for a bug in the windows version of QML.jl.

### manual
install Julia, then (from this folder) install with 
```
julia --project=. -e "using Pkg; Pkg.instantiate()"
```
then run with
```julia --project. pomodoro.jl
```

## Usage
You can launch it from the included .bat file on windows, which really just runs `julia --project=.` in the installation folder. Or do `julia` then `using DimPomodo.jl`

For now to change things like time you can edit the actual DimPomodoro.jl file, or enter one session (one launch of the timer):
`gocolor = blue // red, orange, green, white, gray (yellow, teal, purple)`
or `restcolor`, `bigrestcolor`
Or use any rgb code like `"#a1b2c3"`

You can see the effects live by setting `color[] = ...` instead, or `x[]...` and `y[]...=` to test screen dimensions

time is:
`gotime = 15 * 60` for 15 minutes
or `resttime`, `bigrestime`

