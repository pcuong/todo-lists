/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import CustomElements 1.0
import "../common"


Page {
    id: tasksPage

    property alias taskModel: taskModel
    property alias taskModelName: taskModel.modelName
    property string imageSource
    property string sortImageSource
    property color gradientColor
    property color sortModeGradientColor

    /*!
      Switches tasks page to delete mode allowing the user to check the
      completed tasks.
    */
    function toDeleteMode() {
        listView.showCheckBox = true;
        var pageStack = tasksPage.pageStack;
        pageStack.toolBar.setTools(tasksPageToolbarLayout, "push");
    }

    /*!
      Switches the list in sort mode allowing user to sort the tasks.
    */
    function toSortMode() {
        taskModel.saveSortState();
        listView.inSortMode = true;
        var pageStack = tasksPage.pageStack;
        pageStack.screenMode("sortTasks");
        pageStack.toolBar.setTools(tasksPageToolbarLayout, "push");

        qtHelper.enableSwipe(false);
    }

    /*!
      Switched tasks page back to the normal mode.
    */
    function toNormalMode() {
        listView.showCheckBox = false;
        listView.inSortMode = false;
    }

    /*!
      Closes the page.
    */
    function closePage() {
        listView.showCheckBox = false;
        listView.inSortMode = false;

        var pageStack = tasksPage.pageStack;
        pageStack.pop();
        pageStack.toolBar.setTools(mainToolBarLayout, "pop");
        pageStack.screenMode("");

        qtHelper.enableSwipe(true);
    }

    Background {
        id: background

        color: listView.inSortMode ? tasksPage.sortModeGradientColor
                                   : tasksPage.gradientColor

        imageSource: listView.inSortMode ? tasksPage.sortImageSource
                                         : tasksPage.imageSource
    }

    tools: ToolBarLayout {
        id: tasksPageToolbarLayout

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }

        ToolButton {
            text: "Done"
            onClicked: {
                if (listView.showCheckBox) {
                    taskModel.removeTasks();
                }

                closePage();
            }
        }

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }

        ToolButton {
            text: "Cancel"
            onClicked: {
                if (listView.showCheckBox) {
                    taskModel.resetCheckedProperties();
                }

                if (listView.inSortMode) {
                    taskModel.revertSort();
                }

                closePage();
            }
        }

        ToolIcon {
            iconSource: "../images/toolbar_blank_40x40.png"
        }
    }

    Component {
        id: listItemDelegate

        ListItem {
            id: listItem

            width: listView.width

            title: task // comes from TaskModel
            subTitle: useDueDate ? qtHelper.dateString(dueDate) : ""

            subItemIndicator: !listView.showCheckBox && !listView.inSortMode
            onClicked: {
                if (!listView.showCheckBox) {

                    //set the screenmode to editTask to display correct header
                    var pageStack = tasksPage.pageStack;
                    pageStack.screenMode("editTask");

                    // The task, useDueDate and dueData comes from TaskModel.
                    if (useDueDate === false) {
                        // If the useDueDate is not set, reset the dueDate in
                        // model to current date
                        var date = Qt.formatDate(new Date, "yyyy-MM-dd");
                        showDetailsPage(index, task, useDueDate, date);
                    }
                    else {
                        showDetailsPage(index, task, useDueDate, dueDate);
                    }
                } else if (listView.showCheckBox && !listView.inSortMode){
                    checkBox.checked = !checkBox.checked;
                    checkBox.checkTask();
                }
            }

            onPressAndHold: {
                if (!listView.showCheckBox && !listView.inSortMode &&
                        taskModel.count >= 2)
                    tasksPage.toSortMode();
            }

            Rectangle {
                x: 1
                width: 2; height: parent.height
                opacity: useDueDate &&
                         qtHelper.daysFromToday(dueDate) <= 0 ? 1.0 : 0
                color: "red"
            }

            CheckBox {
                id: checkBox

                anchors {
                    right: parent.right; rightMargin: 20
                    verticalCenter: parent.verticalCenter
                }

                visible: listView.showCheckBox
                checked: model.checked    // comes from TaskModel
                onClicked:checkTask()

                function checkTask()
                {
                    taskModel.editTaskData(index, task, useDueDate, dueDate,
                                           checkBox.checked);
                }
            }
        }
    }

    TaskModel {
        id: taskModel
    }

    ListView {
        id: listView

        // Tells is the checkboxes should be shown on the list items.
        property bool showCheckBox: false

        // Tells if the task list is on the sorting mode.
        property bool inSortMode: false

        anchors{
            fill: parent
            bottomMargin: 2
        }
        interactive: !inSortMode
        model: taskModel
        delegate: listItemDelegate
        snapMode: ListView.SnapToItem
        clip: true
    }

    ScrollDecorator {
        id: scrollDecorator

        flickableItem: listView
    }

    /*!
      MouseArea for the sorting feature of the tasks.
    */
    MouseArea {
        id: sortMouseArea

        // The index of the item which is dragged.
        property int fromIndex: -1

        // The y-coordinate of the item which is dragged.
        property int fromIndexMouseY: -1

        // Moving past the end, used to restrict the scrolling when the item
        // is dragged over the end of the visible list.
        property bool preventMove: false

        // Tells the moving direction of the fromIndex item when the item is
        // moved over the end of the visible list.
        property bool movingUp

        /*!
          Returns the index of the fromIndex item where it should move if it is
          possible to move the item past the visible area. Otherwise
          returns -1.
          If the item is possible to be moved, the function positions the view
          so that the returned index is visible on the list view.
        */
        function indexPastVisibleArea() {
            var toIndex = -1;

            if (preventMove) {
                // The list just moved, let's wait a little.
                return toIndex;
            }

            if (movingUp) {
                // Moving up
                if (fromIndex === 0) {
                    // Can't move past the beginning of the list.
                    return toIndex;
                }

                toIndex = fromIndex-1;
            }
            else {
                // Moving down
                if (fromIndex >= listView.count-1) {
                    // Can't move past the end of the list.
                    return -1;
                }

                toIndex = fromIndex + 1;
            }

            listView.positionViewAtIndex(toIndex, ListView.Contain);
            preventMove = true;
            movePreventionTimer.running = true;

            return toIndex;
        }

        anchors.fill: listView
        enabled: listView.inSortMode

        onPressed: {
            // Find out the pressed item
            fromIndex = listView.indexAt(0, listView.contentY + mouseY);
            fromIndexMouseY = mouseY;

            if (fromIndex !== -1) {
                // Highlight the item
                listView.currentIndex = fromIndex;
                listView.currentItem.highlight.opacity = 1.0;
            }
        }

        onPositionChanged: {
            if (fromIndex === -1) {
                return;
            }

            var toIndex;

            if (mouseY < 0 || mouseY > height) {
                // The user holds the finger outside the visible list items.

                // Find out the direction we should go
                movingUp = fromIndexMouseY > mouseY;

                // Retrieve the index of the item past the visible range.
                toIndex = indexPastVisibleArea();
                if (toIndex === -1) {
                    return;
                }
            }
            else {
                // Find out the index of the item in somewhere in the center
                // of the visible list.
                toIndex = listView.indexAt(0, listView.contentY + mouseY);
                movePreventionTimer.running = false;
                preventMove = false;
            }

            // Move the item to new position on model.
            taskModel.moveItem(fromIndex, toIndex);

            // Update the fromIndex, the user might continue the moving.
            fromIndex = toIndex;
        }

        onReleased: {
            movePreventionTimer.running = false;
            preventMove = false;

            if (listView.currentIndex !== -1) {
                listView.currentItem.highlight.opacity = 0;
            }
        }

        Timer {
            id: movePreventionTimer

            repeat: true
            interval: 400
            onTriggered: {
                sortMouseArea.preventMove = false;

                var toIndex = sortMouseArea.indexPastVisibleArea();
                if (toIndex === -1) {
                    return;
                }

                taskModel.moveItem(sortMouseArea.fromIndex, toIndex);
                sortMouseArea.fromIndex = toIndex;
            }
        }
    }
}
