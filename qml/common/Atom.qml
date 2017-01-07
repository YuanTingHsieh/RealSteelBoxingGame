import QtQuick 2.0

Item {

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    property int square: 10

    signal clockRotate

    onClockRotate: animate_clock_rotate.start()

    SequentialAnimation{
        id: animate_clock_rotate
        RotationAnimation {
            targets: [body, right_low, left_low, right_up, left_up, right_leg]
            //targets: [body, right_leg]
            to: 30
            duration: 200
        }
        RotationAnimation {
            targets: [body, right_low, left_low, right_up, left_up, right_leg]
            //targets: [body, right_leg]
            to: 0
            duration: 200
        }
    }


    Image {
        id: head
        source: "../img/atom/atom_head_burned.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: square*2
        height: square*2.5
        fillMode: Image.PreserveAspectFit

    }

    Image {
        id: right_low
        width: 25
        height: 48
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_low_arm_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 7
        anchors.left: parent.left
        anchors.topMargin: 61
        rotation: 0
        transformOrigin: Item.TopRight

    }
    Image {
        id: left_low
        width: 22
        height: 48
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_low_arm_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 80
        anchors.left: parent.left
        anchors.topMargin: 60
        rotation: 0
        transformOrigin: Item.TopLeft

    }
    Image {
        id: right_up
        width: 27
        height: 48
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_up_arm_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 12
        anchors.left: parent.left
        anchors.topMargin: 24
        rotation: 0
        transformOrigin: Item.TopRight

    }
    Image {
        id: left_up
        width: 27
        height: 48
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_up_arm_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 70
        anchors.left: parent.left
        anchors.topMargin: 24
        rotation: 0
        transformOrigin: Item.TopLeft

    }

    Image {
        id: left_leg
        width: 40
        height: 110
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_left_leg_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 53
        anchors.left: parent.left
        anchors.topMargin: 69
    }

    Image {
        id: right_leg
        width: 40
        height: 110
        fillMode: Image.PreserveAspectFit
        source: "../img/atom/atom_right_leg_burned.png"
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.left: parent.left
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


}
