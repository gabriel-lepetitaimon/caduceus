import QtQuick 2.0
import "../../assets/fonts"
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Text {
    id: root
    signal clicked();

    property alias symbol: root.text
    property bool highligted: false

    height: 30
    color: highligted ? Material.accent : Material.foreground
    font.family: "Font Awesome"
    font.pixelSize: height

    MouseArea{
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onClicked: root.clicked();
    }

    layer.enabled: true
    layer.effect: DropShadow {
        color: mouseArea.containsMouse ? Material.accent : '#00000000'
        Behavior on opacity {ColorAnimation{duration: 500}}
        cached: true
        radius: 7
        samples: 15
    }
}
