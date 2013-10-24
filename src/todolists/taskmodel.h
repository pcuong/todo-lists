/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QDate>
#include "taskdata.h"

class FeedUpdater;

class TaskModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(QString modelName READ modelName WRITE setModelName
               NOTIFY modelNameChanged)

public:
    enum TaskRoles {
        TaskRole = Qt::UserRole + 1,
        UseDueDateRole,
        DueDateRole,
        CheckedRole
    };

    TaskModel(QObject *parent = 0);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &rowIndex,
                  int role = Qt::DisplayRole) const;

    QString modelName() const;
    void setModelName(const QString &modelName);

public slots:
    void addTask(const QString &task, bool useDueDate,
                             const QDate &dueDate);
    void editTaskData(int rowIndex, const QString &task,
                                  bool useDueDate, const QDate &dueDate,
                                  bool checked);
    void moveItem(int fromIndex, int toIndex);
    void resetCheckedProperties();
    void removeTasks();

    void revertSort();
    void saveSortState();

signals:
    void countChanged();
    void modelNameChanged();

protected:
    void loadModel();
    void saveModel();

protected:
    QList<TaskData> m_Tasks;
    QList<TaskData> m_TasksCopy;
    QString m_ModelName;

#ifdef Q_WS_HARMATTAN
    FeedUpdater *m_FeedUpdater; // Owned
#endif
};


#endif // TASKMODEL_H
