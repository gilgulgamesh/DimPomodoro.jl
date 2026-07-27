#QML Application engin.
# =========================
# others are quickview and component.
#  -- QV always has a window without asking.
#  -- component has a lot of steps


mktempdir() do folder
    path = joinpath(folder, "main.qml")
    write(path, """
    import QtQuick
    import QtQuick.Controls
    ApplicationWindow {
    visible: true
    Text {
        text: greeting
    }
    Timer {
        running: true; repeat: false
        # onTriggered: Qt.exit(0)
    }
    }
    """)
    loadqml(path; greeting = "Hello, World!")
    exec()
end

#i've been using
JuliaPropetyMap
@qmlfunction
#could use @emit for signals instead of on off things.

using QML

using Colors

function simple_image(julia_display::JuliaDisplay)
    display(julia_display, RGB.(rand(50,50)))

end

@qmlfunction simple_image

using QML

mktempdir() do folder
    path = joinpath(folder, "main.qml")
    write(path, """
    import QtQuick
    import QtQuick.Controls
    ApplicationWindow {
    visible: true
    color:white
    TextArea {
         text: greeting
        font: "Juliamono"
        //height: 100
        //width: 100
      //  font.pointSize: 15
    }
    Timer {
        running: true; repeat: false
        // onTriggered: Qt.exit(0)
    }
    }
    """)
    loadqml(path; greeting = "Hello, World!")
    exec()
end


ir() = trunc(Int, 12rand())

for k in 1:100
    seed = (ir(), ir(), ir())
    i = (230, 230, 230) .+ seed
    j = 3 .* seed
    for l in 1:10
        println(Crayon(foreground = j, background = i), "Bluish on yellow")
    end
end


#take each letter,
# convert to int,
Int(l)%26
# square,
# nahhh
# mod 25,
# use as ir

Int(l)%26

function seed(str)
    b, a, c = str[end-2:end]
    (Int(a)%26, Int(b)%26, Int(c)%26)
end
function nameprint(name)
    sd = seed(name)
    i = (230, 230, 230) .+ sd
    j = 3 .* sd
    for l in 1:10
        println(Crayon(foreground = j, background = i), "Bluish on yellow")
    end
end


"�".charCodeAt(0)
