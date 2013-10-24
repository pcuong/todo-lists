/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import CustomElements 1.0
import "../common"

Page {
    id: detailsPage

    property int taskIndex: -1
    property string taskText: ""
    property bool useDueDate: false
    property date dueDate

    /*!
      Selects the taskField and opens the software input panel.
    */
    function selectTextField() {
        taskField.focus = true;
        taskField.platformOpenSoftwareInputPanel();
    }

    Background { id: background }

    Flickable {
        anchors.fill: parent

        contentWidth: parent.width
        contentHeight: column.height

        Column {
            id: column

            anchors {
                top: parent.top; topMargin: 20
                left: parent.left; leftMargin: 30
                right: parent.right; rightMargin: 30
            }

            spacing: 23

            ItemDivider {
                width: parent.width
                text: "Task"
            }

            TextField {
                id: taskField

                width: parent.width
                text: detailsPage.taskText
                onTextChanged: detailsPage.taskText = text
                onAccepted: { closeSoftwareInputPanel(); }

                // Disable predictive text input to allow the Done
                // button to react if text field is empty or not.
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            ItemDivider {
                width: parent.width
                text: "Due date"
            }

            Item {
                anchors {
                    left: parent.left; leftMargin: 2
                    right: parent.right; rightMargin: -2
                }

                height: 40

                Label {
                    anchors.verticalCenter: parent.verticalCenter

                    height: 20
                    text: "Use due date"
                }

                Switch {
                    anchors.right: parent.right

                    checked: detailsPage.useDueDate
                    onCheckedChanged: { detailsPage.useDueDate = checked; }
                }
            }

            ListItem {
                width: parent.width

                enabled: detailsPage.useDueDate
                title: "Due date"
                subTitle: qtHelper.dateString(dueDate)
                comboBoxArrow: true
                onClicked: {
                    var pageStack = detailsPage.pageStack;
                    pageStack.screenMode("fullScreen");
                    var page = pageStack.push(Qt.resolvedUrl("DatePicker.qml"));
                    page.setInitialDate(detailsPage.dueDate);
                }
            }
        }
    }

    tools: ToolBarLayout {
        id: acceptTaskToolbarLayout

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }

        ToolButton {
            enabled: taskField.text.length !== 0
            text: "Done"
            onClicked: {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout, "pop");
                pageStack.updateTask(detailsPage.taskIndex,
                                     detailsPage.taskText,
                                     detailsPage.useDueDate,
                                     detailsPage.dueDate,
                                     false);
                pageStack.screenMode("");
            }
        }

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }

        ToolButton {
            text: "Cancel"
            onClicked: {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout, "pop");
                pageStack.screenMode("");
            }
        }

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }
    }
}
