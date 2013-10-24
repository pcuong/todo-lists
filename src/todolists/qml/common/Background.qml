/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: background

    property alias imageSource: image.source
    property color color: "#648596"

    anchors.fill: parent

    Behavior on color { ColorAnimation {} }

    Rectangle {
        id: rectangle

        anchors {
            top: parent.top
            bottom: glow.top
            left: parent.left
            right: parent.right
        }

        gradient: Gradient {
            GradientStop { position: 0; color: "black" }
            GradientStop { position: 0.3; color: "black" }
            GradientStop {
                position: 1.0
                color: Qt.darker(background.color, 3.5)
            }
        }
    }

    Image {
        id: image

        anchors {
            left: parent.left; leftMargin: -0.15 * width
            bottom: parent.bottom; bottomMargin: -0.15 * height
        }

        fillMode: Image.PreserveAspectFit

        width: Math.min(parent.width, parent.height)
        height: width
        sourceSize.width: 500
        sourceSize.height: 500
        opacity: 0.8

        smooth: true
    }

    Rectangle {
        id: leftGlow

        anchors {
            top: parent.verticalCenter
            bottom: parent.bottom
            left: parent.left
        }

        width: 1

        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: Qt.darker(background.color) }
        }
    }

    Rectangle {
        id: glow

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: 2
        color: background.color
    }
}
