println("launching")

artifact_bin = joinpath(first(filter(d -> isdir(joinpath(d, "qml", "Qt", "labs", "platform")),
        readdir(joinpath(first(Base.DEPOT_PATH), "artifacts"), join=true))), "bin")
sep = Sys.iswindows() ? ";" : ":"
ENV["PATH"] = artifact_bin * sep * ENV["PATH"]

using QML
using Observables

gray = "#d0c8aa"
yellow = "#fabd2f"
green = "#b8bb26"
blue = "#96a89e"
purple = "#bf93a0"
teal = "#8ec07c"
white = "#e5debb"
red = "#fb4934"
orange = "#fe8019"

#vars
qml_file = "pomodoro.qml"
resttime = 5 * 60
bigresttime = 60 * 60
gotime = 25 * 60
gocolor = orange
restcolor = teal
bigrestcolor = purple
ncorner = 1
margin = 10
SCALING_FACTOR = 1 #set this to your ui scaling factor, or just play with it
# opacity is in the qml

#corners!
left = margin
right = 1920 - margin - 200
top = margin
bottom = 1080 - margin - 100
nw = (left, top)
ne = (right, top)
sw = (left, bottom)
se = (right, bottom)
k = SCALING_FACTOR
corners = (ne, se, sw, nw)
# corners = (ne.÷k, se.÷k, sw.÷k, nw.

const timestring = Observable("Br:Ok:En")
const visible = Observable(true)
const x = Observable(right)
const y = Observable(top)
const t = Observable(gotime)
const color = Observable(gocolor)
const inrest = Observable(false)
const paused = Observable(false)



function tocorner!(n)
    rand1 = trunc(Int, 40rand())
    rand2 = trunc(Int, 40rand())
    (x[], y[]) = corners[n] .+ (rand1, rand2)
end

on(paused) do p
    if p
        visible[] = true
    end
end

on(inrest) do inr
    if inr
        if ncorner == 4
            t[] = bigresttime
            color[] = bigrestcolor
        else
            t[] = resttime
            color[] = restcolor
        end
        paused[] = true
        println("next break")
    else
        t[] = gotime
        color[] = gocolor
        global ncorner
        ncorner = ncorner % 4 + 1 # looks odd, but after 1-indexing it's normal
        tocorner!(ncorner)
        println("next pomo")
    end
    timestring[] = formattime(t[])

end

#time!

function formattime(timen)
    sec = timen % 60
    min = timen ÷ 60
    if min < 10
        min = string(0, min)
    end
    if sec < 10
        sec = string(0, sec)
    end
    string(min, ":", sec)
end




backtocorner() = tocorner!(ncorner)
skip() = inrest[] = !inrest[]
playpause() = paused[] = !paused[]

@qmlfunction println backtocorner skip playpause
engine = loadqml(qml_file, pomo=JuliaPropertyMap("paused" => paused, "color" => color, "x" => x, "y" => y, "timestring" => timestring, "visible" => visible))
# QML.watchqml(engine, qml_file)

trunning = false
timekeeper = @async begin
    while true
        @async while !paused[] && !trunning
            global trunning
            trunning = true
            timestring[] = formattime(t[])
            t[] -= 1
            sleep(1)
            if t[] ≤ 0
                inrest[] = !inrest[] # triggers all other things
            end
            trunning = false
        end
        sleep(0.01)
    end
end



exec_async()
