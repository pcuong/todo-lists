/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: aboutPage

    tools: ToolBarLayout {
        id: aboutToolBarLayout

        ToolButton {
            id: buttonBack

            iconSource: "toolbar-back"
            onClicked: {
                buttonBack.enabled = false;

                var pageStack = aboutPage.pageStack;

                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout);
                pageStack.screenMode("");
            }
        }
    }

    Image {
        source: "../images/about_bg_480x854.svg"
        width: 720
        height: 1280
    }

    Flickable {
        id: flickable

        anchors.fill: parent

        contentWidth: width
        contentHeight: label.height

        Label {
            id: label

            anchors.centerIn: parent

            width: flickable.width - 15
            font.pixelSize: platformStyle.fontSizeLarge
            wrapMode: Text.WordWrap
            text: "<h1>ToDo Lists v. 1.2</h1>" +
                  "<p>ToDo Lists is a Nokia Developer example application " +
                  "demonstrating the use of the " +
                  "<a href=\"http://doc.qt.nokia.com/qt-components-symbian-1.0/index.html\">" +
                  "Qt Quick Components</a>. ToDo Lists allows the user to " +
                  "manage and track tasks in three different categories, set " +
                  "their due date and sort the tasks.</p>" +
                  "<p>This example application is hosted in " +
                  "<a href=\"http://projects.developer.nokia.com/todolists\">" +
                  "Nokia Developer Projects</a>.</p>"

            onLinkActivated: { Qt.openUrlExternally(link); }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }
}
