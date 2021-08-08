import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import "../../theme/colors.js" as Color
import "../../GQML"

Rectangle {
    id: root
    color: Color.background

    width: 350
    Material.theme: Material.Dark
    Material.accent: Material.LightBlue

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: -1

        StackView{
            id: appSettings
            initialItem: Item{
                Column{
                anchors.fill: parent
                anchors.margins: 5
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("App Settings")
                    font.pixelSize: 17
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Light
                    color: Material.frameColor
                }

                RowLayout{
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Label {
                        text: qsTr("Interface Scale ")
                        Layout.alignment: Qt.AlignLeft
                    }
                    ToolButton {
                        id: uiScalePlus
                        text: "-"
                        Layout.alignment: Qt.AlignLeft
                    }
                    ToolButton {
                        id: uiScaleMinus
                        text: "+"
                        Layout.alignment: Qt.AlignLeft
                    }
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    ToolButton {
                        id: fullscreen
                        text: Icons.faExpand
                        font.family: "Font Awesome"
                        Layout.alignment: Qt.AlignRight
                    }
                }

                Rectangle{
                    height: 1
                    width: parent.width * .7
                    color: Material.frameColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

            }
            }
        }
        StackView{
            id: userSettings
            initialItem: Item{
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 5
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                Text {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;
                    text: qsTr("User Settings")
                    font.pixelSize: 17
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Light
                    color: Material.frameColor
                }
                Button{
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;
                    text: qsTr("Log out")
                    onClicked: AuthService.logout();
                }
            }
            }
        }
    }
    state: "None"
    visible: state != "None"
    enabled: visible

    states: [
        State { name: "None" },
        State { name: "app"
            PropertyChanges { target: stackLayout; currentIndex: 0 }
        },
        State { name: "user"
            PropertyChanges { target: stackLayout; currentIndex: 1 }
        }
    ]
}
