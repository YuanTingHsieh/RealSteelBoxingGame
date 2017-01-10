import QtQuick 2.0

Image {
    id: me
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    fillMode: Image.PreserveAspectFit
    source: "../img/zeus_burned.png"
    transformOrigin: Item.Bottom
    rotation: 0

    state: "original"
    states: [
        State {
            name: "original"
            PropertyChanges { target: me; rotation:0; }
        },
        State {
            name: "bend_left"
            PropertyChanges {
                target: me
                rotation: 30
            }

        },
        State {
            name: "bend_right"
            PropertyChanges {
                target: me
                rotation: -30
            }

        }
    ]
    transitions: [
        Transition {
           //from: "original"; to "bend_left"
           NumberAnimation {
                properties: "anchors.horizontalCenterOffset,anchors.leftMargin,anchors.topMargin"
                duration: 200
                easing.type: Easing.InOutQuad
            }
           RotationAnimation {
               properties: "rotation"
               duration: 200
               easing.type: Easing.InOutQuad
           }
        }

    ]
}
