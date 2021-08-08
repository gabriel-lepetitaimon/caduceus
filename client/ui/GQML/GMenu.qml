import QtQuick 2.15
import QtQuick.Controls 2.15

import "../theme/colors.js" as Color

Item{

    id: root
    property int elementHeight: 40
    property int maxHeight: 4*elementHeight + headerMenuTitle.height + 8
    property string title: ''
    property var model: []
    property var modelCount: 0
    default property string modelElement: ''
    onModelElementChanged: {model.push(modelElement); listView.model=model; modelCount = model.length}

    height: Math.min(elementHeight*modelCount+headerMenuTitle.height+8, maxHeight)
    width: 250

    opacity: 0
    visible: opacity
    Behavior on opacity {NumberAnimation{duration: 50}}

    signal aboutToShow()

    function show(){
        aboutToShow()
        opacity = 1
        focusScope.focus = true
    }

    function hide(){
        opacity = 0
        focusScope.focus = false
    }

    FocusScope{
        id: focusScope
        anchors.fill: parent
        onFocusChanged: {
            if(!focus)
                root.hide()
        }

    Rectangle{
        id: background
        color: Color.darkBackground
        radius:  3

        border.color: Color.lightForeground
        border.width: 1

        z: 20
        clip: true
        anchors.fill: parent

        Rectangle{
            id: headerMenuTitle
            color: Qt.lighter(Color.darkBackground, 0.7)
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: parent.border.width
            radius: parent.radius
            height: title!='' ? 18 : 0
            visible: height != 0
            Text{
                text: title
                anchors.fill: parent
                font.capitalization: Font.SmallCaps
                font.bold: true
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: height*0.6
                color: Color.foreground
            }
        }

        ListView{
            id: listView
            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            anchors.top: headerMenuTitle.bottom
            anchors.margins: parent.border.width
            clip: true
            model: []
            boundsBehavior: Flickable.StopAtBounds
            delegate: Item{
                anchors.left: parent.left; anchors.right: parent.right;
                height: elementHeight

                Separator{
                    id: separator
                    orientation: Qt.Horizontal
                    anchors.top: parent.top
                    visible: index
                    color: Color.lightForeground
                }
                GSimpleButton{
                    id: textLabel
                    title: modelData.label
                    titleFontSize: 13
                    hideIcon: true
                    clickable: modelData.type !== 'label'

                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: separator.bottom
                    anchors.margins: 2

                    normalColor: Color.darkBackground
                    hoverColor: Qt.lighter(Color.darkBackground, 1.2)

                    titleHAlignement: modelData.type === 'button' || modelData.type==='flat' ? Qt.AlignHCenter : Qt.AlignLeft
//                    titleFont.capitalization: type == 'button' ? Font.SmallCaps : Font.MixedCase
                    threeD: modelData.type === 'button'
                    onPressed: modelData.set('pressed', true)
                    onReleased: modelData.set('pressed', false)

                    GLineEdit{
                        width: modelData.type==='number' ? 50 : parent.width * .65
                        height: 21
                        anchors.verticalCenter: parent.verticalCenter
                        visible: modelData.type==='text' || modelData.type==='number'

                        textHAlign: modelData.type === 'number'? Qt.AlignHCenter : Qt.AlignLeft
                        text: modelData.type==='text' ? modelData.value : modelData.value.toString()
                        property var doubleValidator: DoubleValidator{}
                        Component.onCompleted: {
                            if(modelData.type === 'number')
                                validator = doubleValidator
                        }
                        onAccepted: modelData.accepted()
                        onEditingFinished: {
                            if(modelData.type==='text')
                                modelData.value = text
                            else if(modelData.type==='number')
                                modelData.value = Number(text)
                            modelData.editingFinished()
                            text = Qt.binding(function(){return modelData.type==='text' ? modelData.value : modelData.value.toString()})
                        }
                    }
                    GSlider{
                        width: parent.width*0.4
                        height: parent.height*0.8
                        anchors.verticalCenter: parent.verticalCenter
                        visible: modelData.type==='range'

                        onEditingFinished: {modelData.editingFinished(); modelData.accepted(); value = Qt.binding(function(){return modelData.value})}
                        value: modelData.value
                        onValueChanged: {
                            if(modelData.value !== value)
                                modelData.value = value
                        }
                        mode: modelData.sliderMode
                        min: modelData.min
                        max: modelData.max
                 }
                }

            }
        }
    }

    }

    DropShadow{
        z: 5
        anchors.fill: parent
        source: background
        spread: 0.01
        color: 'black'
        opacity: 0.7
        radius: 10
    }

}
