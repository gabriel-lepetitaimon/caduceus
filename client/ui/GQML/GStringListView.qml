import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme/colors.js" as Color

Item {
    id: root

    signal modelNeedUpdate(var model)
    signal dropped(int row, var event)
    property alias model: list.model
    property bool editable: false

    clip: true

    ListView{
        anchors.fill: parent
        id: list
        delegate: Item{
            height: 25
            width: list.width
            Rectangle{
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: separator.top
                color: Color.background

                TextInput{
                    anchors.fill: parent
                    anchors.margins: 3
                    verticalAlignment: Text.AlignVCenter
                    id: button
                    text: modelData
                    onEditingFinished: updateModel(index, text)
                    enabled: editable
                    color: Color.foreground
                }

                DropArea{
                    anchors.fill: parent
                    onDropped: root.dropped(index, drop.text)
                }
            }

            Rectangle{
                id: separator
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 2
                anchors.rightMargin: 2

                height: 1
                color: Color.lightForeground
            }
        }
    }

    function updateModel(row, data){
        var new_model = []
        for(var i=0; i<model.length; i++){
            if(i!==row)
                new_model[i] = model[i]
            else
                new_model[i] = data
        }
        root.modelNeedUpdate(new_model)
    }
}
