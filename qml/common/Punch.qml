import QtQuick 2.0

Item {

    id: punches_atom

    function handleLeft(punchType) {
        if (punchType===0)
            state = "left_punch"
        else if (punchType===1)
            state = "right_punch"
        atomAttack()
    }

    Image {
        id: left_punch_atom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 110
        source: "../img/atom_fist_burned.png"
        width: 96
        height: 144
        anchors.horizontalCenterOffset:  -45
        mirror: true
        transform: Rotation { origin.x: 48; origin.y: 48; angle: 45}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleLeft(0)
        }

    }

    Image {
        id: right_punch_atom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 110
        source: "../img/atom_fist_burned.png"
        width: 96
        height: 144
        anchors.horizontalCenterOffset:  45
        transform: Rotation { origin.x: 48; origin.y: 48; angle: -45}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: punches_atom.state="defense" //handleLeft(1)
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
                target: left_punch_atom
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenterOffset: 0
            }
        },
        State {
            name: "right_punch"
            PropertyChanges {
                target: right_punch_atom
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenterOffset: 0
            }
        },
        State {
            name: "defense"
            PropertyChanges {
                target: left_punch_atom
                mirror: false
                anchors.verticalCenterOffset: 150
                anchors.horizontalCenterOffset: -20
                rotation: -50
            }
            PropertyChanges {
                target: right_punch_atom
                mirror: true
                anchors.verticalCenterOffset: 150
                anchors.horizontalCenterOffset: 20
                rotation: 50
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
        },
        Transition {
            to: "defense"
            NumberAnimation {
                properties: "anchors.horizontalCenterOffset,anchors.verticalCenterOffset"
                duration: 100
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
