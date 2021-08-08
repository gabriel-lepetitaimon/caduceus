import QtQuick 2.0
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.3
import QtQuick.Timeline 1.0
import Caduceus 1.0

import "../../GQML"
import "../../theme/colors.js" as Color

Rectangle {
    id: root
    height: 40; width: 1200
    color: Color.background

    property string activeSettings: "None"

    function reset(){
        activeSettings = "None";
    }

    Row{
        GIcon{
            id: userIcon
            symbol: Icons.faUserCircle
            onClicked: root.activeSettings = highligted ? 'None' : "user"
            highligted: root.activeSettings=="user"
        }
        Rectangle{
            width: 8
            height: 1
            color: Color.transparent
        }
        GIcon{
            id: settingsIcon
            symbol: Icons.faCog
            onClicked: root.activeSettings = highligted  ? 'None' : "app"
            highligted: root.activeSettings=="app"
        }

        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12
    }
}
