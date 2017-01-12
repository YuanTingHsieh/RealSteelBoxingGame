import QtQuick 2.0

Item {
    id: progressbar

    property int minimum: 0
    property int maximum: 100
    property int value: 0
    //property color color: "#77B753"
    property color color: determineColor()
    property bool inverse: false

    function determineColor() {
        if (value > 50) {
            return "blue"
        }
        else if (value > 20) {
            return "orange"
        }
        else {
            return "red"
        }
    }

    width: 180; height: 18
    clip: true

    Rectangle {
        id: border
        anchors.fill: parent
        anchors.bottomMargin: 1
        anchors.rightMargin: 1
        color: "transparent"
        border.width: 1
        border.color: parent.color
    }

    Text {
        anchors.centerIn: parent
        color: "black"
        font.pixelSize: 20
        text: value
        z: 2
    }

    Rectangle {
        id: highlight
        property int widthDest: ( ( progressbar.width * ( value- minimum ) ) / ( maximum - minimum ) - 4 )
        //opacity: (value-minimum) / (maximum-minimum)
        width: highlight.widthDest

        Behavior on width {
            SmoothedAnimation {
                velocity: 1200
            }
        }

        Behavior on color {
            ColorAnimation {}
        }

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: 2
        }
        color: parent.color
        visible: parent.inverse == true ? false : true
        enabled: visible
    }

    Rectangle {
        id: highlight_inv
        property int widthDest: ( ( progressbar.width * ( value- minimum ) ) / ( maximum - minimum ) - 4 )
        //opacity: (value-minimum) / (maximum-minimum)
        width: highlight_inv.widthDest

        Behavior on width {
            SmoothedAnimation {
                velocity: 1200
            }
        }

        Behavior on color {
            ColorAnimation {}
        }

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: 2
        }
        color: parent.color
        visible: parent.inverse == true ? true : false
        enabled: visible
    }
}
