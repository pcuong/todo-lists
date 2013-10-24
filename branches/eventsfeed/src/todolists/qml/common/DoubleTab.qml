/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.sensors 1.2


Item {
    id: doubleTap

    signal doubleTapped()

    TapSensor {
        id: tapSensor

        property bool preventTap: false;

        active: true

        onReadingChanged: {
            if (preventTap)
                return;

            preventTap = true;
            preventTapsTimer.start()

            doubleTap.doubleTapped();
        }
    }

    Timer {
        id: preventTapsTimer

        interval: 200
        running: false
        repeat: false
        onTriggered: tapSensor.preventTap = false;
    }
}
