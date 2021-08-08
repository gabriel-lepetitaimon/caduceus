import QtQuick 2.15
import QtQuick.Controls 2.15

MouseArea{
    id: root

    property bool customAnchors: false
    hoverEnabled: true

    property bool hovered: false

    Component.onCompleted: {
        if(!customAnchors)
            anchors.fill = Qt.binding(function() {return parent})
        QuickWidget.exited.connect(globalExited)
        QuickWidget.entered.connect(globalEntered)
    }

    function globalExited(){
        if(containsMouse && hoverEnabled)
            exited()
    }

    function globalEntered(){
        if(containsMouse && hoverEnabled)
            entered()
    }

    onEntered: hovered=true
    onExited: hovered=false
}
