import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string label: ''
    property string type: 'flat'
    property var value: ""

    property real min: 0
    property real max: 1
    property string sliderMode: 'linear'

    signal clicked()
    signal editingFinished()
    signal accepted()

    property bool pressed: false
    onPressedChanged: {
        if(pressed == false)
            clicked()
    }
    function set(name, value){
        if(name==='value')
            root.value = value
        else if(name==='pressed')
            root.pressed = value
    }
}
