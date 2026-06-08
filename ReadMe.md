# DimPomodoro
Gruvbox themed, minimal, dark, and semi-opaque Pomodoro timer with oled-safety in mind.

## Features
- automatically shifts between screen corners to help keep track
- low-blue colours
- random shuffling

## um
- YO, wait a minute while i fix this
- 1080p only for now, without scaling, unless you want to edit to add your screen dimensions

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
As it runs on Julia + QML, it must be ran as source code. However, they make it easy.
- "install julia"
(tested on julia 1.12.6)

enter the repl with:
```julia```

in the REPL, enter pkg mode by typing:
`]`

then input:
`add https://github.com/gilgulgamesh/dimpomodoro.jl`

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
