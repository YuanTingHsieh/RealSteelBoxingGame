import QtQuick 2.0
import VPlay 2.0
import "../common" as Common
import QtMultimedia 5.5

Common.LevelBase {
    id: duo_mode
    levelName: "Duo Mode"    

    Common.Enemy {
        id: atom
        source: "../img/zeus_burned.png"
        width: 160
        height: 200
        anchors.horizontalCenterOffset:  -135
    }

    SoundEffect {
        id: punchMusic
        source: "../img/punch2.wav"
    }

    Common.Punch {
        id: left_punch_zeus
        anchors.horizontalCenterOffset:  -190
        mirror: true
        transform: Rotation { origin.x: 48; origin.y: 48; angle: 45}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleLeft()
        }

    }

    Common.Punch {
        id: right_punch_zeus
        anchors.horizontalCenterOffset:  -90
        transform: Rotation { origin.x: 48; origin.y: 48; angle: -45}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleLeft_2()
        }
    }

    //    Common.Enemy {
    //        id: zeus
    //        source: "../img/zeus_1500_burned.png"
    //        width: 200
    //        height: 200
    //        anchors.horizontalCenterOffset:  150
    //    }
    Common.Atom {
        id: zeus
        width: 110
        height: 200
        anchors.horizontalCenterOffset:  140
    }

    Common.Punch_zeus {
        id: left_punch_atom
        anchors.horizontalCenterOffset:  70
        transform: Rotation { origin.x: 48; origin.y: 48; angle: -110}

        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleRight()
        }
    }

    Common.Punch_zeus {
        id: right_punch_atom
        anchors.horizontalCenterOffset:  210
        transform: Rotation { origin.x: 48; origin.y: 48; angle: 110}
        mirror: true
        MouseArea {
            anchors.fill: parent
            // since the level is loaded in the gameScene, and is therefore a child of the gameScene, you could also access gameScene.score here and modify it. But we want to keep the logic in the gameScene rather than spreading it all over the place
            onPressed: handleRight_2()
        }
    }

    function handleState_zeus(actionSide) {
        if (actionSide==2)
        {
            atom.state="bend_left"
        }
        else if (actionSide==3)
        {
            atom.state="original"
        }
        else if (actionSide==4)
        {
            atom.state="bend_right"
        }
    }

    function handleState(actionSide) {
        if (zeus.state=="defense")
        {
            if (actionSide==1) // def att left midle right
            {
                zeus.state="original"
            }
            else if (actionSide==2)
            {
                zeus.state="left_def"
            }
            else if (actionSide==4)
            {
                zeus.state="right_def"
            }
        }
        else if (zeus.state=="original")
        {
            if (actionSide==0)
            {
                zeus.state="defense"
            }
            else if (actionSide==2)
            {
                zeus.state="bend_left"
            }
            else if (actionSide==4)
            {
                zeus.state="bend_right"
            }
        }
        else if (zeus.state=="bend_left")
        {
            if (actionSide==0)
            {
                zeus.state="left_def"
            }
            else if (actionSide==3)
            {
                zeus.state="original"
            }
            else if (actionSide==4)
            {
                zeus.state="bend_right"
            }
        }
        else if (zeus.state=="bend_right")
        {
            if (actionSide==0)
            {
                zeus.state="right_def"
            }
            else if (actionSide==2)
            {
                zeus.state="bend_left"
            }
            else if (actionSide==3)
            {
                zeus.state="original"
            }
        }
        else if (zeus.state=="left_def")
        {
            if (actionSide==1)
            {
                zeus.state="bend_left"
            }
            else if (actionSide==3)
            {
                zeus.state="defense"
            }
            else if (actionSide==4)
            {
                zeus.state="right_def"
            }
        }
        else if (zeus.state=="right_def")
        {
            if (actionSide==1)
            {
                zeus.state="bend_right"
            }
            else if (actionSide==2)
            {
                zeus.state="left_def"
            }
            else if (actionSide==3)
            {
                zeus.state="defense"
            }

        }
    }

    function handleLeft() {
        leftPunchPressed()
        punchMusic.play()
        left_punching_left.start()
        right_red_screen.start()
    }

    function handleLeft_2() {
        leftPunchPressed()
        punchMusic.play()
        left_punching_right.start()
        right_red_screen.start()
    }

    function handleRight() {
        rightPunchPressed()
        punchMusic.play()
        right_punching_left.start()
        left_red_screen.start()
    }

    function handleRight_2() {
        rightPunchPressed()
        punchMusic.play()
        right_punching_right.start()
        left_red_screen.start()
    }

    SequentialAnimation {
        id: right_punching_left
        ParallelAnimation {
            NumberAnimation {
                target: left_punch_atom
                property: "anchors.horizontalCenterOffset"
                to: 130
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: left_punch_atom
                property: "anchors.verticalCenterOffset"
                to: 0
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: left_punch_atom
                property: "anchors.horizontalCenterOffset"
                to: 70
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: left_punch_atom
                property: "anchors.verticalCenterOffset"
                to: 135
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

    }

    SequentialAnimation {
        id: right_punching_right
        ParallelAnimation {
            NumberAnimation {
                target: right_punch_atom
                property: "anchors.horizontalCenterOffset"
                to: 130
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: right_punch_atom
                property: "anchors.verticalCenterOffset"
                to: 0
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: right_punch_atom
                property: "anchors.horizontalCenterOffset"
                to: 210
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: right_punch_atom
                property: "anchors.verticalCenterOffset"
                to: 135
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

    }

    SequentialAnimation {
        id: left_punching_left
        ParallelAnimation {
            NumberAnimation {
                target: left_punch_zeus
                property: "anchors.horizontalCenterOffset"
                to: -120
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: left_punch_zeus
                property: "anchors.verticalCenterOffset"
                to: 0
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: left_punch_zeus
                property: "anchors.horizontalCenterOffset"
                to: -190
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: left_punch_zeus
                property: "anchors.verticalCenterOffset"
                to: 110
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

    }

    SequentialAnimation {
        id: left_punching_right
        ParallelAnimation {
            NumberAnimation {
                target: right_punch_zeus
                property: "anchors.horizontalCenterOffset"
                to: -120
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: right_punch_zeus
                property: "anchors.verticalCenterOffset"
                to: 0
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: right_punch_zeus
                property: "anchors.horizontalCenterOffset"
                to: -90
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: right_punch_zeus
                property: "anchors.verticalCenterOffset"
                to: 110
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

    }


}
