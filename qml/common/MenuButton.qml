import QtQuick 2.0
import QtMultimedia 5.5

Rectangle {
    id: button
    // this will be the default size, it is same size as the contained text + some padding
    width: buttonText.width+ paddingHorizontal*2
    height: buttonText.height+ paddingVertical*2

    color: "#e9e9e9"
    // round edges
    radius: 10

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
        anchors.centerIn: parent
        font.pixelSize: 18
        color: "black"
    }

    Audio {
        id: playMusic
        source: "../img/button-3.wav"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: { button.clicked(); playMusic.play(); }
        onPressed: button.opacity = 0.5
        onReleased: button.opacity = 1
    }
}
