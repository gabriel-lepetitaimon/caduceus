import QtQuick 2.0
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.3
import QtQuick.Timeline 1.0
import Caduceus 1.0
import "../../GQML"
import "../../theme/colors.js" as Color

import "../../../assets/fonts"

Rectangle {
    id: root
    clip: true
    height: 500
    width: 800
    Behavior on width{
        NumberAnimation{ duration: 750; easing.type: Easing.InOutQuad}
    }

    Material.theme: Material.Dark
    Material.accent: Material.LightBlue
    color: Material.backgroundColor

    function validateWeb(){
        if(hostWeb.text=="")
            hostWeb.raise();
        else if(usernameWeb.text=="")
            usernameWeb.raise();
        else if(passwordWeb.text=="")
            passwordWeb.raise();
        else{
            root.state = 'loadingWeb';
            webErrorLabel.text = "";
            AuthService.login(usernameWeb.text, passwordWeb.text, hostWeb.text);
        }
    }

    function validateFile(){
        root.state = 'loadingFile';
        webErrorLabel.text = "";
        resetTimer.start();
    }

    function reset(){
        webErrorLabel.text = "";
        hostWeb.text = "";
        usernameWeb.text = "";
        passwordWeb.text = "";
        usernameFile.text = "";
        passwordFile.text = "";
        root.state = 'base';
        root.readCredentialsFromLocalSettings();
    }

    Connections {
        target: AuthService
        function onLoginFailed(error){
            root.reset()
            if(error==='<b>ERROR 401</b>: Unauthorized')
                webErrorLabel.text = qsTr("Invalid Username or Password");
            else
                webErrorLabel.text = error;
        }
        function onLoginSucceed(){
            LocalSettingsService.setValue('login/defaultWebCredentials', [usernameWeb.text, passwordWeb.text, hostWeb.text]);
            root.reset();
        }
    }
    Connections {
        target: LocalSettingsService
        function onSettingsReady() {root.readCredentialsFromLocalSettings();}
    }

    function readCredentialsFromLocalSettings(){
        if(!LocalSettingsService.isReady())
            return;
        if(LocalSettingsService.contains('login/defaultWebCredentials')){
            const cred = LocalSettingsService.value('login/defaultWebCredentials');
            usernameWeb.text = cred[0];
            passwordWeb.text = cred[1];
            hostWeb.text = cred[2];
        }
    }

    Item{
        id: webPanel
        anchors.left: root.left; anchors.top: root.top; anchors.bottom: root.bottom
        anchors.right: separator.left
        anchors.margins: 5

        opacity: 1
        Behavior on opacity {
            NumberAnimation{ duration: 500; easing.type: Easing.OutQuad}
        }

        Item{
            id: webIcon
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top;
            anchors.bottom: parent.verticalCenter
            Image{
                width: 100
                height: 100
                anchors.centerIn: parent
                source: '../../../assets/icons/globe.png'
            }
        }

        Text {
            id: webErrorLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: webIcon.bottom
            anchors.bottomMargin: 10
            width: 285
            color: Color.red
            text: ""
            elide: Text.ElideRight
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            maximumLineCount: 3
            font.family: "Roboto"
        }

        Column {
            id: webForm
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: webIcon.bottom
            anchors.bottom: parent.bottom
            spacing: 10
            anchors.topMargin: 5

            GTextField {
                id: hostWeb
                y: 301
                width: 285
                font.family: "Roboto"
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Server address")
                enabled: root.state != 'loadingWeb'
                onAccepted: root.validateWeb()
            }

            GTextField {
                id: usernameWeb
                width: 285
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("username")
                enabled: root.state != 'loadingWeb'
                onAccepted: root.validateWeb()
            }

            GTextField {
                id: passwordWeb
                width: 285
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("password")
                echoMode: TextInput.Password
                enabled: root.state != 'loadingWeb'
                onAccepted: root.validateWeb()
            }

            Button {
                id: webButton
                width: 285
                text: root.state != 'loadingWeb' ? qsTr("Web Login") : qsTr('Logging...')
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: root.state != 'loadingWeb'

                onClicked: root.validateWeb()
            }

        }
    }

    Rectangle{
        id: separator
        width: 1
        height: 450
        color: Material.frameColor
        anchors.verticalCenter: parent.verticalCenter

        x: root.width/2
        Behavior on x {
            NumberAnimation{ duration: 750; easing.type: Easing.InOutQuad}
        }

        opacity: 1
        Behavior on opacity {
            NumberAnimation{ duration: 500; easing.type: Easing.OutQuad}
        }
    }

    Item{
        id: filePanel
        anchors.right: parent.right; anchors.top: root.top; anchors.bottom: root.bottom
        anchors.left: separator.right
        anchors.margins: 5
        anchors.rightMargin: 5

        opacity: 1
        Behavior on opacity {
            NumberAnimation{ duration: 500; easing.type: Easing.OutQuad}
        }

        Item{
            id: fileIcon
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top;
            anchors.bottom: parent.verticalCenter
            Image{
                width: 100
                height: 100
                anchors.centerIn: parent
                source: '../../../assets/icons/database.svg'
            }
        }

        Column {
            id: fileForm
            anchors.topMargin: 57
            anchors.top: fileIcon.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 10

            TextField {
                id: usernameFile
                width: 285
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("username")
                onAccepted: root.validateFile()
            }

            TextField {
                id: passwordFile
                width: 285
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("password")
                echoMode: TextInput.Password
                onAccepted: root.validateFile()
            }

            Button {
                id: fileButton
                width: 285
                text: qsTr("Browse File")
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: root.validateFile()
            }
        }
    }

    states: [
        State {
            name: "base"
            PropertyChanges { target: root; width: 800 }
            PropertyChanges { target: separator
                opacity: 1
                x: 400
            }
            PropertyChanges { target: webPanel; opacity: 1 }
            PropertyChanges { target: filePanel; opacity: 1 }
        },

        State {
            name: "loadingWeb"
            PropertyChanges { target: root; width: 400 }
            PropertyChanges { target: separator
                opacity: 0
                x: 400
            }
            PropertyChanges { target: webPanel; opacity: 1 }
            PropertyChanges { target: filePanel; opacity: 0 }
        },
        State {
            name: "loadingFile"
            PropertyChanges { target: root; width: 400 }
            PropertyChanges { target: separator
                opacity: 0
                x: 0
            }
            PropertyChanges { target: webPanel; opacity: 0 }
            PropertyChanges { target: filePanel; opacity: 1 }
        }
    ]
    onFocusChanged: {
        if(root.focus){
            hostWeb.focus = true;
        }
    }
}

