/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef QT_HELPER_H
#define QT_HELPER_H

#include <QObject>
#include <QDateTime>
#include <QVariant>


class QSettings;

class QtHelper : public QObject
{
    Q_OBJECT

public:
    explicit QtHelper(QObject *parent = 0);
    
public:
    Q_INVOKABLE int daysFromToday(const QDateTime &date) const;
    Q_INVOKABLE QDateTime sumDates(const QDateTime &date, int addDays) const;
    Q_INVOKABLE QString dateString(const QDateTime &date) const;

public slots:
    void saveSetting(const QVariant &key, const QVariant &value);
    QVariant loadSetting(const QVariant &key,
                         const QVariant &defaultValue);
    void enableSwipe(bool enable);

protected:
    QSettings *m_Settings; // Owned
};

#endif // QT_HELPER_H
