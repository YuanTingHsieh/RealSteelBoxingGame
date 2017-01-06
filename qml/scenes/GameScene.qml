import VPlay 2.0
import QtQuick 2.0
import "../common"

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
    }

    OneArena {
        id: rightfield
        score: rightScore
        anchors.right: gameScene.gameWindowAnchorItem.right
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
            item.width = gameScene.width
            item.height = gameScene.height
            // store the loaded level as activeLevel for easier access
            activeLevel = item
            // restarts the countdown
            countdown = 3
        }
        signal punchHit (int punchType)
        onPunchHit: {
            if (gameRunning) {
                if (punchType == 0)
                {
                    item.handleLeft()
                }
                else if (punchType ==1)
                {
                    item.handleLeft_2()
                }
            }
        }
    }

    // we connect the gameScene to the loaded level
    Connections {
        // only connect if a level is loaded, to prevent errors
        target: activeLevel !== undefined ? activeLevel : null
        // increase the score when the rectangle is clicked

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
            animateSize.start()
        }
    }

    function getText() {
        var theText = ""
        if (countdown > 0 )
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
}
