/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
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
        taskField.openSoftwareInputPanel();
    }

    Background { id: background }

    Column {
        id: column

        anchors {
            top: parent.top; topMargin: 20
            left: parent.left; leftMargin: 30
            right: parent.right; rightMargin: 30
        }

        spacing: 20

        TextField {
            id: taskField

            width: parent.width
            text: detailsPage.taskText
            onTextChanged: detailsPage.taskText = text
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
                onClicked: detailsPage.useDueDate = checked;
            }
        }
    }

    SelectionListItem {
        anchors {
            top: column.bottom; topMargin: column.spacing
            left: parent.left; leftMargin: 15
            right: parent.right; rightMargin: 15
        }

        enabled: detailsPage.useDueDate
        title: "Due date"
        subTitle: qtHelper.dateString(dueDate)
        onClicked: {
            var pageStack = detailsPage.pageStack;
            pageStack.screenMode("fullScreen");
            var page = pageStack.push(Qt.resolvedUrl("DatePicker.qml"));
            page.setInitialDate(detailsPage.dueDate);
        }
    }


    tools: ToolBarLayout {
        id: acceptTaskToolbarLayout

        ToolButton {
            visible: false
        }

        ToolButton {
            enabled: taskField.text.length !== 0
            text: "Done"
            onClicked: {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout);
                pageStack.updateTask(detailsPage.taskIndex,
                                     detailsPage.taskText,
                                     detailsPage.useDueDate,
                                     detailsPage.dueDate,
                                     false);
            }
        }

        ToolButton {
            text: "Cancel"
            onClicked: {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout);
            }
        }

        ToolButton {
            visible: false
        }
    }
}
