import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: selectLevelScene

    // signal indicating that a level has been selected
    signal levelPressed(string selectedLevel)
    signal userConnected(int userType)
    property bool user1Ready: false
    property bool user2Ready: false

    property alias user1Opacity : user1.opacity
    property alias user2Opacity : user2.opacity

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    // wait for connections!!
    onUserConnected: {
        if (userType===0)
        {
            user1.handleConnect()
            user1Ready = true
        }
        else if (userType===1)
        {
            user2.handleConnect()
            user2Ready = true
        }
        if (user1Ready && user2Ready)
            delay(10, function() { levelPressed("Duo.qml"); })
    }

    // the "logo"
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        y: 30
        font.pixelSize: 40
        color: "#e9e9e9"
        text: (user1Ready && user2Ready) ? "Wait for connections..." : "Let's Fight"
        font.family: "Copperplate Gothic Bold"
    }

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        //color: "#ece468"
        Image {
            source: '../img/mode_select.jpg'
            anchors.fill: parent
        }
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: selectLevelScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: selectLevelScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: {
            backButtonPressed()
        }
    }

    // levels to be selected
    Grid {
        anchors.centerIn: parent
        spacing: 10
        columns: 1
        UserStatus {
            id: user1
            text: "User 1 Connected!"
            visible: (user1Ready && user2Ready) ?  false : true
            // for Debug
            onClicked: userConnected(0)
        }
        UserStatus {
            id: user2
            text: "User 2 Connected!"
            visible: (user1Ready && user2Ready) ? false : true
            // for Debug
            onClicked: userConnected(1)
        }
        MenuButton {
            id: begin_button
            text: "Let's Fight"
            width: 200
            height: 100
            onClicked: {
                levelPressed("Duo.qml")
            }
            visible: (user1Ready && user2Ready) ? true : false
            enabled: visible
        }
    }
}
