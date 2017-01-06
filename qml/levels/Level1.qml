import QtQuick 2.0
import VPlay 2.0
import "../common" as Common

Common.LevelBase {
    levelName: "Level1"

    Rectangle {
        color: "orange"
        width: 100
        height: 100
        radius: 10
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: rectanglePressed()
        }
    }
}
