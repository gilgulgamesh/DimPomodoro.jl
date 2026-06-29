println("launching")

# artifact_bin = joinpath(first(filter(d -> isdir(joinpath(d, "qml", "Qt", "labs", "platform")),
#         readdir(joinpath(first(Base.DEPOT_PATH), "artifacts"), join=true))), "bin")
# sep = Sys.iswindows() ? ";" : ":"
# ENV["PATH"] = artifact_bin * sep * ENV["PATH"]

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
resttime = 2 * 60
bigresttime = 10 * 60
gotime = 15 * 60
gocolor = orange
restcolor = teal
bigrestcolor = purple
ncorner = 1
margin = 10
SCALING_FACTOR = 1 #set this to your ui scaling factor, or just play with it


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
const width = Observable(200)
const height = Observable(64)
const windowcolor = Observable("transparent")
const freeze = Observable(false)
const opacity = Observable(0.75)
const font = Observable("Meslo")
const fontsize = Observable(26)


on(freeze) do f
    if f
        rand1 = trunc(Int, 200rand())
        rand2 = trunc(Int, 200rand())
        x[] = y[] = 0
        width[] = 1920 + rand1
        height[] = 1080 + rand2
        windowcolor[] = "#99000000"
        opacity[] = 0.5
    else
        backtocorner()
        opacity[] = 0.75
        width[] = 200
        height[] = 64
        windowcolor[] = "transparent"

    end
end

function tocorner!(n)
    rand1 = trunc(Int, 40rand())
    rand2 = trunc(Int, 40rand())
    (x[], y[]) = corners[n] .+ (rand1, rand2)
end

on(paused) do p
    if p
        freeze[] = true
        visible[] = true
    else
        if !inrest[]
            freeze[] = false
        end
        t[] = t[] - 1
    end

end

on(inrest) do inr
    if inr
        freeze[] = true
        if ncorner == 4
            t[] = bigresttime
            color[] = bigrestcolor
        else
            t[] = resttime
            color[] = restcolor

        end
        # paused[] = true
        println("next break")
    else
        freeze[] = false
        paused[] = false
        t[] = gotime
        color[] = gocolor
        global ncorner
        ncorner = ncorner % 4 + 1
        tocorner!(ncorner)
        println("next pomo")
    end
    paused[] = true

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
skip() = begin
    inrest[] = !inrest[]
    !inrest[] ? paused[] = false : nothing
end
playpause() = paused[] = !paused[]

@qmlfunction println backtocorner skip playpause
engine = loadqml(qml_file, pomo=JuliaPropertyMap( "width" => width, "height" => height, "windowcolor" => windowcolor, "color" => color, "x" => x, "y" => y, "timestring" => timestring, "visible" => visible, "paused" => paused, "inrest" => inrest, "freeze" => freeze, "opacity" => opacity, "font" => font, "fontsize" => fontsize))
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
            if mytime() == [17 0 0]
                freeze[] = true
                color[] = bigrestcolor
                windowcolor[] = "#99000000"
                t[]  = 17 * 60
            elseif [0, 0, 1] < vec(mytime()) < [7, 0, 0]
                paused[] = true
                freeze[] = true
                windowcolor[] = "#EE000000"
                color[] = "#EE000000"

            end
        end
        sleep(0.01)
    end
end



exec_async()

mytime() = begin
    seconds = (time()÷1) % 60
    minutes = (time()÷60) % 60
    hours = ((time()÷(60*60)) + 13) % 24
    return Int.([hours minutes seconds])
end
