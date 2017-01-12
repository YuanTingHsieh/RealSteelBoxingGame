import VPlay 2.0
import QtQuick 2.0
import "../common"
import QtMultimedia 5.5

SceneBase {
    id:winningScene

    property bool startPlay: false
    property int winner: -1

    onWinnerChanged: {
        if (winner ==0)
            atom_win.play()
        else
            zeus_win.play()
    }

    // background
    Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        Image {
            source: '../img/noisy_boy.jpg'
            anchors.fill: parent
        }
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: winningScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: winningScene.gameWindowAnchorItem.top
        anchors.topMargin: 15
        onClicked: backButtonPressed()
    }

    Audio {
        id: victory_sound
        source: "../img/Victory.mp3"
    }

    Text {
        id: atom_text
        anchors.centerIn: parent

        font.pixelSize: 50
        color: "#e9e9e9"
        text: "Atom Win!!!"
        font.family: "Copperplate Gothic Bold"
        visible: false
        z: 2
    }

    Text {
        id: zeus_text
        anchors.centerIn: parent

        font.pixelSize: 50
        color: "#e9e9e9"
        text: "Zeus Win!!!"
        font.family: "Copperplate Gothic Bold"
        visible: false
        z: 2
    }

    Video {
        width: 500
        height: 500
        anchors.fill: parent
        id: zeus_win
        //autoLoad: true
        source: "../img/zeus_win.wmv"
        onStopped: { zeus_text.visible = true; victory_sound.play() }
        volume: 1
    }

    Video {
        width: 500
        height: 500
        anchors.fill: parent
        id: atom_win
        //autoLoad: true
        source: "../img/atom_win.wmv"
        onStopped: { atom_text.visible = true; victory_sound.play() }
        volume: 1
    }
}
