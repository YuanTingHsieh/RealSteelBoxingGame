import VPlay 2.0
import QtQuick 2.0
import "../common"
import QtGraphicalEffects 1.0
import QtMultimedia 5.5

SceneBase {
    id:gameScene
    // the filename of the current level gets stored here, it is used for loading the
    property string activeLevelFileName
    // the currently loaded level gets stored here
    property variant activeLevel
    // score
    property int leftScore: 0
    property int rightScore: 0
    // countdown shown at level start
    property int countdown: 0
    // flag indicating if game is running
    property bool gameRunning: countdown == -1

    // set the name of the current level, this will cause the Loader to load the corresponding level
    function setLevel(fileName) {
        activeLevelFileName = fileName
    }

    OneArena {
        id: leftfield
        objectName: "Arena"
        score: leftScore
        anchors.left: gameScene.gameWindowAnchorItem.left
        Rectangle {
            id: left_mask
            anchors.fill: parent
            opacity: 0
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.5; color: "red" }
                }
            }
        }
    }

    OneArena {
        id: rightfield
        score: rightScore
        anchors.right: gameScene.gameWindowAnchorItem.right
        Rectangle {
            id: right_mask
            anchors.fill: parent
            opacity: 0
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.5; color: "red" }
                }
            }
        }
    }

    // back button to leave scene
    MenuButton {
        text: "Back to menu"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameScene.gameWindowAnchorItem.right
        anchors.rightMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        onClicked: {
            backButtonPressed()
            activeLevel = undefined
            activeLevelFileName = ""
            countdown = -1
        }
    }

    // name of the current level
    Text {
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: 20
        text: activeLevel !== undefined ? activeLevel.levelName : ""
    }

    // load levels at runtime
    Loader {
        objectName: "Load_BABY"
        id: loader
        source: activeLevelFileName != "" ? "../modes/" + activeLevelFileName : ""
        onLoaded: {
            // reset the score
            leftScore = 0
            rightScore = 0
            // since we did not define a width and height in the level item itself, we are doing it here
            item.width = gameScene.gameWindowAnchorItem.width
            item.height = gameScene.gameWindowAnchorItem.height
            // store the loaded level as activeLevel for easier access
            activeLevel = item
            // restarts the countdown
            countdown = 4
        }
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.top: gameScene.gameWindowAnchorItem.top
        signal punchHit (int punchType)
        signal actionTake (int actionType)
        signal punchHit_zeus (int punchType)
        signal actionTake_zeus (int actionType)
        signal userDisconnected(int userType)

        onPunchHit: {
            if (gameRunning) {
                item.handleAtomPunch(punchType)
            }
        }
        onPunchHit_zeus: {
            if (gameRunning) {
                item.handleZeusPunch(punchType)
            }
        }
        onActionTake: {
            if (gameRunning) {
                item.handleState(actionType)
            }
        }
        onActionTake_zeus: {
            if (gameRunning) {
                item.handleState_zeus(actionType)
            }
        }
        onUserDisconnected: {
            backButtonPressed()
            activeLevel = undefined
            activeLevelFileName = ""
            countdown = -1
        }
    }

    // we connect the gameScene to the loaded level
    Connections {
        // only connect if a level is loaded, to prevent errors
        target: activeLevel !== undefined ? activeLevel : null
        onLeftPunchPressed: {
            // only increase score when game is running
            if(gameRunning) {
                leftScore++
            }
        }
        onRightPunchPressed: {
            // only increase score when game is running
            if(gameRunning) {
                rightScore++
            }
        }
    }


    // text displaying either the countdown or "tap!"
    Text {
        id: liveText
        anchors.centerIn: parent
        color: "white"

        // font.pixelSize: countdown > -1 ? 120 : 0
        text: getText()
        visible: countdown > -1
        enabled: visible
    }

    SoundEffect {
        id: one_sound
        source: "../img/one.wav"
    }

    SoundEffect {
        id: two_sound
        source: "../img/two.wav"
    }

    SoundEffect {
        id: three_sound
        source: "../img/three.wav"
    }

    SoundEffect {
        id: fight_sound
        source: "../img/fight.wav"
    }

    NumberAnimation {
        id: animateSize
        target: liveText
        properties: "font.pixelSize"
        from: 20
        to: 140
        easing.type: Easing.InOutQuad
        duration: 200
    }

    // if the countdown is greater than 0, this timer is triggered every second, decreasing the countdown (until it hits 0 again)
    Timer {
        repeat: true
        running: countdown > -1
        onTriggered: {
            countdown--
            playCountDown()
            animateSize.start()
        }
    }

    function playCountDown() {
        if (countdown == 3)
        {
            three_sound.play()
        }
        else if (countdown == 2)
        {
            two_sound.play()
        }
        else if (countdown == 1)
        {
            one_sound.play()
        }
        else if (countdown == 0)
        {
            fight_sound.play()
        }
    }

    function getText() {
        var theText = ""
        if (countdown == 4)
        {
            theText = ""
        }
        else if (countdown > 0 )
        {
            theText = countdown
        }
        else if (countdown == 0)
        {
            theText = "Fight!"
        }
        else
        {
            theText = ""
        }

        return theText
    }

    SequentialAnimation {
        id: left_red_screen
        NumberAnimation {
            target: left_mask
            property: "opacity"
            to: 0.5
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: left_mask
            property: "opacity"
            to: 0
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    SequentialAnimation {
        id: right_red_screen
        NumberAnimation {
            target: right_mask
            property: "opacity"
            to: 0.5
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: right_mask
            property: "opacity"
            to: 0
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }
}
