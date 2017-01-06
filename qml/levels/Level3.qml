import QtQuick 2.0
import VPlay 2.0
import "../common" as Common

Common.LevelBase {
    levelName: "Level3"

    Rectangle {
        id: rectangle
        color: "blue"
        width: 100
        height: 100
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 120
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onPressed: rectanglePressed()
        }
    }

    // SequentialAnimation plays all its child animations one after the other
    // we are moving the rectangle by changing its horizontal offset from the center
    SequentialAnimation {
        running: true
        // let it run forever
        loops: Animation.Infinite
        // move the rectangle left by changing the offset from current (120) to -120
        NumberAnimation {
            target: rectangle
            duration: 1500
            property: "anchors.horizontalCenterOffset"
            easing.type: Easing.InOutQuad
            to: -120
        }
        // after moving left has finished, we move the rectangle right by changing the offset from current (-120) to 120
        NumberAnimation {
            target: rectangle
            duration: 1500
            property: "anchors.horizontalCenterOffset"
            easing.type: Easing.InOutQuad
            to: 120
        }
    }
}
