#include "taskdata.h"

/*!
  \class TaskData
  \brief Custom QML data element to transfer task data to the QML UI. Class
         has also stream operators to allow serialization of TaskData object.
*/


/*!
  Constructor, makes empty task data.
*/
TaskData::TaskData()
    : m_Task(""),
      m_UseDueDate(false),
      m_DueDate(),
      m_Checked(false)
{
}


/*!
  Constructor, initializes task data.
*/
TaskData::TaskData(const QString &task,
                   bool useDueTask,
                   const QDate &dueDate,
                   bool checked)
    : m_Task(task),
      m_UseDueDate(useDueTask),
      m_DueDate(dueDate),
      m_Checked(checked)
{
}


/*!
  Copy constructor.
*/
TaskData::TaskData(const TaskData &taskData)
    : QObject(),
      m_Task(taskData.m_Task),
      m_UseDueDate(taskData.m_UseDueDate),
      m_DueDate(taskData.m_DueDate),
      m_Checked(taskData.m_Checked)
{
}


/*!
  Assigment operator.
*/
TaskData& TaskData::operator=(const TaskData &taskData)
{
    m_Task = taskData.m_Task;
    m_UseDueDate = taskData.m_UseDueDate;
    m_DueDate = taskData.m_DueDate;
    m_Checked = taskData.m_Checked;

    return *this;
}


/*!
  Getter for m_Task.
*/
QString TaskData::task() const
{
    return m_Task;
}


/*!
  Getter for m_UseDueDate.
*/
bool TaskData::useDueDate() const
{
    return m_UseDueDate;
}


/*!
  Getter for m_DueDate.
*/
QDate TaskData::dueDate() const
{
    return m_DueDate;
}


/*!
  Getter for m_Checked.
*/
bool TaskData::checked() const
{
    return m_Checked;
}


/*!
  Setter for m_Task.
*/
void TaskData::setTask(const QString &task)
{
    m_Task = task;
}


/*!
  Setter for m_UseDueDate.
*/
void TaskData::setUseDueDate(bool useDueDate)
{
    m_UseDueDate = useDueDate;
}


/*!
  Setter for m_DueDate.
*/
void TaskData::setDueDate(const QDate &dueDate)
{
    m_DueDate = dueDate;
}


/*!
  Setter for m_Checked.
*/
void TaskData::setChecked(bool checked)
{
    m_Checked = checked;
}


/*!
  Returns true if due date is in use and it dues today or earlier.
*/
bool TaskData::duesTodayOrEaerlier() const
{
    if (m_UseDueDate && m_DueDate <= QDate::currentDate()) {
        return true;
    }

    return false;
}


/*!
  Stream operator to place TaskData to the given stream. The m_Checked will not
  be stored to the stream as it is only temporary member in model to mark the
  tasks that will be deleted.
*/
QDataStream& operator<<(QDataStream &stream, const TaskData &data)
{
    return stream << data.task() << data.useDueDate() << data.dueDate();
}


/*!
  Stream operator to get the TaskData from given stream.
*/
QDataStream& operator>>(QDataStream &stream, TaskData &data)
{
    QString task;
    bool useDueDate;
    QDate dueDate;

    stream >> task >> useDueDate >> dueDate;

    data = TaskData(task, useDueDate, dueDate);

    return stream;
}
