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

    FocusHighlight {
        id: focusHighlight
        width: dateSelectionList.width
        height: dateSelectionList.height
        x: dateSelectionList.x
        y: dateSelectionList.focus ? dateSelectionList.y :
           dueDateSwitch.focus ? dueSwitch.y :
           taskField.focus ? taskName.y : 0
        opacity: (dateSelectionList.focus ||
                  dueDateSwitch.focus ||
                  taskField.focus) ? 1.0 : 0
    }

    Column {
        id: column

        anchors {
            top: parent.top; topMargin: 20
            left: parent.left; leftMargin: 30
            right: parent.right; rightMargin: 30
        }

        spacing: 20

        Item {
            id: taskName
            anchors {
                left: parent.left; leftMargin: 2
                right: parent.right; rightMargin: -2
            }

            height: 50
            width: column.width

            TextField {
                id: taskField

                width: column.width
                text: detailsPage.taskText
                onTextChanged: detailsPage.taskText = text
            }
        }

        Item {
            id: dueSwitch
            anchors {
                left: parent.left; leftMargin: 2
                right: parent.right; rightMargin: -2
            }

            height: 50

            Label {
                id: dueDateLabel
                anchors.verticalCenter: parent.verticalCenter

                height: 20
                text: "Use due date"
            }

            Switch {
                id: dueDateSwitch
                anchors.right: parent.right

                checked: detailsPage.useDueDate
                onClicked: detailsPage.useDueDate = checked;
            }
        }
    }

    SelectionListItem {
        id: dateSelectionList
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
            page.forceActiveFocus();
        }
    }


    tools: ToolBarLayout {
        id: acceptTaskToolbarLayout
        property alias doneButton: doneButton

        ToolButton {
            visible: false
        }

        ToolButton {
            id: doneButton
            enabled: taskField.text.length !== 0
            text: "Done"
            onClicked: updateTask()

            function updateTask()
            {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout);
                pageStack.updateTask(detailsPage.taskIndex,
                                     detailsPage.taskText,
                                     detailsPage.useDueDate,
                                     detailsPage.dueDate,
                                     false);
                pageStack.tasksPage.taskListView.forceActiveFocus();
                pageStack.screenMode("");
            }
        }

        ToolButton {
            text: "Cancel"
            onClicked: {
                var pageStack = detailsPage.pageStack;
                pageStack.pop();
                pageStack.toolBar.setTools(mainToolBarLayout);
                pageStack.screenMode("");
            }
        }

        ToolButton {
            visible: false
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Up) {
            if (dateSelectionList.focus) {
                dueDateSwitch.focus = true
            }
            else  if (dueDateSwitch.focus) {
                taskField.focus = true
            }
            else {
                dateSelectionList.focus = true
            }
        }
        else if (event.key === Qt.Key_Down) {
            if (taskField.focus) {
                dueDateSwitch.focus = true
            }
            else if (dueDateSwitch.focus){
                dateSelectionList.focus = true
            }
            else {
                taskField.focus = true
            }
        }
        else if (event.key === Qt.Key_Enter ||
                 event.key === Qt.Key_Return ||
                 event.key === Qt.Key_Select) {
            if (!dueDateSwitch.focus &&
                !taskField.focus &&
                !dateSelectionList.focus &&
                acceptTaskToolbarLayout.doneButton.enabled)
            {
                acceptTaskToolbarLayout.doneButton.updateTask()
            }
        }
    }
}
