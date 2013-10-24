/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Rectangle {
    opacity: 0.0
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#1080dd" }
        GradientStop { position: 0.98; color: "#54a4e7" }
        GradientStop { position: 1; color: "#6eb2ea" }
    }

    Behavior on opacity { PropertyAnimation { duration: 100 } }
}
