import QtQuick 2.0
import QtMultimedia 5.5

Rectangle {
    id: button
    // this will be the default size, it is same size as the contained text + some padding
    width: buttonText.width+checkImg.width+ paddingHorizontal*2
    height: buttonText.height+ paddingVertical*2

    color: "#e9e9e9"
    // round edges
    radius: 10
    opacity: 0.5

    // the horizontal margin from the Text element to the Rectangle at both the left and the right side.
    property int paddingHorizontal: 10
    // the vertical margin from the Text element to the Rectangle at both the top and the bottom side.
    property int paddingVertical: 5

    // access the text of the Text component
    property alias text: buttonText.text

    // this handler is called when the button is clicked.
    signal clicked

    Text {
        id: buttonText
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 18
        color: "black"
    }

    Image {
        id: checkImg
        source: "../img/checked.png"
        anchors.verticalCenter: parent.verticalCenter
        width: buttonText.height
        height: buttonText.height
        fillMode: Image.PreserveAspectFit
        anchors.left: buttonText.right
    }

    Audio {
        id: playMusic
        source: "../img/arcade.wav"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: { button.clicked(); playMusic.play(); button.opacity = 1; }
    }

    function handleConnect() {
        playMusic.play()
        button.opacity = 1
    }
}
