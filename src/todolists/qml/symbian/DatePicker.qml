/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import CustomElements 1.0
import "../common"

Page {
    id: datePickerPage

    property date selectedDate

    /*!
      Sets the initial date, the date model is filled with items starting from
      the initial date.
    */
    function setInitialDate(date) {
        selectedDate = date;

        dateModel.clear();
        var itemCount = Math.floor(Math.max(view.width, view.height) /
                                   view.delegateHeight) * 2 + 2;

        for (var i=0; i<itemCount; i++) {
            dateModel.append({"date": qtHelper.sumDates(selectedDate, i)});
        }

        updateModel(0);
    }

    /*!
      Closes the page, sets the screen from fullscreen to normal mode.
    */
    function closePage(done) {
        var pageStack = datePickerPage.pageStack;
        pageStack.pop();
        pageStack.screenMode("");

        if (done) {
            var detailsPage = pageStack.currentPage;
            detailsPage.dueDate = datePickerPage.selectedDate;
            detailsPage.forceActiveFocus();
        }
    }

    /*!
      Updates the date model beginning from the center index going towards the
      each end.
    */
    function updateModel(centerIndex) {
        if (dateModel.count === 0) {
            return;
        }

        if (centerIndex >= dateModel.count-1) {
            return;
        }

        // Get the date from current model item
        var date = dateModel.get(centerIndex).date;


        var neg = 1;
        for (var i=1; i<dateModel.count; i++) {
            var offset = Math.floor((i-1) / 2 + 1) * neg;

            var index = centerIndex + offset;
            if (index >= 0) {
                index = index % view.count;
            }
            else {
                index = view.count + index;
            }

            dateModel.setProperty(index, "date",
                                  qtHelper.sumDates(date, offset));
            neg *= -1;
        }

        // Update the date as selected date.
        selectedDate = date;
    }

    tools: ToolBarLayout {
        id: acceptDateToolBarLayout

        ToolButton {
            visible: false
        }

        ToolButton {
            text: "Done"
            onClicked: { closePage(true); }
        }

        ToolButton {
            text: "Cancel"
            onClicked: { closePage(false); }
        }

        ToolButton {
            visible: false
        }
    }

    ListModel { id: dateModel }

    Background { }

    Component {
        id: delegate

        ListItem {
            id: rect

            width: view.width; height: view.delegateHeight
            onClicked: {
                if (view.currentIndex === index)
                    closePage(true);
                else
                    view.currentIndex = index;
            }
            opacity: 0.8

            ListItemText {
                anchors.centerIn: parent
                color: "white"
                text: qtHelper.dateString(date)
            }
        }
    }

    Rectangle {
        id: highLight

        anchors.verticalCenter: view.verticalCenter

        width: parent.width
        height: view.delegateHeight

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1080dd" }
            GradientStop { position: 0.98; color: "#54a4e7" }
            GradientStop { position: 1; color: "#6eb2ea" }
        }
    }

    PathView {
        id: view

        property int delegateHeight: platformStyle.graphicSizeLarge
        property real startY: (dateModel.count * delegateHeight - height) / -2
        property real endY: -startY + height

        anchors {
            top: parent.top
            bottom: parent.bottom; bottomMargin: 2
            left: parent.left
            right: parent.right
        }

        onCurrentIndexChanged: { datePickerPage.updateModel(currentIndex); }

        highlightRangeMode: PathView.StrictlyEnforceRange
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        model: dateModel
        clip: true
        delegate: delegate

        path: Path {
            startX: view.width / 2
            startY: view.startY

            PathLine {
                x: view.width / 2
                y: view.endY
            }
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Up) {
            if (view.currentIndex == 0) {
                view.currentIndex = view.count - 1
            }
            else {
                view.currentIndex--
            }
        }
        else if (event.key === Qt.Key_Down) {
            view.currentIndex++
        }
        else if (event.key === Qt.Key_Enter ||
                 event.key === Qt.Key_Return ||
                 event.key === Qt.Key_Select) {
            closePage(true)
        }
    }
}
