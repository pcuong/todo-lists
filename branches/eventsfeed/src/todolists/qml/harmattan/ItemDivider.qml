/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1


Item {
    id: itemDivider

    property alias text: text.text

    width: 100
    height: text.height

    Image {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: text.left; rightMargin: 32
        }

        height: 2
        source: "../images/itemdivider.png"
    }

    Text {
        id: text

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        color: "gray"
        font.pixelSize: 18
    }
}
