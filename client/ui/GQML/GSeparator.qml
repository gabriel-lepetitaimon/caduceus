import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme/colors.js" as Color

Item {
    property var orientation: Qt.Horizontal
    property real scale: 0.7
    property real lineWidth: 1
    property alias color: separator.color

    onOrientationChanged: {
        if(orientation == Qt.Horizontal){
            anchors.left = parent.left
            anchors.right = parent.right
            height = Qt.binding(function(){return lineWidth})
        }else{
            anchors.top = parent.top
            anchors.bottom = parent.bottom
            width = Qt.binding(function(){return lineWidth})
        }
    }

    Rectangle{
        id: separator
        width: !orientation===Qt.Horizontal ? lineWidth : parent.width*scale
        height: orientation===Qt.Horizontal ? lineWidth : parent.height*scale
        anchors.centerIn: parent
        color: Color.foreground
    }
}
