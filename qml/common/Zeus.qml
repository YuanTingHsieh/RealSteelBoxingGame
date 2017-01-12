import QtQuick 2.0

Item {

    id: me
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: 160
    height: 160
    property int square: 160/8

    Image {
        id: body
        width: square*4
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        fillMode: Image.PreserveAspectFit
        source: "../img/zeus/zeus_body_burned.png"
        transformOrigin: Item.Bottom
        rotation: 0
        z: -1
    }

    Image {
        id: left_arm
        width: 50
        height: square*5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -16
        anchors.horizontalCenterOffset: 39
        fillMode: Image.PreserveAspectFit
        source: "../img/zeus/zeus_left_arm_burned.png"
        transformOrigin: Item.TopLeft
        rotation: 0
    }

    Image {
        id: right_arm
        width: 50
        height: square*5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -17
        anchors.horizontalCenterOffset: -45
        fillMode: Image.PreserveAspectFit
        source: "../img/zeus/zeus_right_arm_burned.png"
        transformOrigin: Item.TopRight
        rotation: 0
    }

    Image {
        id: left_fist
        source: "../img/zeus_fist_big_burned.png"
        width: 25
        height: 48
        anchors.horizontalCenterOffset: 38
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 3
        rotation: 0
        visible: false
        mirror: true
    }

    Image {
        id: right_fist
        source: "../img/zeus_fist_big_burned.png"
        width: 25
        height: 48
        anchors.horizontalCenterOffset: 38
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 3
        rotation: 0
        visible: false
    }

    state: "right_def"
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
        },
        State {
            name: "defense"
            PropertyChanges { target: me; rotation:0; }
            PropertyChanges { target: left_arm; anchors.verticalCenterOffset: -16; anchors.horizontalCenterOffset: 53; rotation: 45; }
            PropertyChanges { target: right_arm; anchors.verticalCenterOffset: -20; anchors.horizontalCenterOffset: -56; rotation: -45; }
        },
        State {
            name: "left_def"
            PropertyChanges { target: me; rotation: 30; }
            PropertyChanges { target: left_arm; anchors.verticalCenterOffset: -16; anchors.horizontalCenterOffset: 55; rotation: 55; }
            PropertyChanges { target: right_arm; anchors.verticalCenterOffset: -21; anchors.horizontalCenterOffset: -59; rotation: -55; }
        },
        State {
            name: "right_def"
            PropertyChanges { target: me; rotation: -30; }
            PropertyChanges { target: left_arm; anchors.verticalCenterOffset: -19; anchors.horizontalCenterOffset: 54; rotation: 55; }
            PropertyChanges { target: right_arm; anchors.verticalCenterOffset: -22; anchors.horizontalCenterOffset: -57; rotation: -55; }
        },
        State {
            name: "left_punch"
            PropertyChanges {target: left_fist; width: 100; height: 100; anchors.horizontalCenterOffset: 31;  anchors.leftMargin: 58; anchors.topMargin: 11; visible: true;}
            PropertyChanges {
                target: left_arm
                rotation: 30
                opacity: 0
            }
        },
        State {
            name: "right_punch"
            PropertyChanges {target: right_fist; width: 100; height: 100; anchors.horizontalCenterOffset: -9;  anchors.leftMargin: 58; anchors.topMargin: 30; visible: true;}
            PropertyChanges {
                target: right_arm
                rotation: -30
                opacity: 0
            }
        }

    ]
    transitions: [
        Transition {
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
        },
        Transition {
            to: "left_punch"
            NumberAnimation {
                 properties: "anchors.horizontalCenterOffset,anchors.leftMargin,anchors.topMargin"
                 duration: 200
                 easing.type: Easing.OutExpo
             }
            NumberAnimation {
                properties: "width, height"
                duration: 200
                easing.type: Easing.OutExpo
            }
            RotationAnimation {
                properties: "rotation"
                duration: 200
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if (!running)
                    state="original";
            }
        },
        Transition {
            to: "right_punch"
            NumberAnimation {
                 properties: "anchors.horizontalCenterOffset,anchors.leftMargin,anchors.topMargin"
                 duration: 200
                 easing.type: Easing.OutExpo
             }
            NumberAnimation {
                properties: "width, height"
                duration: 200
                easing.type: Easing.OutExpo
            }
            RotationAnimation {
                properties: "rotation"
                duration: 200
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if (!running)
                    state="original";
            }
        }

    ]

}
