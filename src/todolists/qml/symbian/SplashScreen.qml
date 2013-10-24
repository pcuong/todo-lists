/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: splashScreen

    signal hidden();

    function startHideAnimation() {
        hideAnimation.start();
    }

    anchors.fill: parent

    z: 1

    Image {
        source: {
            if (parent.width === 360)
                return "../images/splash_360x640.jpg";
            else if (parent.width === 640)
                return "../images/splash_640x480.jpg";
            else if (parent.width === 480)
                return "../images/splash_480x854.jpg";
            else
                return "";
        }
    }

    // To catch clicks on splash screen and prevent them to go the task list.
    MouseArea {
        anchors.fill: parent
    }

    SequentialAnimation {
        id: hideAnimation

        PropertyAnimation {
            target: splashScreen
            property: "opacity"
            duration: 800
            to: 0
        }

        ScriptAction { script: splashScreen.hidden(); }
    }
}
