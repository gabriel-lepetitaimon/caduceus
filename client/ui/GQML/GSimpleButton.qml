import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme/colors.js" as Color

Rectangle{
    id: button

    signal clicked()
    signal released()
    signal pressed()
    signal entered()
    signal exited()
    property string icon: ""
    property bool hideIcon: false
    property string title: ""
    property alias clickable: mouseArea.enabled
    property color foregroundColor: Color.foreground
    property alias titleFont: titleLabel.font
    property real titleFontSize: parent.height*0.5
    property alias titleHAlignement: titleLabel.horizontalAlignment
    default property alias components: suffixItems.children
    property alias iconColorShift: iconImage.colorShift

    property color normalColor: Color.background
    property color hoverColor: Color.backgroundHover
    property bool threeD: false


    color: normalColor
    Behavior on color{ ColorAnimation {duration: 200} }
    property var threeDGradient: Gradient{
        GradientStop{position:0.0; color: Qt.lighter(button.color, 3)}
        GradientStop{id: lightStop; position:2/height; color: Qt.lighter(button.color, 1.8)}
        GradientStop{id: darkStop; position:1.0; color: button.color}
    }
    gradient: threeD ? threeDGradient : null

    GMouseArea{
        id: mouseArea
        onEntered: {
            button.entered()
            button.color = button.hoverColor
        }
        onExited:  {
            button.exited()
            button.color = button.normalColor
        }

        onClicked: button.clicked()
        onPressed: {
            darkStop.position = Qt.binding(function() {return 2/button.height})
            lightStop.position = 1.0
            button.pressed()
        }
        onReleased: {
            lightStop.position = Qt.binding(function() {return 2/button.height})
            darkStop.position = 1.0
            button.released()
        }


        GIcon{
            id: iconImage
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            foreground: button.foregroundColor
            source: button.icon
            scale: 0.8
            visible: !button.hideIcon && button.icon !== ''
        }

        Text{
            id: titleLabel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: button.hideIcon ? 5 : 5+parent.height
            anchors.right: parent.right

            color: button.foregroundColor
            font.pixelSize: titleFontSize
            text: title
            verticalAlignment: Text.AlignVCenter
            visible: title != ''
        }



        Row{
            id: suffixItems
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            layoutDirection: Qt.RightToLeft
        }
    }
}
