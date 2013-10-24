/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "feedupdater.h"

#include <gconfitem.h>
#include <meventfeed.h>
#include "taskdata.h"


/*!
  \class FeedUpdated
  \brief Handles the updating of Events Feed on the Harmattan platform.
         The feed is updated when the updateFeed method is called.
         This class is used by both SyncFW and ToDo Lists to update the
         feed.
*/


// The source name of the ToDo Lists feed. Used to identify the ToDo Lists
// feed items in the Events feed.
const QString FeedUpdater::feedSourceName = "SyncFW-ToDoListsFeed";

/*!
  Constructor.
*/
FeedUpdater::FeedUpdater(QObject *parent) :
    QObject(parent)
{
}


/*!
  Reads the task lists files and checks if there is any tasks that due today,
  updates the Events feed accordingly.
  Return values will report the status of update.
*/
FeedUpdater::UPDATE_RESULT FeedUpdater::updateFeed()
{
    // Remove old instances in the feed.
    MEventFeed::instance()->removeItemsBySourceName(feedSourceName);

    GConfItem enabledConfItem("/apps/ControlPanel/ToDoLists/EnableFeed");

    QVariant enabledVariant = enabledConfItem.value();
    if (enabledVariant.isValid()) {
        bool enabled = enabledVariant.toBool();
        if (!enabled) {
            return NOT_REQUIRED;
        }
    }
    else {
        enabledConfItem.set(true);
    }

    QDir dir("/home/user/.todolists");
    QFileInfoList files = dir.entryInfoList(QStringList("*.dat"),
                                            QDir::Files);

    QList<TaskData> dueTasks;

    foreach (const QFileInfo &taskFile, files) {
        QFile file(taskFile.absoluteFilePath());

        // Load the model from file.
        if (file.open(QIODevice::ReadOnly)) {
            QDataStream dataStream(&file);

            TaskData taskData;

            while(!dataStream.atEnd()) {
                dataStream >> taskData;
                if (taskData.duesTodayOrEaerlier()) {
                    dueTasks << taskData;
                }
            }
        }
    }

    if (dueTasks.empty()) {
        return SUCCESS;
    }

    QString bodyText;

    foreach (const TaskData taskData, dueTasks) {
        bodyText.append(QString("%1<br />").arg(taskData.task()));
    }

    // Remove the last "<br />" from the end.
    bodyText.chop(6);

    qlonglong id = MEventFeed::instance()->addItem(
                QString("/usr/share/icons/hicolor/80x80/apps/todolists80x80.png"),
                QString("ToDo Lists task(s) due"),
                bodyText,
                QStringList(),
                QDateTime::currentDateTime(),
                QString(),
                false,
                QUrl("todolists://test"),
                QString("SyncFW-ToDoListsFeed"),
                QString("ToDo Lists feed"));

    if (id != -1) {
        return SUCCESS;
    }
    else {
        return FAILED;
    }
}
