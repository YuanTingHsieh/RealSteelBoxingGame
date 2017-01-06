import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:creditsScene

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#49a349"
        Image {
            source: '../img/noisy_boy.jpg'
            anchors.fill: parent
        }
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: creditsScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: creditsScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: backButtonPressed()
    }

    // credits
    Column {
        anchors.centerIn: parent
        Text {
            text: "Credits to: Yuan-Ting Hsieh, Chien-Sheng Wu"
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "Embedding System Lab Final Project, Sep. 2016"
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
