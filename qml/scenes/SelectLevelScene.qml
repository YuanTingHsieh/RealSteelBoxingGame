import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: selectLevelScene

    // signal indicating that a level has been selected
    signal levelPressed(string selectedLevel)

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
        onClicked: backButtonPressed()
    }

    // levels to be selected
    Grid {
        anchors.centerIn: parent
        spacing: 10
        columns: 1
        MenuButton {
            text: "Duo Mode"
            width: 100
            height: 50
            onClicked: {
                levelPressed("Duo.qml")
            }
        }
//        Repeater {
//            model: 10
//            MenuButton {
//                text: " "
//                width: 50
//                height: 50
//            }
//        }
    }
}
