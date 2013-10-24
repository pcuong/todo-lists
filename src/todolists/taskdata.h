/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef TASKDATA_H
#define TASKDATA_H

#include <QObject>
#include <QDataStream>
#include <QDate>


class TaskData : public QObject
{
    Q_OBJECT

public:
    TaskData();
    TaskData(const QString &task,
             bool useDueDate,
             const QDate &dueDate,
             bool checked = false);
    TaskData(const TaskData &task);
    TaskData& operator=(const TaskData &taskData);

public:
    QString task() const;
    bool useDueDate() const;
    QDate dueDate() const;
    bool checked() const;

    void setTask(const QString &task);
    void setUseDueDate(bool useDueDate);
    void setDueDate(const QDate &dueDate);
    void setChecked(bool checked);

    bool duesTodayOrEaerlier() const;

protected:
    QString m_Task;
    bool m_UseDueDate;
    QDate m_DueDate;
    bool m_Checked;    // marked for deletion
};

QDataStream& operator<<(QDataStream &stream, const TaskData &data);
QDataStream& operator>>(QDataStream &stream, TaskData &data);

#endif // TASKDATA_H
