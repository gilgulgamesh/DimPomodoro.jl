import QtQuick
import QtQuick.Controls 6.0
import jlqml
import QtQuick.Window
import Qt.labs.platform



ApplicationWindow {
	id: window
	visible: pomo.visible
	flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
	color: pomo.windowcolor
	width:  pomo.width
	height: pomo.height
	x: pomo.x
	y: pomo.y
	title: "pomo"

	// Shortcut {
	// 	sequence: "F10"
	// 	context: Qt.ApplicationShortcut
	// 	onActivated:  pomo.visible = !pomo.visible
	// }

	SystemTrayIcon {
		visible: true
		icon.source: Qt.resolvedUrl("icon.png")

		onActivated: pomo.visible = !pomo.visible
		Component.onCompleted: {
			show()
		}

	}


	Text {
		opacity: pomo.opacity
		id:text
		anchors.centerIn: parent
		text: pomo.timestring
		font.pointSize: pomo.fontsize
		font.family: pomo.font
		color: pomo.color

  //      	SequentialAnimation on opacity {
		// 	running : false
		// 	id : animateToBright
		// 	NumberAnimation{  to: 0.85; duration: 0}

		// }
		// SequentialAnimation on opacity {
		// 	id : animateFromBright
		// 	running : false
		// 	NumberAnimation { to:0.75; duration:100 }
		// }
		// SequentialAnimation on opacity {
		// 	id : animateFromBrightPause
		// 	running : false
		// 	NumberAnimation { to: 0.2 ; duration: 100 }
		// 	PauseAnimation { duration: 600 }
		// }
		// SequentialAnimation on opacity {
		// 	id : animateFromBrightPlay
		// 	running : false
		// 	NumberAnimation { to:0.75; duration:200 }
		// 	PauseAnimation {duration: 200}
		// }


		// SequentialAnimation  on opacity{
		// 	id : animateBlink
		// 	loops: Animation.Infinite
		// 	running : pomo.paused // && !animateFromBrightPlay.running && !animateFromBrightPause.running
		// 	NumberAnimation {  to:0.2 ; duration:70}
		// 	NumberAnimation {  to:0.5 ; duration:2000}
		// 	NumberAnimation {  to:0.2 ; duration:2000}

		// }


	}

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.RightButton | Qt.MiddleButton | Qt.LeftButton
		onPressed: mouse => {
			if (mouse.button === Qt.LeftButton && !pomo.freeze) {
				window.startSystemMove() ;
				pomo.x = window.x;pomo.y = window.y
			} else {
				// animateToBright.start()
			}

		}

		onReleased: mouse => {
			if (mouse.button !== Qt.leftButton) {

			}
			if (mouse.button === Qt.RightButton) {
				// if (pomo.paused) {
				// 	animateFromBrightPlay.start()
				// } else {
				// 	animateFromBrightPause.start()
				// }
				Julia.playpause()
			}
			if (mouse.button === Qt.MiddleButton && !pomo.freeze) {
				// animateFromBright.start()
				Julia.backtocorner()
			}

		}
		onDoubleClicked: mouse => {
			if (mouse.button === Qt.LeftButton) {
				Julia.skip()
			}
		}
	}

	Component.onCompleted:  Julia.println("ready")
	// Component.onCompleted: console.log(Qt.version)

}
