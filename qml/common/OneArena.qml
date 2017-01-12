import QtQuick 2.0

Rectangle {
    height: gameScene.gameWindowAnchorItem.height
    width: gameScene.gameWindowAnchorItem.width/2
    property int score: 100
    property alias inverse: blood.inverse

    Image {
        source: "../img/arena.jpg"
        anchors.fill: parent
    }
//    Text {
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 30
//        color: "white"
//        font.pixelSize: 40
//        text: parent.score
//    }
    SimpleBloodBar {
        id: blood
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        value: parent.score
    }

}
