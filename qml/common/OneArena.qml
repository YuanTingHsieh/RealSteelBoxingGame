import QtQuick 2.0

Rectangle {
    height: gameScene.gameWindowAnchorItem.height
    width: gameScene.gameWindowAnchorItem.width/2
    property int score: 0
    // anchors.right: gameScene.gameWindowAnchorItem.right
    Image {
        source: "../img/arena.jpg"
        anchors.fill: parent
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        color: "white"
        font.pixelSize: 40
        text: parent.score
    }

//    Rectangle {
//         width: parent.width<parent.height?parent.width:parent.height
//         height: width
//         color: "red"
//         //border.color: "black"
//         //border.width: 1
//         radius: width*0.5
//         Text {
//              anchors.fill: parent
//              color: "red"
//              text: "Boom"
//         }
//    }

}
