/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include "taskmodel.h"

#include <QtCore>
#include <qdeclarative.h>

#ifdef Q_WS_HARMATTAN
// For updating events feed
#include "../todolists-events-feed-client/feedupdater.h"
#endif


/*!
  \class TaskModel
  \brief Custom list model to provide task information to QML. On Harmattan
         platform, when the data is stored in to the files, the Event Feed
         will be updated too.
*/


/*!
  Constructor, sets the roles for data. QML will query data with these roles.
*/
TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[TaskRole] = "task";
    roles[UseDueDateRole] = "useDueDate";
    roles[DueDateRole] = "dueDate";
    roles[CheckedRole] = "checked";
    setRoleNames(roles);

#ifdef Q_WS_HARMATTAN
    m_FeedUpdater = new FeedUpdater(this);
#endif
}


/*!
  Adds a new task to the task model to the end of the list.
*/
void TaskModel::addTask(const QString &task, bool useDueDate,
                        const QDate &dueDate)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_Tasks << TaskData(task, useDueDate, dueDate);
    endInsertRows();

    saveModel();

    emit countChanged();
}


/*!
  Resets the checked member of the TaskDatas in model to false.
*/
void TaskModel::resetCheckedProperties()
{
    beginResetModel();

    QList<TaskData>::iterator it = m_Tasks.begin();

    while (it != m_Tasks.end()) {
        it->setChecked(false);
        it++;
    }

    endResetModel();
}


/*!
  Removes the tasks that are checked.
*/
void TaskModel::removeTasks()
{
    beginResetModel();

    QList<TaskData>::iterator it = m_Tasks.begin();
    while (it != m_Tasks.end()) {
        if (it->checked()) {
            it = m_Tasks.erase(it);
        }
        else {
            it++;
        }
    }

    endResetModel();

    saveModel();

    emit countChanged();
}


/*!
  Returns the row count.
*/
int TaskModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_Tasks.count();
}


/*!
  Returns the data in given row and role.
*/
QVariant TaskModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_Tasks.count())
        return QVariant();

    const TaskData &taskData = m_Tasks[index.row()];
    if (role == TaskRole) {
        return taskData.task();
    }
    else if (role == UseDueDateRole) {
        return taskData.useDueDate();
    }
    else if (role == DueDateRole) {
        return taskData.dueDate();
    }
    else if (role == CheckedRole) {
        return taskData.checked();
    }

    return QVariant();
}


/*!
  Modifies the model on given row with given values.
*/
void TaskModel::editTaskData(int rowIndex,
                             const QString &task,
                             bool useDueDate,
                             const QDate &dueDate,
                             bool checked)
{
    if (rowIndex < 0 || rowIndex > m_Tasks.count()) {
        return;
    }

    TaskData &taskData = m_Tasks[rowIndex];
    taskData.setTask(task);
    taskData.setUseDueDate(useDueDate);
    taskData.setDueDate(dueDate);
    taskData.setChecked(checked);

    QModelIndex modelIndex = index(rowIndex);

    saveModel();

    emit dataChanged(modelIndex, modelIndex);
}


/*!
  Moves task in model from index to index.
*/
void TaskModel::moveItem(int fromIndex, int toIndex)
{
    if (fromIndex < 0 || fromIndex >= m_Tasks.size() ||
            toIndex < 0 || toIndex > m_Tasks.size()) {
        return;
    }

    if (fromIndex < toIndex) {
        if (!beginMoveRows(QModelIndex(), fromIndex, fromIndex, QModelIndex(),
                           toIndex+1)) {
            return;
        }
    }
    else {
        if (!beginMoveRows(QModelIndex(), fromIndex, fromIndex, QModelIndex(),
                           toIndex)) {
            return;
        }
    }

    m_Tasks.move(fromIndex, toIndex);
    endMoveRows();

    saveModel();
}


/*!
  Saves in sort order of the model in temporary memory. The sort state can be
  reverted to this state later.
*/
void TaskModel::saveSortState()
{
    m_TasksCopy = m_Tasks;
}


/*!
  Reverts the sorting order to a state when saveSortState was called.
*/
void TaskModel::revertSort()
{
    beginResetModel();
    m_Tasks = m_TasksCopy;
    endResetModel();

    m_TasksCopy.clear();
}


/*!
  Getter for m_ModelName.
*/
QString TaskModel::modelName() const
{
    return m_ModelName;
}


/*!
  Setter for m_ModelName. Loads the file content (if exists) to the model.
*/
void TaskModel::setModelName(const QString &modelName)
{
    m_ModelName = modelName;

    loadModel();

    emit modelNameChanged();
    emit countChanged();
}


/*!
  Loads saved content to the model from m_File.
*/
void TaskModel::loadModel()
{
#ifdef Q_WS_HARMATTAN
    QFile file(QString("/home/user/.todolists/%1.dat").arg(m_ModelName));
#else
    QFile file(m_ModelName + ".dat");
#endif

    QDataStream dataStream;

    // Load the model from file.
    if (file.open(QIODevice::ReadOnly)) {
        dataStream.setDevice(&file);

        QList<TaskData> tasks;
        TaskData taskData;

        while(!dataStream.atEnd()) {
            dataStream >> taskData;
            tasks.append(taskData);
        }

        beginResetModel();
        m_Tasks = tasks;
        endResetModel();
    }
}


/*!
  Saves the model content to m_File.
*/
void TaskModel::saveModel()
{
    if (m_ModelName.isEmpty()) {
        return;
    }

#ifdef Q_WS_HARMATTAN
    QDir dir;
    dir.mkpath("/home/user/.todolists");
    QFile file(QString("/home/user/.todolists/%1.dat").arg(m_ModelName));
#else
    QFile file(m_ModelName + ".dat");
#endif
    QDataStream dataStream;

    if (file.open(QIODevice::WriteOnly)) {
        dataStream.setDevice(&file);

        foreach (const TaskData &taskData, m_Tasks) {
            dataStream << taskData;
        }

        // Close the file as the feed updater will read the tasks from the
        // file and it will fail, if the file is open in here.
        file.close();
    }

#ifdef Q_WS_HARMATTAN
    m_FeedUpdater->updateFeed();
#endif
}

QML_DECLARE_TYPE(TaskModel)
