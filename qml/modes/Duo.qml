import QtQuick 2.0
//import VPlay 2.0
import "../common" as Common
import QtMultimedia 5.5

Item {
    id: duo_mode
    // this will be displayed in the GameScene
    property string levelName: "Duo Mode"

    anchors.left: parent.left
    anchors.top: parent.top

    signal leftPunchPressed
    signal rightPunchPressed
    signal atomAttack
    signal zeusAttack

    SoundEffect {
        id: punchMusic
        source: "../img/punch2.wav"
    }

    SoundEffect {
        id: defenseMusic
        source: "../img/defense.wav"
    }

    Common.Zeus {
        id: zeus
        anchors.horizontalCenterOffset: -parent.width/4
        MouseArea {
            anchors.fill: parent
            onPressed: { handleZeusPunch(1); }
        }
        Rectangle {
            id: zeus_defense_block
            width: 70
            height: 70
            radius: 10
            opacity: 0
            color: "red"
            anchors.verticalCenterOffset: -49
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
            Text {
                anchors.centerIn: parent
                text: "Defense"
                color: "white"
            }
            z: 4
        }
    }

    Common.Punch{
        id: punches_atom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -parent.width/4
    }

    Common.Atom {
        id: atom
        width: 110
        height: 200
        anchors.horizontalCenterOffset: parent.width/4
        // below for debug use
        MouseArea {
            anchors.fill: parent
            onPressed: { handleAtomPunch(1); }
        }
        Rectangle {
            id: atom_defense_block
            width: 70
            height: 70
            radius: 10
            opacity: 0
            color: "red"
            anchors.verticalCenterOffset: -49
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
            Text {
                anchors.centerIn: parent
                text: "Defense"
                color: "white"
            }
            z: 4
        }
    }

    Common.Punch_zeus {
        id: punches_zeus
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: parent.width/4
    }


    function handleState_zeus(actionSide) {
        if (zeus.state=="defense")
        {
            if (actionSide==1) // def att left midle right
            {
                zeus.state="original"
                punches_zeus.state="original"
            }
            else if (actionSide==2)
            {
                zeus.state="left_def"
                punches_zeus.state="left_def"
            }
            else if (actionSide==4)
            {
                zeus.state="right_def"
                punches_zeus.state="right_def"
            }
        }
        else if (zeus.state=="original")
        {
            if (actionSide==0)
            {
                zeus.state="defense"
                punches_zeus.state="defense"
            }
            else if (actionSide==2)
            {
                zeus.state="bend_left"
                punches_zeus.state="bend_left"
            }
            else if (actionSide==4)
            {
                zeus.state="bend_right"
                punches_zeus.state="bend_right"
            }
        }
        else if (zeus.state=="bend_left")
        {
            if (actionSide==0)
            {
                zeus.state="left_def"
                punches_zeus.state="left_def"
            }
            else if (actionSide==3)
            {
                zeus.state="original"
                punches_zeus.state="original"
            }
            else if (actionSide==4)
            {
                zeus.state="bend_right"
                punches_zeus.state="bend_right"
            }
        }
        else if (zeus.state=="bend_right")
        {
            if (actionSide==0)
            {
                zeus.state="right_def"
                punches_zeus.state="right_def"
            }
            else if (actionSide==2)
            {
                zeus.state="bend_left"
                punches_zeus.state="bend_left"
            }
            else if (actionSide==3)
            {
                zeus.state="original"
                punches_zeus.state="original"
            }
        }
        else if (zeus.state=="left_def")
        {
            if (actionSide==1)
            {
                zeus.state="bend_left"
                punches_zeus.state="bend_left"
            }
            else if (actionSide==3)
            {
                zeus.state="defense"
                punches_zeus.state="defense"
            }
            else if (actionSide==4)
            {
                zeus.state="right_def"
                punches_zeus.state="right_def"
            }
        }
        else if (zeus.state=="right_def")
        {
            if (actionSide==1)
            {
                zeus.state="bend_right"
                punches_zeus.state="bend_right"
            }
            else if (actionSide==2)
            {
                zeus.state="left_def"
                punches_zeus.state="left_def"
            }
            else if (actionSide==3)
            {
                zeus.state="defense"
                punches_zeus.state="defense"
            }

        }
    }

    function handleState(actionSide) {
        if (atom.state=="defense")
        {
            if (actionSide==1) // def att left midle right
            {
                atom.state="original"
                punches_atom.state="original"
            }
            else if (actionSide==2)
            {
                atom.state="left_def"
                punches_atom.state="left_def"
            }
            else if (actionSide==4)
            {
                atom.state="right_def"
                punches_atom.state="right_def"
            }
        }
        else if (atom.state=="original")
        {
            if (actionSide==0)
            {
                atom.state="defense"
                punches_atom.state="defense"
            }
            else if (actionSide==2)
            {
                atom.state="bend_left"
                punches_atom.state="bend_left"
            }
            else if (actionSide==4)
            {
                atom.state="bend_right"
                punches_atom.state="bend_right"
            }
        }
        else if (atom.state=="bend_left")
        {
            if (actionSide==0)
            {
                atom.state="left_def"
                punches_atom.state="left_def"
            }
            else if (actionSide==3)
            {
                atom.state="original"
                punches_atom.state="original"
            }
            else if (actionSide==4)
            {
                atom.state="bend_right"
                punches_atom.state="bend_right"
            }
        }
        else if (atom.state=="bend_right")
        {
            if (actionSide==0)
            {
                atom.state="right_def"
                punches_atom.state="right_def"
            }
            else if (actionSide==2)
            {
                atom.state="bend_left"
                punches_atom.state="bend_left"
            }
            else if (actionSide==3)
            {
                atom.state="original"
                punches_atom.state="original"
            }
        }
        else if (atom.state=="left_def")
        {
            if (actionSide==1)
            {
                atom.state="bend_left"
                punches_atom.state="bend_left"
            }
            else if (actionSide==3)
            {
                atom.state="defense"
                punches_atom.state="defense"
            }
            else if (actionSide==4)
            {
                atom.state="right_def"
                punches_atom.state="right_def"
            }
        }
        else if (atom.state=="right_def")
        {
            if (actionSide==1)
            {
                atom.state="bend_right"
                punches_atom.state="bend_right"
            }
            else if (actionSide==2)
            {
                atom.state="left_def"
                punches_atom.state="left_def"
            }
            else if (actionSide==3)
            {
                atom.state="defense"
                punches_atom.state="defense"
            }

        }
    }

    function handleAtomPunch(punchType) {
        punches_atom.handleLeft(punchType)

        if (atom.state=="original")
        {
            if (punchType===0)
            {
                atom.state = "left_punch"
            }
            else if (punchType===1)
            {
                atom.state = "right_punch"
            }
        }
    }

    function handleZeusPunch(punchType) {
        punches_zeus.handleRight(punchType)

        if (zeus.state=="original")
        {
            if (punchType===0)
            {
                zeus.state = "left_punch"
            }
            else if (punchType===1)
            {
                zeus.state = "right_punch"
            }
        }
    }

    SequentialAnimation {
        id: atom_defense_block_show
        NumberAnimation { target: atom_defense_block; properties: "opacity"; to: 0.6; }
        NumberAnimation { target: atom_defense_block; properties: "opacity"; to: 0; }
    }

    SequentialAnimation {
        id: zeus_defense_block_show
        NumberAnimation { target: zeus_defense_block; properties: "opacity"; to: 0.6; }
        NumberAnimation { target: zeus_defense_block; properties: "opacity"; to: 0; }
    }

    // after atom attack, check the status of zeus!!!
    onAtomAttack: {
        if (zeus.state=="defense" || zeus.state=="right_def" || zeus.state=="left_def")
        {
            defenseMusic.play()
            zeus_defense_block_show.start()
        }
        else
        {
            leftPunchPressed()
            punchMusic.play()
            right_red_screen.start()
        }

    }

    onZeusAttack: {
        if (atom.state=="defense" || atom.state=="right_def" || atom.state=="left_def")
        {
            defenseMusic.play()
            atom_defense_block_show.start()
        }
        else
        {
            rightPunchPressed()
            punchMusic.play()
            left_red_screen.start()
        }
    }

}
