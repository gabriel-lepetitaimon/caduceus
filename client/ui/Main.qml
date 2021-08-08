import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.12
import QtQuick.Controls.Material 2.3

import "global/login"
import "global/header"
import "global"
import "theme/colors.js" as Color

Item {
    id: root
    width: 1200
    height: 800

    Material.theme: Material.Dark
    Material.accent: Material.LightBlue

    state: "LOGIN"
    states: [
        State {
            name: "LOGIN"
            PropertyChanges {
                target: dimScreen
                opacity: 1
            }
        },
        State {
            name: "MAIN"
            PropertyChanges {
                target: dimScreen
                opacity: 0
            }
        }
    ]

    Connections{
        target: AuthService
        function onLoggedOut(){
            root.state = "LOGIN";
            resetUI();
        }
        function onLoginSucceed(){
            root.state = "MAIN";
        }
    }

    Component.onCompleted: {
        resetUI();
        loginPanel.reset();
        loginPanel.focus = true;
    }

    function resetUI(){
        header.reset();
    }

    MainArea{
        id: mainArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: header.bottom
        z: 10
    }

    Rectangle{
        id: dimMainArea
        anchors.fill: parent
        color: Color.background
        z: 40
        opacity: enabled ? .5 : 0
        Behavior on opacity { NumberAnimation { duration: 250} }
        enabled: settingsPanel.state != "None"

        signal clicked();
        MouseArea{
            anchors.fill: parent
            onClicked: dimMainArea.clicked();
        }
    }

    Header{
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 50
    }
    DropShadow {
         anchors.fill: header
         cached: true
         verticalOffset: 3
         radius: 14
         samples: 20
         color: "#40000000"
         source: header
         z: header.z-1
    }

    SettingsPanel{
        id: settingsPanel
        z: 45
        state: header.activeSettings
        anchors.right: parent.right
        anchors.top: header.bottom
        height: mainArea.height*.7
        Connections{
            target: dimMainArea
            function onClicked(){
                header.activeSettings = "None";
            }
        }
    }
    DropShadow {
         anchors.fill: settingsPanel
         cached: true
         radius: 14
         samples: 20
         color: "#40000000"
         source: settingsPanel
         z: settingsPanel.z-1
         visible: settingsPanel.state != "None"
    }

    Rectangle{
        id: dimScreen
        anchors.fill: parent
        color: Color.background
        z: 100
        opacity: 1
        Behavior on opacity { NumberAnimation { duration: 250} }
    }

    LoginDesktop{
        id: loginPanel
        anchors.centerIn: parent
        radius: 5
        enabled: root.state == "LOGIN"
        visible: root.state==="LOGIN"

        z: 150
    }
    DropShadow {
        id: loginDropShadow
        anchors.fill: loginPanel
        cached: true
        horizontalOffset: 3
        verticalOffset: 3
        radius: 14
        samples: 20
        color: "#40000000"
        source: loginPanel
        visible: root.state==="LOGIN"
        z: loginPanel.z-1
    }

}

