import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.3

import "global/login"
import "theme/colors.js" as Color

Window {
    width: 1200
    height: 800
    visible: true
    color: Color.background
    title: qsTr("Caduceus")

    Material.theme: Material.Dark
    Material.accent: Material.LightBlue

    Main{
        id: root
        anchors.fill: parent

        states: [
            State {
                name: "base" // LOGIN
            },
            State {
                name: "loggedin"
            }
        ]

        LoginDesktop{
            id: loginPanel
            anchors.centerIn: parent
            radius: 5
        }
        DropShadow {
             anchors.fill: loginPanel
             cached: true
             horizontalOffset: 3
             verticalOffset: 3
             radius: 14
             samples: 20
             color: "#4d000000"
             source: loginPanel
             visible: loginPanel.visible
        }
    }
}
