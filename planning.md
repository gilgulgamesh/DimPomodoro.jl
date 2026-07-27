...#QML Application engin.
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

mktempdir() do folder
    path = joinpath(folder, "main.qml")
    write(path, """
    import QtQuick
    import QtQuick.Controls
    import QtQuick.Layouts
    import jlqml
    ApplicationWindow {
    visible: true
    JuliaDisplay {
        id: julia_display
        width: 500
        height: 500
        Component.onCompleted: {
        Julia.simple_image(julia_display)
        }
    }
    Timer {
        interval: 2000; running: true; repeat: false
        // onTriggered: Qt.exit(0)
    }
    }
    """)
    loadqml(path)
    exec()
end;
