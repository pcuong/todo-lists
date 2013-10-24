/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.sensors 1.2
import CustomElements 1.0
import "../common"

Window {
    id: window

    /*!
      Sets the screen to appropriate mode. Modes that are supported are
        "" is default mode
        "fullScreen" sets the task list on full screen mode
        "sortTasks" shows the sort tasks header
        "markTasks" shows the mark tasks header
    */
    function setScreenMode(mode) {
        if (mode !== "" && mode !== "fullScreen" && mode !== "sortTasks" &&
                mode !== "markTasks") {
            console.log("Invalid screen mode: " + mode);
            return;
        }

        window.state = mode;
    }


    /*!
      Reset the page stacks of each tab.
    */
    function resetStacks() {
        pageStackWork.resetStack();
        pageStackWork.toolBar.setTools(mainToolBarLayout);
        pageStackHome.resetStack();
        pageStackHome.toolBar.setTools(mainToolBarLayout);
        pageStackShopping.resetStack();
        pageStackShopping.toolBar.setTools(mainToolBarLayout);

        if (tabGroup.currentTab === pageStackWork)
            qtHelper.saveSetting("DefaultTab", 0);
        else if (tabGroup.currentTab === pageStackHome)
            qtHelper.saveSetting("DefaultTab", 1);
        else if (tabGroup.currentTab === pageStackShopping)
            qtHelper.saveSetting("DefaultTab", 2);
    }


    /*!
      Iterates tab if the app is in normal mode.
    */
    function iterateTab() {
        if (state !== "" || tabGroup.currentTab.depth !== 1)
            return;

        if (tabGroup.currentTab === pageStackWork)
            tabGroup.currentTab = pageStackHome;
        else if (tabGroup.currentTab === pageStackHome)
            tabGroup.currentTab = pageStackShopping;
        else if (tabGroup.currentTab === pageStackShopping)
            tabGroup.currentTab = pageStackWork;

        resetStacks();
    }

    Component.onCompleted: {
        var tabIndex = qtHelper.loadSetting("DefaultTab", 0);
        switch (tabIndex) {
        case "0":
            tabGroup.currentTab = pageStackWork;
            break;
        case "1":
            tabGroup.currentTab = pageStackHome;
            break;
        case "2":
            tabGroup.currentTab = pageStackShopping;
            break;
        }
    }

    // Global custom helper class implemented with Qt.
    QtHelper { id: qtHelper }

    DoubleTab {
        onDoubleTapped: { iterateTab(); }
    }

    TabGroup {
        id: tabGroup

        anchors {
            top: tabBarLayout.bottom
            bottom: toolBar.top
            left: parent.left
            right: parent.right
        }

        TaskPageStack {
            id: pageStackWork

            taskModelName: "Work"
            toolBar: toolBar
            onScreenMode: setScreenMode(mode);
            imageSource: "../images/work_bg_icon.svg"
            sortImageSource: "../images/sort_bg_icon.svg"
            gradientColor: "#09A7CC"
            sortModeGradientColor: "#648596"
        }

        TaskPageStack {
            id: pageStackHome

            taskModelName: "Home"
            toolBar: toolBar
            onScreenMode: setScreenMode(mode);
            imageSource: "../images/home_bg_icon.svg"
            sortImageSource: "../images/sort_bg_icon.svg"
            gradientColor: "#62B700"
            sortModeGradientColor: "#648596"
        }

        TaskPageStack {
            id: pageStackShopping

            taskModelName: "Shopping"
            toolBar: toolBar
            onScreenMode: setScreenMode(mode);
            imageSource: "../images/shopping_bg_icon.svg"
            sortImageSource: "../images/sort_bg_icon.svg"
            gradientColor: "#CC09BA"
            sortModeGradientColor: "#648596"
        }
    }

    TabBar {
        id: tabBarLayout

        anchors {
            top: statusBar.bottom
            left: parent.left
        }

        width: parent.width

        TabButton {
            tab: pageStackWork
            iconSource: "../images/work.png"
            text: "Work"
            onClicked: { window.resetStacks(); }
        }

        TabButton {
            tab: pageStackHome
            iconSource: "../images/home.png"
            text: "Home"
            onClicked: { window.resetStacks(); }
        }

        TabButton {
            tab: pageStackShopping
            iconSource: "../images/shopping.png"
            text: "Shopping"
            onClicked: { window.resetStacks(); }
        }
    }

    Image {
        id: header

        property string text

        anchors {
            top: tabBarLayout.top
            bottom: tabBarLayout.bottom
            left: tabBarLayout.right
        }

        width: parent.width
        source: "../images/header_bg.png"

        Label {
            anchors {
                fill: parent
                rightMargin: platformStyle.paddingMedium
            }

            text: header.text
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    StatusBar {
        id: statusBar

        anchors.top: parent.top

        Label {
            x: platformStyle.paddingSmall
            text: "ToDo Lists"
        }
    }

    ToolBar {
        id: toolBar

        anchors.bottom: parent.bottom

        tools: ToolBarLayout {
            id: mainToolBarLayout

            ToolButton {
                id: buttonBack

                iconSource: "toolbar-back"
                onClicked: Qt.quit();
            }

            ToolButton {
                id: buttonCheck

                enabled: tabGroup.currentTab.taskModel.count
                iconSource: enabled ? "../images/check.svg"
                                    : "../images/check-disabled.svg"
                onClicked: {
                    setScreenMode("markTasks");
                    tabGroup.currentTab.toDeleteMode();
                }
            }

            ToolButton {
                id: buttonAdd

                iconSource: "toolbar-add"
                onClicked: {
                    var date = Qt.formatDate(new Date, "yyyy-MM-dd");
                    tabGroup.currentTab.showDetailsPage(-1, "", false, date);
                }
            }

            ToolButton {
                id: buttonMenu

                iconSource: "toolbar-menu"
                onClicked: menu.open();
            }
        }
    }

    Menu {
        id: menu

        content: MenuLayout {
            MenuItem {
                text: "Sort"
                onClicked: {
                    tabGroup.currentTab.toSortMode();
                }
            }
            MenuItem {
                text: "About"
                onClicked: {
                    setScreenMode("fullScreen");
                    tabGroup.currentTab.push(Qt.resolvedUrl("AboutPage.qml"));
                }
            }
        }
    }

    states: [
        State {
            name: "fullScreen"
            PropertyChanges {
                target: tabBarLayout
                anchors.topMargin: -tabBarLayout.height
            }
        },
        State {
            name: "sortTasks"
            PropertyChanges {
                target: tabBarLayout
                anchors.leftMargin: -tabBarLayout.width
            }
            StateChangeScript {
                script: header.text = "Sort tasks"
            }
        },
        State {
            name: "markTasks"
            PropertyChanges {
                target: tabBarLayout
                anchors.leftMargin: -tabBarLayout.width
            }
            StateChangeScript {
                script: header.text = "Mark completed tasks"
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "anchors.topMargin, anchors.leftMargin"
                easing.type: Easing.InOutCubic
                duration: 200
            }
        }
    ]
}
