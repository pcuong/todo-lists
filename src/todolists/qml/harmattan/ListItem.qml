/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0


Item {
    id: listItem

    signal clicked()
    signal pressAndHold()

    property bool selected: false
    property bool enabled: true
    property bool subItemIndicator: false
    property bool comboBoxArrow: false
    property alias title: title.text
    property alias subTitle: subTitle.text
    property alias highlight: highlight

    width: 480
    height: 80

    Rectangle {
        id: highlight

        anchors.fill: parent

        opacity: 0.0
        color: "#cc404040"

        Behavior on opacity { PropertyAnimation { duration: 50 } }
    }

    Column {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left; leftMargin: 8
            right: subIndicatorArrow.left; rightMargin: 35
        }

        spacing: 2

        Label {
            id: title

            width: parent.width
            elide: Text.ElideRight
            color: (listItem.enabled && !listItem.selected)
                   ? platformStyle.textColor
                   : "gray"
        }

        Label {
            id: subTitle

            color: "gray"
            font.pixelSize: title.font.pixelSize - 2
        }
    }

    Image {
        id: subIndicatorArrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right; rightMargin: 10
        }
        width: sourceSize.width

        visible: listItem.subItemIndicator
        smooth: true
        source: "image://theme/icon-m-common-drilldown-arrow" +
                (theme.inverted ? "-inverse" : "");
    }

    Image {
        id: comboBoxArrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right; rightMargin: 10
        }
        width: sourceSize.width

        visible: listItem.comboBoxArrow
        smooth: true
        source: listItem.enabled ? "../images/combobox-arrow.png"
                                 : "../images/combobox-arrow-disabled.png"
    }


    MouseArea {
        anchors.fill: parent

        enabled: listItem.enabled

        onPressed: {
            highlight.opacity = 1.0;
            listItem.selected = true;
        }

        onReleased: {
            highlight.opacity = 0;
            listItem.selected = false;
        }

        onCanceled: {
            highlight.opacity = 0;
            listItem.selected = false;
        }

        onClicked: { parent.clicked(); }
        onPressAndHold: { parent.pressAndHold(); }
    }
}
