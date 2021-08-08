import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

import "../theme/colors.js" as Color

TextField {
    id: field
    function raise(){
        field.focus = true;
        field.state = 'RAISED'
        raiseTimer.restart()
    }

    placeholderTextColor: Material.hintTextColor;

    Timer{
        id: raiseTimer
        onTriggered: {
            field.state = "BASE"
        }
        interval: 3000
        repeat: false
    }

    state: "BASE"
    states: [
        State {
            name: "BASE"
            PropertyChanges {
                target: field
                placeholderTextColor: Material.hintTextColor
            }
        },
        State {
            name: "RAISED"
            PropertyChanges {
                target: field
                placeholderTextColor: Color.red;
            }
        }
    ]
    transitions: [
        Transition {
            from: "BASE"; to: "RAISED"
            ColorAnimation {target: field; duration: 100; easing.type: Easing.OutCubic}
        },
        Transition {
            from: "RAISED"; to: "BASE"
            ColorAnimation {target: field; duration: 2000; easing.type: Easing.InOutQuad}
        }
    ]
}
