import QtQuick 1.1
import com.nokia.symbian 1.1

PageStackWindow {
    id: appWindow
    property int pageMargin: 16
    property bool connected: xbmc.connected
    property bool nfcSheetOpen: false
    initialPage: connected ? mainPage : noConnectionPage

    MainPage{
        id: mainPage
        // model: mainMenuModel
    }

    NoConnectionPage {
        id: noConnectionPage
    }

    NowPlayingPage {
        id: nowPlayingPage
    }

    Keypad {
        id: keypadPage
    }

    PictureControlsPage {
        id: pictureControlsPage
    }

    ToolBarLayout {
        id: toolBarEntry
        visible: false
        ToolButton { iconSource: "toolbar-settings";
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: (myMenu.status == DialogStatus.Closed || myMenu.status == DialogStatus.Closing) ? myMenu.open() : myMenu.close()
        }
        ToolButton { iconSource: "toolbar-dialer";
            anchors.horizontalCenter: parent===undefined ? undefined : parent.horizontalCenter
            onClicked: {
                if(xbmc.picturePlayerActive) {
                    pageStack.push(pictureControlsPage);
                } else {
                    pageStack.push(keypadPage);
                }

            }
        }
        ToolButton {
            iconSource: "toolbar-mediacontrol-play" + (enabled ? "" : "-dimmed");
            enabled: xbmc.activePlayer !== null
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: pageStack.push(nowPlayingPage);
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Connect...")
                onClicked: {
                    var component = Qt.createComponent("ConnectionSheet.qml")
                    if (component.status == Component.Ready) {
//                        component.createObject(myMenu).open()
                        pageStack.push(component);
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }
            MenuItem {
                text: qsTr("Write NFC Tag")
                onClicked: {
                    var component = Qt.createComponent("WriteNfcTagSheet.qml")
                    if (component.status == Component.Ready) {
                        component.createObject(myMenu).open();
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    onClicked: {
                        var component = Qt.createComponent("SettingsSheet.qml")
                        if (component.status == Component.Ready) {
                            pageStack.push(component);
                        } else {
                            console.log("Error loading component:", component.errorString());
                        }
                    }
                }
            }
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    aboutDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Quit xbmc")
                onClicked: {
                    quitDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Quit")
                onClicked: {
                    Qt.quit();
                }
            }
        }
    }

    onConnectedChanged: {
        console.log("connectedChanged " + connected)
        pageStack.clear();
        if(!connected) {
            var component = Qt.createComponent("NoConnectionPage.qml")
            if (component.status == Component.Ready) {
                pageStack.push(component);
            } else {
                console.log("Error loading component:", component.errorString());
            }
        } else {
            var component = Qt.createComponent("MainPage.qml")
            if (component.status == Component.Ready) {
                pageStack.push(component);
            } else {
                console.log("Error loading component:", component.errorString());
            }
        }
    }

    Connections {
        target: xbmc
        onAuthenticationRequired: {
            print("auth required");
            var component = Qt.createComponent("AuthenticationSheet.qml")
            if (component.status == Component.Ready) {
                pageStack.push(component, {hostname: hostname });
            } else {
                console.log("Error loading component:", component.errorString());
            }
        }
    }

    Connections {
        target: nfcHandler
        onTagError: {
            print("NFC tag error", errorMessage);
            if(!appWindow.nfcSheetOpen) {
                print("opening dialog");
                var component = Qt.createComponent("WriteNfcTagSheet.qml")
                if (component.status === Component.Ready) {
                    component.createObject(myMenu, { errorMessage: errorMessage }).open();
                    print("opening dialog");
                    appWindow.nfcSheetOpen = true;
                } else {
                    console.log("Error loading component:", component.errorString());
                }
            }
        }
    }

    Dialog {
        id: quitDialog
        buttons {
            Column {
                spacing: 30
                Column {
                    spacing: 10
                    Button {
                        text: qsTr("Quit")
                        onClicked: xbmc.quit();
                    }
                    Button {
                        text: qsTr("Shutdown")
                        visible: xbmc.canShutdown
                        onClicked: xbmc.shutdown();
                    }
                    Button {
                        text: qsTr("Reboot")
                        visible: xbmc.canReboot
                        onClicked: xbmc.reboot();
                    }
                    Button {
                        text: qsTr("Suspend")
                        visible: xbmc.canSuspend
                        onClicked: xbmc.suspend();
                    }
                    Button {
                        text: qsTr("Hibernate")
                        visible: xbmc.canHibernate
                        onClicked: xbmc.hibernate();
                    }
                }

                Button {
                    text: qsTr("Cancel")
                    onClicked: quitDialog.close();
                }
            }
        }
    }

    Dialog {
        id: aboutDialog

        title: Column {
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: "Xbmcremote 1.1"
                width: parent.width
                font.pixelSize: 40
                color: "white"
            }
        }

        content:Column {
            id: name
            height: 200
            width: parent.width
            Item { width: parent.width; height: 20 }
            Image {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                source: "icons/xbmcremote_harmattan.png"
            }
            Label {
                id: text
                font.pixelSize: 22
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                text: qsTr("Copyright") + "\n Michael Zanetti\n michael_zanetti@gmx.net\n\n"
            }
        }

        buttons {
            Button {
                id: closeButton
                width: parent.width
                text: qsTr("Close")
                onClicked: aboutDialog.close()
            }
        }
    }
}
