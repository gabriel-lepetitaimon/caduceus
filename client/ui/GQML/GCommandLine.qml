import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property var cmdHistory: []
    property int history_id: -1

    signal execCmd(string cmd)

    property alias borderColor: lineEdit.borderColor
    property alias textColor: lineEdit.textColor
    property alias font: lineEdit.font
    property alias text: lineEdit.text
    property alias textLeftMargin: lineEdit.textLeftMargin
    property alias textRightMargin: lineEdit.textRightMargin
    property alias textHAlign: lineEdit.textHAlign
    property alias radius: lineEdit.radius

    height: 50
    width: 100

    GLineEdit{
        id: lineEdit
        anchors.fill: parent
        onAccepted: {
            execCmd(text)
            history_id = -1
            cmdHistory.splice(0,0, text)
            text = ""
        }

        onUpPressed:{
            if(history_id >= cmdHistory.length)
                return
            history_id++
            text = cmdHistory[history_id]
        }
        onDownPressed:{
            if(history_id <= 0){
                history_id = -1
                text = ''
            }else{
                history_id--
                text = cmdHistory[history_id]
            }
        }
    }
}
