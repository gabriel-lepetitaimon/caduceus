import QtQuick 2.6
import QtGraphicalEffects 1.0

import "../theme/colors.js" as Color

Rectangle {
    id: root

    property bool editable: true
    property bool asLabel: false

    property color borderColor: Color.lightForeground
    property color textColor: Color.foreground
    property color placeholderColor: Color.darkForeground
    property color selectionColor: Color.background
    property color selectedTextColor: Color.foreground
    property alias font: textInput.font
    property alias text: textInput.text
    property string placeholder: ''
    property int textLeftMargin: 0
    property int textRightMargin: 0
    property alias textHAlign:textInput.horizontalAlignment
    property alias validator: textInput.validator

    color: asLabel ? 'transparent' : Color.lightBackground
    border.color: borderColor
    border.width: !asLabel || textInput.focus ? 1 : 0

    signal editingFinished()
    signal accepted()
    signal upPressed()
    signal downPressed()

    radius: 3
    clip: true

    Rectangle{
        id: border
        anchors.fill: parent
        radius: parent.radius
        visible: false
        border.color: '#FFFFFFF11'
        color: 'transparent'
    }
    DropShadow {
        anchors.fill: border
        radius: 10.0
        samples: 16
        spread: 0.5
        color: borderColor
        source: border
        cached: true
        opacity: textInput.focus ? 0.4 : 0
        Behavior on opacity { NumberAnimation{duration: 200} }
    }

    TextInput{
        id: textInput
        anchors.fill: parent
        anchors.margins: parent.radius
        anchors.leftMargin: parent.radius + root.textLeftMargin
        anchors.rightMargin: parent.radius + root.textRightMargin

        font.pixelSize: height*0.7
        selectByMouse: true
        color: root.textColor
        selectionColor: root.selectionColor
        selectedTextColor: root.selectedTextColor
        verticalAlignment: Text.AlignVCenter
        onEditingFinished:{
            focus = false
            root.editingFinished()
        }
        onAccepted: root.accepted()

        Keys.onPressed: {
                  if (event.key === Qt.Key_Up) {
                      root.upPressed()
                      event.accepted = true
                  }else if(event.key === Qt.Key_Down){
                      root.downPressed()
                      event.accepted = true
                  }
              }
        Text {
            text: root.placeholder
            color: root.placeholderColor
            visible: !textInput.text
        }
    }

}

