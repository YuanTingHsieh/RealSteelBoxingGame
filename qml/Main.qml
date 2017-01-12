import VPlay 2.0
import QtQuick 2.0
import "scenes"
import QtMultimedia 5.5

GameWindow {
    id: window
    screenWidth: 960
    screenHeight: 640

    // You get free licenseKeys from http://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from http://v-play.net/licenseKey>"
    licenseKey: "9A45B1952CB437828D082873D2E1230414329DF9DD3F0C83270012769FB2AF69EC5D19DB741053DBD0032AC08ADD9E1193482196BAE05906709C294E635A6406425EB54805B536CC30C7B1522049343101181D96EB16F7EC15B410DA30960D175D81799D7F4D5EFBCACCF2B8CF1DAF557E3EF9EADC5AF08C8520F50CD539AA9BC3AB574DCB53712042A5E5B2470933EC56EB7DBDCDAA9D44EFE355427C1BF1F162F5BF8CFD7D9997B3E3CB67054734653B0764DB95A5998733D42FF417F7E8CB5839FB4470A37CBD9FBD9EAEAA81E52B3A540D137DF1FE655E52D5141AB2A8A0345F629105FEA16DCB225C7DE6788CA9B393CF9FA7577C9FD49056388728C075D20EF5BDC356161EF436AB54FD25B12F1FCC81C668E0FC09A4D776E0673298E0"

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
    }

    Audio {
        id: playBackMusic
        source: "img/strength_of_a_thousand_men.mp3"
        autoPlay: true
        loops: Audio.Infinite
        volume: 0.8
    }

    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onSelectLevelPressed: window.state = "selectLevel"
        onCreditsPressed: window.state = "credits"
        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && window.activeScene === menuScene)
                    Qt.quit()
            }
        }
    }

    // scene for selecting levels
    SelectLevelScene {
        id: selectLevelScene
        onLevelPressed: {
            // selectedLevel is the parameter of the levelPressed signal
            gameScene.setLevel(selectedLevel)
            window.state = "game"

        }
        onBackButtonPressed: window.state = "menu"
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onBackButtonPressed: window.state = "selectLevel"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
            PropertyChanges {
                target: playBackMusic;
                muted: false
            }
        },
        State {
            name: "selectLevel"
            PropertyChanges {target: selectLevelScene; opacity: 1; user1Ready: false; user2Ready: false; user1Opacity: 0.5; user2Opacity: 0.5;}
            PropertyChanges {target: window; activeScene: selectLevelScene}
            PropertyChanges {
                target: playBackMusic;
                muted: false
            }           
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: creditsScene}
            PropertyChanges {
                target: playBackMusic;
                muted: false
            }
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
            PropertyChanges {
                target: playBackMusic;
                volume: 0.8
            }
        }
    ]

}
