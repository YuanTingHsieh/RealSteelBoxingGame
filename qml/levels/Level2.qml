import QtQuick 2.0
import VPlay 2.0
import "../common" as Common

Common.LevelBase {
    levelName: "Level2"

    Rectangle {
        id: rectangle
        color: "cyan"
        width: 100
        height: 100
        radius: 10
        property bool togglePosition: false
        anchors.horizontalCenter: parent.horizontalCenter
        // this property binding changes the horizontal offset from the center each time togglePosition changes
        anchors.horizontalCenterOffset: togglePosition ? -100 : 100
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onPressed: {
                // every time the rectangle is pressed, we toggle its position by changing the horizontal offset from the center
                rectangle.togglePosition = !rectangle.togglePosition
                rectanglePressed()
            }
        }
    }
}
