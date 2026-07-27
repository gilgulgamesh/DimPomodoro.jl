println("launching")
starttime = time()
using QML
println(time()-starttime)
using Observables
println(time()-starttime)

using Dates

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
resttime = 1
bigresttime = 3
gotime = 60
gocolor = yellow
restcolor = teal
bigrestcolor = purple
ncorner = 1
margin = 10
scale = 1 ##UI scaling factor, input what yours is as this is REVERSED

#corners!
left = margin
right = 1920 - margin - 200
top = margin
bottom = 1080 - margin - 100
nw = (left, top)
ne = (right, top)
sw = (left, bottom)
se = (right, bottom)
corners = (ne.÷scale, se.÷scale, sw.÷scale, nw.÷scale)


const timestring = Observable("Br:Ok:En")
const visible = Observable(true)
const x = Observable(right)
const y = Observable(top)
const t = Observable(gotime * 60)
const color = Observable(gocolor)
const inrest = Observable(false)
const paused = Observable(true)
const width = Observable(200)
const height = Observable(64)
const windowcolor = Observable("black")
const frozen = Observable(false)
const opacity = Observable(0.75)
const font = Observable("Meslo LG S")
const fontsize = Observable(18)
println(time()-starttime)

daycount() = Dates.today() - Date("2026-07-15") |> string |> split |> first .|> (x -> parse(Int, x))

medtime() = daycount() + 17

function tocorner(n)
    rand1 = trunc(Int, 40rand())
    rand2 = trunc(Int, 40rand())
    (x[], y[]) = corners[n] .+ (rand1, rand2)
end

on(frozen) do f
    if f
        rand1 = trunc(Int, 200rand())
        rand2 = trunc(Int, 200rand())
        x[] = y[] = 0
        width[] = 1920 + rand1
        height[] = 1080 + rand2
        opacity[] = 0.5
    else
        backtocorner()
        opacity[] = 0.75
        width[] = 50
        height[] = 50
        # windowcolor[] = "transparent"

    end
end

on(paused) do p
    if p
        frozen[] = true
        visible[] = true
        # windowcolor[] = "#FF000000"
        global frozen
        if frozen[]
            # windowcolor[] = "#FF000000"
        else
            # windowcolor[] = "#99000000"
        end

    else
        Threads.@spawn tick()
        if !inrest[]
            frozen[] = false
        else

        end
    end
    # println(p)
end

on(inrest) do inr
    if inr
        frozen[] = true
        if ncorner == 4
            t[] = bigresttime * 60
            color[] = purple
            # sleep(1)
            paused[] = true
        else
            t[] = resttime * 60
            color[] = restcolor
            paused[] = true
        end
        # paused[] = true
        println("next break")
    else
        t[] = gotime * 60
        color[] = gocolor
        global ncorner
        ncorner = ncorner % 4 + 1
        tocorner(ncorner)
        println("next pomo")
        paused[] = true
        timestring[] = formattime(t[])
    end
end

function formattime(timen)
    sec = timen % 60
    min = timen ÷ 60
    if min < 10
        min = string(min)
    end
    if sec < 10
        sec = string(0, sec)
    end
    if min == "0"
        string(":", sec)
    else
        string(min)
    end
end

#QML
backtocorner() = tocorner(ncorner)
skip() = begin
    inrest[] = !inrest[]
    !inrest[] ? paused[] = false : nothing
end
playpause() = begin
    paused[] = !paused[]
    if !paused[]
    end
end
println(time()-starttime)
@qmlfunction println backtocorner skip playpause
engine = loadqml(qml_file, pomo=JuliaPropertyMap( "width" => width, "height" => height, "windowcolor" => windowcolor, "color" => color, "x" => x, "y" => y, "timestring" => timestring, "visible" => visible, "paused" => paused, "inrest" => inrest, "frozen" => frozen, "opacity" => opacity, "font" => font, "fontsize" => fontsize))
# QML.watchqml(engine, qml_file)

#time
function mytime()
    # seconds = (time()÷1) % 60
    minutes = (time()÷60) % 60
    hours = ((time()÷(60*60)) + 13) % 24
    return Int.([hours, minutes]) #, seconds])
end

ticking = false
function tick()
    global ticking
    if !paused[] && !ticking
        ticking = true
        t[] = t[]-1
        if inrest[]
            font[] = "Verdana"
            timestring[] = daochap(daycount()-2) * formattime(t[])
        else
            font[] = "Meslo LG S"
            timestring[] = formattime(t[])
        end
        sleep(1)
        if t[] ≤ 0
            inrest[] = !inrest[] # triggers all other things... except ticking now
        end
        ticking = false
        tick()
    end
end

meditated = false
function automate()
    while true
        global scrflag, meditated
        if isfile(scrflag)
            rm(scrflag)
            frozen[] = true
            !inrest[] ? paused[] = true : nothing
        end
        mytime() < [17;00] ? meditated = false : nothing
        if mytime() > [17;00] && meditated == false
            if !inrest[]
                ncorner = 4
                inrest[] = true
                t[] = medtime() * 60
            elseif t[] < 1
                meditated = true
            end
        end
        if [00;00] < mytime() < [07;00] || mytime() > [23;59 - daycount()]
            paused[] = false
            color[] = white
            if !inrest[]
                inrest[] = true
                t[] = 15*60
            elseif t[] < 61 && paused[] == false
                paused[] = true
                color[] = "black"
            end
        end
        sleep(1)
    end
end

function daochap(n)
    n = (n-1)%81 + 1
    book = read("C:/Users/Gal/Calibre Library/Wu, Charles Q.; Wu, Charles Q.; Wu,/Thus Spoke Laozi (9)/Thus Spoke Laozi - Wu, Charles Q.; Wu, Charles Q.;.txt", String);
    r = Regex("($n" * raw"\r\n\r\n(.|\n){10,1600}?" * "(?=COMMENTARY))")
    raw = match(r, book).captures[1]
    english = replace(raw, r"\n?[^A-z,?:.;—\n]+(?=(\W+\p{Lu}))" => "\n", "\r" => "")
    rightlines = replace(english, r"\n\n\n+" => "\n\n")
end

scrflag = joinpath(homedir(), ".dimpomodoro", "screensaver.flag")
isfile(scrflag) ?  rm(scrflag) : nothing
Threads.@spawn automate()
paused[] = false
exec_async()

println(time()-starttime)

# elseif mytime()[2:3] == [00;15]
#     for i in ("web", "projects/pomodoro", "dotfiles")
#         println(i)
#         # try
#         #     run(`pwsh /C cd /Users/Gal/home/$i` & `git add .` & `git commit -m \"hourly\" ` & `git push`; wait=true)
#         # catch
#         # end
#     end
