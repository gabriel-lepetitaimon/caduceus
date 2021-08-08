import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import "../theme/colors.js" as Color

Item {
    id: root
    property real value: 0
    property real min: 0
    property real max: 0
    signal editingFinished()
    property string mode: 'linear'

    property int orientation: Qt.Horizontal
    property bool isH: orientation === Qt.Horizontal
    property color color: Color.foreground

    property real diskRadius: 10
    height: 50
    width: 200

    Rectangle{
        id: sliderLine
        radius: 5
//        height: isH ? 10 : parent.height *0.9
//        width: !isH ? 10 : parent.width * 0.9
        height: 7
        width: parent.width - 2*diskRadius

        anchors.centerIn: parent

        color: Qt.lighter(root.color, 0.8)
        border.color: Qt.lighter(root.color, 0.6)
        border.width: 1

        DropShadow{
            id: cursorShadow
            anchors.fill: cursor
            source: cursor
            radius: 10
            spread: 0.05
            color: Qt.lighter(cursor.sliderColor, 0.2)
            opacity: 0.3
            Behavior on opacity { NumberAnimation{duration: 200} }
        }
        Rectangle{
            id: cursor
            radius: diskRadius
            width: diskRadius*2
            height: diskRadius*2

            property color sliderColor: root.color
            Behavior on color { ColorAnimation{duration: 200} }

            gradient: Gradient{
                GradientStop{position: 0.0; color: Qt.lighter(cursor.sliderColor, 1.1)}
                GradientStop{position: 1.0; color: Qt.lighter(cursor.sliderColor,0.9)}
            }

            border.color: Qt.lighter(root.color, 0.8)
            border.width: 1

            x: -diskRadius + valueToX(value)
            y: -diskRadius + sliderLine.height/2
        }
    }
    GMouseArea{
        property bool trackMovement: false
        onPressed: {value = xToValue(mouse.x); trackMovement=true}
        onMouseXChanged: {if(trackMovement) value = xToValue(mouse.x)}
        onReleased: {root.editingFinished(); trackMovement=false}
        onEntered: {
            cursor.color = Qt.lighter(root.color, 1.1)
            cursorShadow.opacity = 0.7
        }
        onExited: {
            cursor.color = Qt.lighter(root.color, 1)
            cursorShadow.opacity = 0.3
            root.editingFinished()
            trackMovement=false
        }
    }

    function xToValue(x){
        var v = 0
        x = (x-sliderLine.x) / sliderLine.width
        x = Math.min(1, Math.max(0, x))
        if(mode=='linear')
            v = x
        else if(mode=='square')
            v = Math.pow(x, 2)
        else if(mode=='cube')
            v = Math.pow(x, 3)
        else if(mode=='exp')
            v = (Math.exp(x)-1)/Color.exp1M1
        return (v*(max-min))+min
    }

    function valueToX(value){
        var x = 0
        var v = (value-min) / (max-min)
        v = Math.min(1, Math.max(0, v))
        if(mode=='linear')
            x = v
        else if(mode=='square')
            x = Math.sqrt(v)
        else if(mode=='cube')
            x = Math.pow(v, 1/3)
        else if(mode=='exp')
            x = Math.log(v*Color.exp1M1+1)

        return  x * sliderLine.width
    }
}
