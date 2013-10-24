/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1


PageStack {
    id: taskPageStack

    signal screenMode(string mode)

    property alias taskModel: tasksPage.taskModel
    property alias taskModelName: tasksPage.taskModelName
    property alias imageSource: tasksPage.imageSource
    property alias sortImageSource: tasksPage.sortImageSource
    property alias gradientColor: tasksPage.gradientColor
    property alias sortModeGradientColor: tasksPage.sortModeGradientColor

    /*!
      Shows the details page with given values.
    */
    function showDetailsPage(taskIndex, taskText, useDueDate, dueDate) {
        if (taskPageStack.depth !== 1) {
            return;
        }

        var page = taskPageStack.push(Qt.resolvedUrl("DetailPage.qml"));
        page.taskIndex = taskIndex;
        page.taskText = taskText;
        page.useDueDate = useDueDate;
        page.dueDate = dueDate;

        if (taskIndex === -1) {
            page.selectTextField();
        }
    }


    /*!
      Shows the checkboxes on list items allowing the user to mark the tasks
      for the deletion.
    */
    function toDeleteMode() {
        tasksPage.toDeleteMode();
    }


    /*!
      Allows the user to sort the tasks.
    */
    function toSortMode() {
        tasksPage.toSortMode();
    }


    /*!
      Updates the edited task item to the model. The index defines the item in
      the model, if the index is -1, new item will be added.
      Parameters: taskIndex (int),
                  taskText (string),
                  useDueDate (bool),
                  dueDate (date)
    */
    function updateTask(taskIndex, taskText, useDueDate, dueDate, checked) {
        if (taskIndex === -1) {
            tasksPage.taskModel.addTask(taskText, useDueDate, dueDate);
        }
        else {
            tasksPage.taskModel.editTaskData(taskIndex, taskText, useDueDate,
                                             dueDate, checked);
        }
    }

    /*!
      Resets page stack depth to 1, in other words closes the details page
      which might be open.
    */
    function resetStack() {
        if (taskPageStack.depth > 1) {
            taskPageStack.pop();
        }

        tasksPage.toNormalMode();
        screenMode("");
    }

    initialPage: TasksPage { id: tasksPage }
}
