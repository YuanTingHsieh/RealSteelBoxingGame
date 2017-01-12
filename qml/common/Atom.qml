import QtQuick 2.0

Item {

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    property int square: 10

    state: "original"

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "original"
            PropertyChanges {target: head; anchors.horizontalCenterOffset: 0; anchors.topMargin: 0; rotation: 0}
            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: -35;  anchors.leftMargin: 7; anchors.topMargin: 60; rotation: 0;}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: -29;  anchors.leftMargin: 12; anchors.topMargin: 23; rotation: 0;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: 38;  anchors.leftMargin: 79; anchors.topMargin: 60; rotation: 0;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: 30;  anchors.leftMargin: 70; anchors.topMargin: 24; rotation: 0;}
            PropertyChanges {target: right_leg; anchors.horizontalCenterOffset: -19;  anchors.leftMargin: 16; anchors.topMargin: 71; rotation: 0;}
            PropertyChanges {target: left_leg; x: 81; y: 69; anchors.horizontalCenterOffset: 18;  anchors.leftMargin: 53; anchors.topMargin: 69; rotation: 0;}
            PropertyChanges {target: body; rotation: 0;}
        },
        State {
            name: "defense"
            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: -14; anchors.leftMargin: 27; anchors.topMargin: 33; rotation: 0; source: "../img/atom_fist_burned.png";}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: -32;  anchors.leftMargin: 9; anchors.topMargin: 23; rotation: -20;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: 15;  anchors.leftMargin: 58; anchors.topMargin: 33; rotation: 0; source: "../img/atom_fist_burned.png"; mirror: true;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: 33;  anchors.leftMargin: 73; anchors.topMargin: 24; rotation: 20;}

        },
        State {
            name: "left_def"

            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: 16; anchors.leftMargin: 27; anchors.topMargin: 37; rotation: 30; source: "../img/atom_fist_burned.png";}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: 3;  anchors.leftMargin: 9; anchors.topMargin: 23; rotation: 10;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: 47;  anchors.leftMargin: 58; anchors.topMargin: 41; rotation: 30; source: "../img/atom_fist_burned.png"; mirror: true;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: 65;  anchors.leftMargin: 73; anchors.topMargin: 42; rotation: 50;}
            PropertyChanges {target: head; anchors.horizontalCenterOffset: 33; anchors.topMargin: 8; rotation: 30;}
            PropertyChanges {target: right_leg; anchors.horizontalCenterOffset: -10;  anchors.leftMargin: 25; anchors.topMargin: 75; rotation: 30;}
            PropertyChanges {target: left_leg; anchors.horizontalCenterOffset: 18;  anchors.leftMargin: 53; anchors.topMargin: 69; rotation: 0;}
            PropertyChanges {target: body; rotation: 30;}
        },
        State {

            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: -44; anchors.leftMargin: 27; anchors.topMargin: 39; rotation: -30; source: "../img/atom_fist_burned.png";}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: -63;  anchors.leftMargin: 9; anchors.topMargin: 40; rotation: -50;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: -13;  anchors.leftMargin: 58; anchors.topMargin: 37; rotation: -30; source: "../img/atom_fist_burned.png"; mirror: true;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: -2;  anchors.leftMargin: 73; anchors.topMargin: 21; rotation: -10;}
            PropertyChanges {target: head; anchors.horizontalCenterOffset: -32; anchors.topMargin: 7; rotation: -30;}
            PropertyChanges {target: right_leg; anchors.horizontalCenterOffset: -20;  anchors.leftMargin: 16; anchors.topMargin: 71; rotation: 0;}
            PropertyChanges {target: left_leg; anchors.horizontalCenterOffset: 7;  anchors.leftMargin: 44; anchors.topMargin: 71; rotation: -30;}
            PropertyChanges {target: body; rotation: -30;}
        },

        State {
            name: "bend_left"
            PropertyChanges {target: head; anchors.horizontalCenterOffset: 33; anchors.topMargin: 8; rotation: 30;}
            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: -17;  anchors.leftMargin: 24; anchors.topMargin: 53; rotation: 30;}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: 6; anchors.topMargin: 25;  anchors.leftMargin: 47; rotation: 30;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: 60;  anchors.leftMargin: 101; anchors.topMargin: 41; rotation: 30;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: 48;  anchors.leftMargin: 90; anchors.topMargin: 77; rotation: 30;}
            PropertyChanges {target: right_leg; anchors.horizontalCenterOffset: -10;  anchors.leftMargin: 25; anchors.topMargin: 75; rotation: 30;}
            PropertyChanges {target: left_leg; anchors.horizontalCenterOffset: 18;  anchors.leftMargin: 53; anchors.topMargin: 69; rotation: 0;}
            PropertyChanges {target: body; rotation: 30;}
        },
        State {
            name: "bend_right"
            PropertyChanges {target: head; anchors.horizontalCenterOffset: -32; anchors.topMargin: 7; rotation: -30;}
            PropertyChanges {target: right_low; anchors.horizontalCenterOffset: -46;  anchors.leftMargin: -3; anchors.topMargin: 75; rotation: -30;}
            PropertyChanges {target: right_up; anchors.horizontalCenterOffset: -59; anchors.topMargin: 40;  anchors.leftMargin: -18; rotation: -30;}
            PropertyChanges {target: left_up; anchors.horizontalCenterOffset: -5;  anchors.leftMargin: 36; anchors.topMargin: 24; rotation: -30;}
            PropertyChanges {target: left_low; anchors.horizontalCenterOffset: 20;  anchors.leftMargin: 62; anchors.topMargin: 51; rotation: -30;}
            PropertyChanges {target: right_leg; anchors.horizontalCenterOffset: -20;  anchors.leftMargin: 16; anchors.topMargin: 71; rotation: 0;}
            PropertyChanges {target: left_leg; anchors.horizontalCenterOffset: 7;  anchors.leftMargin: 44; anchors.topMargin: 71; rotation: -30;}
            PropertyChanges {target: body; rotation: -30;}
        },
        State {
            name: "left_punch"
            PropertyChanges {target: left_fist; width: 100; height: 100; anchors.horizontalCenterOffset: 31;  anchors.leftMargin: 58; anchors.topMargin: 11; visible: true;}
            PropertyChanges {
                target: left_low
                visible: false
            }PropertyChanges {
                target: left_up
                visible: false
            }
        },
        State {
            name: "right_punch"
            PropertyChanges {target: right_fist; width: 100; height: 100; anchors.horizontalCenterOffset: -44;  anchors.leftMargin: 58; anchors.topMargin: 11; visible: true; mirror: true;}
            PropertyChanges {
                target: right_low
                visible: false
            }PropertyChanges {
                target: right_up
                visible: false
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

    Image {
        id: head
        source: "../img/atom/atom_head_burned.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: square*2
        height: square*2.5
        fillMode: Image.PreserveAspectFit
        transformOrigin: Item.Bottom

    }

    Image {
        id: right_up
        x: 40
        y: 23
        width: 27
        height: 48
        anchors.horizontalCenterOffset: -29
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_up_arm_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 23
        rotation: 0
        transformOrigin: Item.TopRight

    }
    Image {
        id: left_up
        width: 27
        height: 48
        anchors.horizontalCenterOffset: 30
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_up_arm_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 24
        rotation: 0
        transformOrigin: Item.TopLeft

    }

    Image {
        id: left_leg
        width: 40
        height: 110
        anchors.horizontalCenterOffset: 18
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_leg_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 69
        transformOrigin: Item.TopLeft
    }

    Image {
        id: right_leg
        width: 40
        height: 110
        anchors.horizontalCenterOffset: -19
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_leg_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 71
        rotation: 0
        transformOrigin: Item.TopRight
    }

    Image {
        id: body
        source: "../img/atom/atom_body_burned.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: square*6
        height: square*7
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenterOffset: -1
        anchors.topMargin: 19
        z: 1
        rotation: 0
        transformOrigin: Item.Bottom

    }

    Image {
        id: right_low
        x: 35
        y: 60
        width: 25
        height: 48
        anchors.horizontalCenterOffset: -35
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_low_arm_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 2
        rotation: 0
        transformOrigin: Item.TopRight

    }
    Image {
        id: left_low
        x: 108
        y: 61
        width: 25
        height: 48
        anchors.horizontalCenterOffset: 38
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_low_arm_burned.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 2
        rotation: 0
        transformOrigin: Item.TopLeft

    }

    Image {
        id: left_fist
        source: "../img/atom/little_atom_fist_burned.png"
        width: 25
        height: 48
        anchors.horizontalCenterOffset: 38
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 3
        rotation: -50
        visible: false
    }

    Image {
        id: right_fist
        source: "../img/atom/little_atom_fist_burned.png"
        width: 25
        height: 48
        anchors.horizontalCenterOffset: -35
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 60
        z: 3
        rotation: 50
        visible: false
    }


}
