/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef FEEDUPDATER_H
#define FEEDUPDATER_H

#include <QObject>

class FeedUpdater : public QObject
{
    Q_OBJECT
public:

    enum UPDATE_RESULT {
        SUCCESS = 0,
        FAILED = 1,
        NOT_REQUIRED = 2
    };

    explicit FeedUpdater(QObject *parent = 0);

public:
    static const QString feedSourceName;
    
public slots:
    UPDATE_RESULT updateFeed();
};

#endif // FEEDUPDATER_H
