import QtQuick 2.0

Item {

    id: punches_zeus

    function handleRight(punchType) {
        if (punchType===0)
            state = "left_punch"
        else if (punchType===1)
            state = "right_punch"
        zeusAttack()
    }


    Image {
        id: left_punch_zeus
        anchors.horizontalCenterOffset:  -80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 140
        source: "../img/zeus_fist_big_burned.png"
        width: 100
        height: 144
        fillMode: Image.PreserveAspectFit
        transform: Rotation { origin.x: 48; origin.y: 48; angle: -110}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleRight(0)//{punches_zeus.state="left_def"} //handleRight(0)
        }
    }

    Image {
        id: right_punch_zeus
        anchors.horizontalCenterOffset:  80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 140
        source: "../img/zeus_fist_big_burned.png"
        width: 100
        height: 144
        fillMode: Image.PreserveAspectFit
        transform: Rotation { origin.x: 48; origin.y: 48; angle: 110}
        mirror: true
        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleRight(1)//{punches_zeus.state="right_def"}
        }

    }

    state: "original"

    states: [
        State {
            name: "original"
        },
        State {
            name: "left_punch"

            PropertyChanges {
                target: left_punch_zeus
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenterOffset: 0
            }
        },
        State {
            name: "right_punch"
            PropertyChanges {
                target: right_punch_zeus
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenterOffset: 0
            }
        },
        State {
            name: "defense"
            PropertyChanges {
                target: right_punch_zeus
                anchors.verticalCenterOffset: 163
                anchors.horizontalCenterOffset: 81
            }

            PropertyChanges {
                target: left_punch_zeus
                anchors.verticalCenterOffset: 161
                anchors.horizontalCenterOffset: -58
            }
        },
        State {
            name: "right_def"
            PropertyChanges {
                target: punches_zeus
                rotation: -20
            }

            PropertyChanges {
                target: right_punch_zeus
                anchors.verticalCenterOffset: 163
                anchors.horizontalCenterOffset: 81
            }

            PropertyChanges {
                target: left_punch_zeus
                anchors.verticalCenterOffset: 161
                anchors.horizontalCenterOffset: -58
            }
        },
        State {
            name: "left_def"
            PropertyChanges {
                target: punches_zeus
                rotation: 20
            }

            PropertyChanges {
                target: right_punch_zeus
                y: 309
                anchors.verticalCenterOffset: 161
                anchors.horizontalCenterOffset: 80
            }

            PropertyChanges {
                target: left_punch_zeus
                anchors.verticalCenterOffset: 165
                anchors.horizontalCenterOffset: -58
            }
        }

    ]

    transitions: [
        Transition {
            to: "right_punch"
            NumberAnimation {
                properties: "anchors.horizontalCenterOffset,anchors.verticalCenterOffset"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            RotationAnimation {
                properties: "rotation"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if (!running)
                    state="original";
            }
        },
        Transition {
            to: "left_punch"
            NumberAnimation {
                properties: "anchors.horizontalCenterOffset,anchors.verticalCenterOffset"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            RotationAnimation {
                properties: "rotation"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if (!running)
                    state="original";
            }
        },
        Transition {
            to: "original"
            NumberAnimation {
                properties: "anchors.horizontalCenterOffset,anchors.verticalCenterOffset"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            RotationAnimation {
                properties: "rotation"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    ]

}
