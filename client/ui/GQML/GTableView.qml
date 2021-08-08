import QtQuick 2.15
import QtQuick.Controls 2.15

import "../theme/colors.js" as Color

Item {
    id: root

    property alias mainModel: tableView.model
    property var selection: []
    property var lastSelection: []
    property var smartSelection: toSmartSelection(selection)
    signal addedToSelection(var added)
    signal removedFromSelection(var removed)
    property int currentColumn: -1
    property int currentRow:  -1
    property string currentColumnName: currentColumn<0 ? "" : columnView.model[currentColumn]
    property int offset: 0

    signal cornerClicked()

    onSelectionChanged: {
        var removed = []
        var added = []
        for(var i=0; i<lastSelection.length; i++){
            if(selection.indexOf(lastSelection[i])==-1)
                removed.push(lastSelection[i])
        }
        for(i=0; i<selection.length; i++){
            if(lastSelection.indexOf(selection[i])==-1)
                added.push(selection[i])
        }

        root.addedToSelection(added)
        root.removedFromSelection(removed)

        if(!lastSelection.length && selection.length){
            currentColumn = Qt.binding(function(){return selection[0][1]})
            currentRow = Qt.binding(function(){return selection[0][0]})
        }

        lastSelection = selection.slice()
    }

    onCurrentColumnNameChanged: {
        if(columnView.model[currentColumn] !== currentColumnName){
            var column = columnView.model.indexOf(currentColumnName)
            if(column!==-1)
                selection[0][1] = column
        }
        currentColumnName = Qt.binding(function(){return columnView.model[currentColumn]})
        tableView.tryContentXY( columnXOffset(currentColumn) - tableView.width/2, tableView.contentY, true)
    }

    onCurrentRowChanged: {
        tableView.tryContentXY(tableView.contentX, (currentRow+1)*(rowHeight+rowSpacing)-(tableView.height/2), true)
    }

    property var columnMinWidth: []
    property int columnCount: 0
    property int totalMinWidth: columnMinWidth.reduce(function(a,b){return a+b;},0)
    property real columnWFactor: (head.width-(columnSpacing*columnMinWidth.length))/(totalMinWidth)
    property int columnSpacing: 2
    property string columnOrdered: ""
    property bool orderDescent: false
    property bool multiSelection: true

    property int rowHeight: 70
    property int rowSpacing: 2

    signal elementDoubleClicked()

    Component.onCompleted: {
        mainModel.qKeysChanged.connect(keysChanged)
    }

    function keysChanged(){
        var keys = mainModel.qKeys
        var c = columnMinWidth.slice()
        while(c.length < keys.length)
            c.push(30)

        columnMinWidth = c
        columnView.model = keys
        columnCount = c[0]===null? 0 : c.length
    }

    Timer {
        id: resetColumnsWidthTimer
        interval: 1000;  repeat: false
        onTriggered: {
            var c = []
            for(var i=0; i<columnCount; i++)
                c.push(30)
            columnMinWidth = c
            root.resetColumnsWidth()}
    }
    onWidthChanged: resetColumnsWidthTimer.restart()
    onHeightChanged: resetColumnsWidthTimer.restart()
    signal resetColumnsWidth()

    function columnXOffset(column){
        var offset = 0;
        for(var i=0; i < column; ++i)
            offset += columnMinWidth[i];
        var f = columnWFactor;
        return (f>1? offset*f : offset)+column*columnSpacing;
    }
    function columnWidth(column){
        var f = columnWFactor;
        return f>1? columnMinWidth[column]*f : columnMinWidth[column];
    }

    function updateColumnWidth(column, width){
        var c = columnMinWidth.slice();
        if(c[column] < width){
            c[column] = width;
        }
        columnMinWidth = c;
    }

    // ------ CORNER ------
    GSimpleButton{
        id: corner
        anchors.left: parent.left
        anchors.top: parent.top
        width: 30
        height: 25

        normalColor: Color.lightBackground
        onClicked: root.cornerClicked()
    }

    // ------ HEAD ------
    Rectangle{
        id: head
        color: Color.lightBackground
        clip: true

        anchors.top: parent.top
        anchors.left: corner.right
        anchors.right: parent.right
        height: corner.height

        Repeater{
            id: columnView
            anchors.fill: parent
            clip: true
            model: []
            delegate: Rectangle{
                color: isColumnSelected(selection, index) ? Color.background : Color.darkBackground
                x: columnXOffset(index) - tableView.contentX
                y: 0
                width: columnWidth(index)
                height: parent.height-columnSpacing

                Text{
                    anchors.fill: parent
                    text: (columnOrdered==modelData? (orderDescent?'↥ ':'↧ ') :'')+modelData
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Color.foreground
                    property var aliasRoot: null
                    Component.onCompleted: root.updateColumnWidth(index, contentWidth+4)
                    Connections{
                        target: root
                        onResetColumnsWidth: target.updateColumnWidth(index, parent.contentWidth+4)
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(!mainModel.isImage(0, modelData)){
                            if(columnOrdered==modelData)
                                orderDescent = !orderDescent
                            else
                                columnOrdered = modelData
                        }
                    }
                }
            }
        }
    }

    // ------ ROW NUMBER ------
    Rectangle{
        id: rowNumbers
        color: Color.lightBackground
        clip: true

        anchors.left: parent.left
        anchors.top: corner.bottom
        anchors.bottom: parent.bottom
        width: corner.width

        Repeater{
            anchors.fill: parent
            model: mainModel.qRowCount
            clip: true

            delegate: Rectangle{
                color: isRowSelected(selection, index) ? Color.background : Color.darkBackground
                x: 0
                y: index*(rowHeight+rowSpacing) - tableView.contentY
                width: parent.width-rowSpacing
                height: rowHeight

                Text{
                    anchors.fill: parent
                    text: (index+offset+1).toString()
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Color.foreground
                }
            }
        }
    }


    // ------  VIEW   -------
    MouseArea{
        anchors.left: rowNumbers.right
        anchors.top: head.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onPressed: {mouse.accepted = false; parent.focus=true}
        onWheel: {
            var deltaX = wheel.angleDelta.x / 2
            var deltaY = wheel.angleDelta.y / 2
            tableView.tryMoveContentXY(-deltaX, -deltaY)
        }
        GScroll{
            orientation: Qt.Vertical
            ratio: tableView.height/tableView.contentHeight
            pos: tableView.contentY/(tableView.contentHeight-tableView.height)
            onRequestPos: tableView.contentY = pos*(tableView.contentHeight-tableView.height)
        }

        GScroll{
            orientation: Qt.Horizontal
            ratio: tableView.width/tableView.contentWidth
            pos: tableView.contentX/(tableView.contentWidth-tableView.width)
            onRequestPos: tableView.contentX = pos*(tableView.contentWidth-tableView.width)
        }

        Rectangle{
            anchors.fill: parent
            clip: true
            color: Color.lightBackground
            ListView{
                id: tableView
                anchors.fill: parent
                flickableDirection: Flickable.AutoFlickDirection
                contentWidth: columnWFactor>=1 ? -1 : totalMinWidth+(columnCount*columnSpacing)

                onContentWidthChanged: tryMoveContentXY(0, 0)
                onContentHeightChanged: tryMoveContentXY(0, 0)

                spacing: rowSpacing
                delegate: Row{
                    id: tableRow
                    property int row: index
                    height: rowHeight
                    spacing: columnSpacing
                    Repeater{
                        id: repeater
                        model: columnView.count
                        delegate: Rectangle{
                            id: cell
                            property string col: columnView.model[index]
                            clip: true
                            height: rowHeight
                            width: columnWidth(index)
                            color: isRowSelected(selection, row) ? Color.lightBackground : Color.background
                            Text{
                                id: cellText
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: visible ? mainModel.get(row, col) : ""
                                color: Color.foreground
                                wrapMode: Text.Wrap
                                visible: mainModel.isString(row, col)
                                Component.onCompleted: root.updateColumnWidth(index, contentWidth+4)
                                Connections{
                                    target: root
                                    onResetColumnsWidth: {
                                        var f = Math.max(cellText.contentHeight / cellText.height, 1)
                                        target.updateColumnWidth(index, cellText.contentWidth*f + 4)
                                    }
                                }
                            }

                            PythonImage{
                                id: cellImage
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                row: tableRow.row
                                key: visible ? col : ""
                                model: mainModel.name
                                mimeUrl: "table:"+mainModel.tableName()+'|data|'+index.toString()
                                border: containsCell(selection, [row, index]) ? 4 : 0
                                borderColor: currentColumn==index && currentRow==row ? "white" : Color.foreground

                                visible: mainModel.isImage(row, col)
                                onLoaded: if(visible) root.updateColumnWidth(index, paintedWidth+4)
                                Connections{
                                    target: root
                                    onResetColumnsWidth: if(cellImage.visible) target.updateColumnWidth(index, cellImage.paintedWidth+4)
                                }

                                onClicked: {
                                    var cell = [row, index]

                                    if(mouse.modifiers & Qt.ControlModifier){
                                        var idCell = indexOfCell(selection, cell)
                                        var s = selection.slice()
                                        if(idCell !==-1 )
                                            s.splice(idCell, 1)
                                        else
                                            s[s.length] = cell
                                        selection = s
                                    }else if(mouse.modifiers & Qt.ShiftModifier){
                                        if(selection == [])
                                            selection = [cell]
                                        else{
                                            var dR = row>currentRow?+1:-1
                                            var dC = index>currentColumn?+1:-1
                                            var s = []
                                            for(var r=currentRow; r!==row+dR; r+=dR){
                                                for(var c=currentColumn; c!==index+dC; c+=dC){
                                                    if(mainModel.isImage(r,columnView.model[c]))
                                                        s[s.length] = [r,c]
                                                }
                                            }
                                            selection = s
                                        }
                                    }else
                                        selection = [cell]
                                }
                                onDoubleClicked: root.elementDoubleClicked()
                            }
                            MouseArea{
                                anchors.fill: parent
                                enabled: !cellImage.visible
                                onClicked: moveSelection(0, row-currentRow)
                            }
                        }
                    }
                }
                function tryMoveContentXY(x, y){
                    var contentX = tableView.contentX
                    var contentY = tableView.contentY
                    contentX += x
                    contentY += y
                    tryContentXY(contentX, contentY, false)
                }
                function tryContentXY(x,y, anim){
                    tableView.anim = anim
                    tableView.contentX = Math.max(0, Math.min(contentWidth-width, x))
                    tableView.contentY = Math.max(0, Math.min(contentHeight-height, y))
                    tableView.anim = false
                }
                property bool anim: false
                Behavior on contentX {NumberAnimation{id:xAnim; duration:tableView.anim?500:0; easing.type: Easing.InOutCubic; onStopped: tableView.anim=contentY.running}}
                Behavior on contentY {NumberAnimation{id:yAnim; duration:tableView.anim?500:0; easing.type: Easing.InOutCubic; onStopped: tableView.anim=contentX.running}}
            }
        }
    }

    focus: true
    Keys.onPressed: {
        if(event.key === Qt.Key_PageDown)
            tableView.tryMoveContentXY(0, -(rowHeight+rowSpacing))
        else if(event.key === Qt.Key_PageUp)
            tableView.tryMoveContentXY(0, +(rowHeight+rowSpacing))
        else if(event.key === Qt.Key_Up)
            moveSelection(0, -1)
        else if(event.key === Qt.Key_Down)
            moveSelection(0, +1)
        else if(event.key === Qt.Key_Left)
            moveSelection(-1, 0)
        else if(event.key === Qt.Key_Right)
            moveSelection(+1, 0)
    }

    function moveSelection(deltaX, deltaY){
        if(!selection.length){
            currentRow += deltaY
            currentColumn += deltaX
            return
        }

        var s = selection.slice()

        for(var i=0; i<s.length; i++){
            if(deltaY!==0){
                var row = s[i][0]+deltaY
                if(row>=0 && row<tableView.count)
                    s[i][0] = row
            }
            if(deltaX!==0){
                var col = s[i][1]+deltaX
                while(col>=0 && col<columnCount && !mainModel.isImage(row, columnView.model[col]))
                    col += deltaX>0 ? 1 : -1
                if(col>0 && col<columnCount)
                    s[i][1] = col
            }
        }
        selection = Color.uniq(s)
    }

    function containsCell(table, cell){
        for(var i=0; i<table.length; i++){
            if(cell[0]===table[i][0] && cell[1]===table[i][1])
                return true
        }
        return false
    }

    function isRowSelected(table, row){
        for(var i=0; i<table.length; i++){
            if(table[i][0]===row)
                return true
        }
        return false
    }
    function isColumnSelected(table, column){
        for(var i=0; i<table.length; i++){
            if(table[i][1]===column)
                return true
        }
        return false
    }

    function indexOfCell(table, cell){
        for(var i=0; i<table.length; i++){
            if(cell[0]===table[i][0] && cell[1]===table[i][1])
                return i
        }
        return -1
    }

    function toSmartSelection(table){
        var s = []
        for(var i=0; i<table.length; i++){
            var cell = table[i]
            var added=false
            for(var k=0; k<s.length; k++){
                if(cell[0]===s[k][0]){
                    s[k].push(columnView.model[cell[1]])
                    added=true
                    break
                }
            }
            if(!added)
                s.push([cell[0], columnView.model[cell[1]]])
        }
        return s
    }
}
