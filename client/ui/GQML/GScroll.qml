import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme/colors.js" as Color

Item {
    id: root

    property int orientation: Qt.Vertical
    property int scrollWidth: 6
    property real ratio: 1
    property real pos: 0

    signal requestPos(real pos)

    visible: ratio < 1

    Component.onCompleted: {
        if(orientation==Qt.Vertical){
            anchors.right = Qt.binding(function(){return parent.right;})
            anchors.top = Qt.binding(function(){return parent.top;})
            anchors.bottom = Qt.binding(function(){return parent.bottom;})
            width = scrollWidth*2
        }else{
            anchors.right = Qt.binding(function(){return parent.right;})
            anchors.left = Qt.binding(function(){return parent.left;})
            anchors.bottom = Qt.binding(function(){return parent.bottom;})
            height = scrollWidth*2
        }
    }

    onPosChanged: {
        slider.opacity = 0.5
        hideTimer.restart()
    }
    onRatioChanged: {
        slider.opacity = 0.5
        hideTimer.restart()
    }

    Timer{
        id: hideTimer
        interval: 1000
        repeat: false
        onTriggered: slider.opacity = 0
    }

    Rectangle{
        id: slider
        radius: 4
        color: Color.foreground
        opacity: 0
        Behavior on opacity {NumberAnimation{duration:100}}
        visible: opacity > 0

        Component.onCompleted: {
            if(orientation==Qt.Vertical){
                width = scrollWidth
                x = scrollWidth -2
                height = Qt.binding(function(){return ratio*parent.height})
                y = Qt.binding(function(){return pos*(1-ratio)*parent.height})
            }else{
                height = scrollWidth
                y = scrollWidth -2
                width = Qt.binding(function(){return ratio*parent.width})
                x = Qt.binding(function(){return pos*(1-ratio)*parent.width})
            }
        }
    }

    GMouseArea{
        onEntered: {
            slider.opacity = 0.5
            hideTimer.stop()
        }
        onExited: hideTimer.start()

        onPressed: {
            if(ratio==1){
                mouse.accepted=false
                return
            }
            mousePos(mouse)
        }
        onPositionChanged: {
            if(mouse.buttons & Qt.LeftButton)
                mousePos(mouse)
        }

        function mousePos(mouse){
            var pos = 0;
            if(root.orientation==Qt.Vertical)
                pos = (mouse.y-slider.height/2)/(height-slider.height)
            else
                pos = (mouse.x-slider.width/2)/(width-slider.width)
            pos = Math.max(0, Math.min(1, pos))
            root.requestPos(pos)
        }
    }
}
