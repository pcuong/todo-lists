/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
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
                mode !== "markTasks"  && mode !== "newTask" && mode !== "editTask") {
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
        // Use the black theme on Harmattan.
        theme.inverted = true;

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

        resetStacks();
    }

    // Global custom helper class implemented with Qt.
    QtHelper { id: qtHelper }

    // The following element enables iterating through the tabs using the
    // double tap gesture. The use of the gesture in this situation is
    // questionable in respect to UX guidelines and thus, it is commented out.
    // Simply uncomment the following block to enable the gesture.
    //
    /*DoubleTap {
        onDoubleTapped: window.iterateTab();
    }*/

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

    ButtonRow {
        id: tabBarLayout

        anchors {
            top: statusBar.bottom
            left: parent.left
        }

        width: parent.width
        style: TabButtonStyle {
            fontPixelSize: 19
        }

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
        source: "../images/header_bg_harmattan.png"

        Label {
            anchors {
                fill: parent
                rightMargin: 5
            }

            text: header.text
            font.pixelSize: 19
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    StatusBar {
        id: statusBar

        anchors.top: parent.top
    }

    ToolBar {
        id: toolBar

        anchors.bottom: parent.bottom

        tools: ToolBarLayout {
            id: mainToolBarLayout

            ToolIcon {
                id: buttonCheck

                enabled: tabGroup.currentTab.taskModel.count
                iconSource: enabled
                            ? "../images/toolbar_check_40x40.png"
                            : "../images/toolbar_check_disabled_40x40.png"
                onClicked: {
                    setScreenMode("markTasks");
                    tabGroup.currentTab.toDeleteMode();
                }
            }

            ToolIcon {
                id: buttonAdd

                iconSource: "../images/toolbar_add_40x40.png"
                onClicked: {
                    setScreenMode("newTask");
                    var date = Qt.formatDate(new Date, "yyyy-MM-dd");
                    tabGroup.currentTab.showDetailsPage(-1, "", false, date);
                }
            }

            ToolIcon {
                id: buttonSort

                enabled: tabGroup.currentTab.taskModel.count >= 2
                iconSource: enabled
                            ? "../images/toolbar_sort_40x40.png"
                            : "../images/toolbar_sort_disabled_40x40.png"
                onClicked: { tabGroup.currentTab.toSortMode(); }
            }

            ToolIcon {
                id: buttonAbout

                iconSource: "../images/toolbar_info_40x40.png"
                onClicked: {
                    if (tabGroup.currentTab.depth === 1) {
                        setScreenMode("fullScreen");
                        tabGroup.currentTab.push(Qt.resolvedUrl("AboutPage.qml"));
                    }
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
        },
        State {
            name: "editTask"
            PropertyChanges {
                target: tabBarLayout
                anchors.leftMargin: -tabBarLayout.width
            }
            StateChangeScript {
                script: header.text = "Edit task"
            }
        },
        State {
            name: "newTask"
            PropertyChanges {
                target: tabBarLayout
                anchors.leftMargin: -tabBarLayout.width
            }
            StateChangeScript {
                script: header.text = "Create a new task"
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
